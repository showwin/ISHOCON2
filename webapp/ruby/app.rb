require 'sinatra/base'
require 'mysql2'
require 'mysql2-cs-bind'
require 'erubis'

module Ishocon2
  class AuthenticationError < StandardError; end
  class PermissionDenied < StandardError; end
end

class Ishocon2::WebApp < Sinatra::Base
  session_secret = ENV['ISHOCON2_SESSION_SECRET'] || 'showwin_happy'
  use Rack::Session::Cookie, key: 'rack.session', secret: session_secret
  set :erb, escape_html: true
  set :protection, true

  helpers do
    def config
      @config ||= {
        db: {
          host: ENV['ISHOCON2_DB_HOST'] || 'localhost',
          port: ENV['ISHOCON2_DB_PORT'] && ENV['ISHOCON2_DB_PORT'].to_i,
          username: ENV['ISHOCON2_DB_USER'] || 'ishocon',
          password: ENV['ISHOCON2_DB_PASSWORD'] || 'ishocon',
          database: ENV['ISHOCON2_DB_NAME'] || 'ishocon2'
        }
      }
    end

    def db
      return Thread.current[:ishocon2_db] if Thread.current[:ishocon2_db]
      client = Mysql2::Client.new(
        host: config[:db][:host],
        port: config[:db][:port],
        username: config[:db][:username],
        password: config[:db][:password],
        database: config[:db][:database],
        reconnect: true
      )
      client.query_options.merge!(symbolize_keys: true)
      Thread.current[:ishocon2_db] = client
      client
    end

    def transaction(&block)
      raise ArgumentError, "No block was given" unless block_given?
      begin
        db.query("BEGIN")
        yield
        db.query("COMMIT")
      rescue => e
        puts e.backtrace.&join("\n")
        db.query("ROLLBACK")
      end
    end

    def candidates
      @candidates ||= db.query('SELECT * FROM candidates').map do |row|
        {
          id: row[:id],
          name: row[:name],
          political_party: row[:political_party],
          sex: row[:sex],
        }
      end
    end

    def election_results
      query = <<SQL
SELECT c.id, c.name, c.political_party, c.sex, v.count
FROM candidates AS c
LEFT OUTER JOIN
  (SELECT candidate_id, IFNULL(SUM(count), 0) AS count
  FROM votes
  GROUP BY candidate_id) AS v
ON c.id = v.candidate_id
ORDER BY v.count DESC
SQL
      db.xquery(query)
    end

    def voice_of_supporter(candidate_ids)
      query = <<SQL
SELECT keyword
FROM votes
WHERE candidate_id IN (?)
GROUP BY keyword
ORDER BY IFNULL(SUM(count), 0) DESC
LIMIT 10
SQL
      db.xquery(query, candidate_ids).map { |a| a[:keyword] }
    end

    def db_initialize
      db.query('DELETE FROM votes')
      db.query('ALTER TABLE votes ADD INDEX idx_votes_candidate_id (candidate_id)')
      db.query('ALTER TABLE votes ADD COLUMN count int(4) NOT NULL')
      db.query('ALTER TABLE votes ADD CONSTRAINT fk_votes_to_candidate FOREIGN KEY (candidate_id) REFERENCES candidates (id)')
      db.query('ALTER TABLE votes ADD INDEX idx_votes_candidate_and_count (candidate_id, count)')
    end
  end

  get '/' do
    cs = []
    er = election_results
    er.each_with_index do |r, i|
      # 上位10人と最下位のみ表示
      cs.push(r) if i < 10 || 28 < i
    end

    # parties_set = cs.map { |c| c[:political_party] }.uniq
    # parties_set = db.query('SELECT political_party FROM candidates GROUP BY political_party')
    parties = Hash.new(0)
    # parties_set.each do |party|
    #   parties[party] = 0
    # end
    er.each do |r|
      parties[r[:political_party]] += r[:count] || 0
    end

    sex_ratio = { '男': 0, '女': 0 }
    er.each do |r|
      sex_ratio[r[:sex].to_sym] += r[:count] || 0
    end

    erb :index, locals: { candidates: cs,
                          parties: parties,
                          sex_ratio: sex_ratio }
  end

  get '/candidates/:id' do
    # candidate = db.xquery('SELECT * FROM candidates WHERE id = ?', params[:id]).first
    candidate = candidates.find { |c| c[:id] == params[:id] }
    return redirect '/' if candidate.nil?
    votes = db.xquery('SELECT IFNULL(SUM(count), 0) AS count FROM votes WHERE candidate_id = ?', params[:id]).first[:count]
    keywords = voice_of_supporter([params[:id]])
    erb :candidate, locals: { candidate: candidate,
                              votes: votes,
                              keywords: keywords }
  end

  get '/political_parties/:name' do
    votes = 0
    election_results.each do |r|
      votes += r[:count] || 0 if r[:political_party] == params[:name]
    end
    # candidates = db.xquery('SELECT * FROM candidates WHERE political_party = ?', params[:name])
    cs = candidates.select { |c| c[:political_party] == params[:name] }
    candidate_ids = cs.map { |c| c[:id] }
    keywords = voice_of_supporter(candidate_ids)
    erb :political_party, locals: { political_party: params[:name],
                                    votes: votes,
                                    candidates: cs,
                                    keywords: keywords }
  end

  get '/vote' do
    # candidates = db.query('SELECT * FROM candidates')
    erb :vote, locals: { candidates: candidates, message: '' }
  end

  post '/vote' do
    user = db.xquery('SELECT * FROM users WHERE name = ? AND address = ? AND mynumber = ?',
                     params[:name],
                     params[:address],
                     params[:mynumber]).first
    # candidate = db.xquery('SELECT * FROM candidates WHERE name = ?', params[:candidate]).first
    candidate = candidates.find { |c| c[:name] == params[:candidate] }
    voted_count =
      user.nil? ? 0 : db.xquery('SELECT IFNULL(SUM(count), 0) AS count FROM votes WHERE user_id = ?', user[:id]).first[:count]

    if voted_count.nil?
      voted_count = 0
    end

    # candidates = db.query('SELECT * FROM candidates')
    cs = candidates
    if user.nil?
      return erb :vote, locals: { candidates: cs, message: '個人情報に誤りがあります' }
    elsif user[:votes] < (params[:vote_count].to_i + voted_count)
      return erb :vote, locals: { candidates: cs, message: '投票数が上限を超えています' }
    elsif params[:candidate].nil? || params[:candidate] == ''
      return erb :vote, locals: { candidates: cs, message: '候補者を記入してください' }
    elsif candidate.nil?
      return erb :vote, locals: { candidates: cs, message: '候補者を正しく記入してください' }
    elsif params[:keyword].nil? || params[:keyword] == ''
      return erb :vote, locals: { candidates: cs, message: '投票理由を記入してください' }
    end

    insert_query = 'INSERT INTO votes (user_id, candidate_id, keyword, count) VALUES (?, ?, ?, ?)'
    result = db.xquery(insert_query, user[:id], candidate[:id], params[:keyword], params[:vote_count].to_i)

    # transaction do
    #   values = params[:vote_count].to_i.times.map { "(#{user_id}, #{candidate_id}, '#{keyword}')" }.join(', ')
    #   query = [insert_query, values].join("\n")
    # end
    # params[:vote_count].to_i.times do
    #   result = db.xquery('INSERT INTO votes (user_id, candidate_id, keyword) VALUES (?, ?, ?)',
    #             user[:id],
    #             candidate[:id],
    #             params[:keyword])
    # end
    return erb :vote, locals: { candidates: cs, message: '投票に成功しました' }
  end

  get '/initialize' do
    db_initialize
  end

  get '/health' do
  end
end
