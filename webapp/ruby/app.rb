require 'sinatra/base'
require 'mysql2'
require 'mysql2-cs-bind'
require 'erubis'
require 'digest'
require 'date'

module Ishocon2
  class AuthenticationError < StandardError; end
  class PermissionDenied < StandardError; end
end

class Ishocon2::WebApp < Sinatra::Base
  session_secret = ENV['ISHOCON2_SESSION_SECRET'] || 'showwin_happy'
  use Rack::Session::Cookie, key: 'rack.session', secret: session_secret
  set :erb, escape_html: true
  set :protection, true

  configure do
    set :last_voted_time, DateTime.now
  end

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
        puts e.message
        puts e.backtrace || 'no backtrace'
        db.query("ROLLBACK")
      end
    end

    def sha1(*args)
      Digest::SHA1.hexdigest(args.join)
    end

    def candidates_cache
      @candidates_cache ||= db.query('SELECT * FROM candidates').map { |c| c }
    end

    def parties_set_cache
      @parties_set_cache ||= candidates_cache.map { |c| c[:political_party] }.uniq
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

    def voice_of_supporter_for_party(candidate_ids)
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

    def voice_of_supporter(candidate_id)
      query = <<SQL
SELECT keyword
FROM votes
WHERE candidate_id = ?
GROUP BY keyword
ORDER BY IFNULL(SUM(count), 0) DESC
LIMIT 10
SQL
      db.xquery(query, candidate_id).map { |a| a[:keyword] }
    end

    def voice_of_supporter_by_candidate_keyword(candidate_ids)
      query = <<SQL
SELECT content as keyword
FROM candidate_keywords
WHERE candidate_id IN (?)
group by content
ORDER BY IFNULL(SUM(count), 0) DESC
LIMIT 10;
SQL
      db.xquery(query, candidate_ids).map { |a| a[:keyword] }
    end

    def db_initialize
      db.query('DELETE FROM votes')
      db.query('DELETE FROM candidate_keywords')
    end
  end

  get '/' do
    candidates = []
    election_results_cache = election_results
    election_results_cache.each_with_index do |r, i|
      # 上位10人と最下位のみ表示
      candidates.push(r) if i < 10 || 28 < i
    end

    # parties_set = db.query('SELECT political_party FROM candidates GROUP BY political_party')
    # parties_set = parties_set_cache
    parties = Hash.new(0)
    election_results_cache.each do |r|
      parties[r[:political_party]] += r[:count] || 0
    end

    sex_ratio = { '男': 0, '女': 0 }
    election_results_cache.each do |r|
      sex_ratio[r[:sex].to_sym] += r[:count] || 0
    end

    last_modified settings.last_voted_time
    etag sha1(candidates, parties, sex_ratio)

    erb :index, locals: { candidates: candidates,
                          parties: parties,
                          sex_ratio: sex_ratio }
  end

  get '/candidates/:id' do
    # candidate = db.xquery('SELECT * FROM candidates WHERE id = ?', params[:id]).first
    candidate = candidates_cache.find { |c| c[:id] == params[:id].to_i }
    return redirect '/' if candidate.nil?
    votes = db.xquery('SELECT IFNULL(SUM(count), 0) as count FROM votes WHERE candidate_id = ?', params[:id]).first&.fetch(:count, 0) || 0
    keywords = voice_of_supporter_by_candidate_keyword([params[:id]])

    last_modified settings.last_voted_time
    etag sha1(candidate, votes, keywords)

    erb :candidate, locals: { candidate: candidate,
                              votes: votes,
                              keywords: keywords }
  end

  get '/political_parties/:name' do
    votes = 0
    election_results_cache = election_results
    election_results_cache.each do |r|
      votes += r[:count] || 0 if r[:political_party] == params[:name]
    end
    candidates = candidates_cache.select { |c| c[:political_party] == params[:name] }
    candidate_ids = candidates.map { |c| c[:id] }
    keywords = voice_of_supporter_by_candidate_keyword(candidate_ids)

    last_modified settings.last_voted_time
    etag sha1(votes, candidates, keywords)

    erb :political_party, locals: { political_party: params[:name],
                                    votes: votes,
                                    candidates: candidates,
                                    keywords: keywords }
  end

  get '/vote' do
    candidates = candidates_cache
    erb :vote, locals: { candidates: candidates, message: '' }
  end

  post '/vote' do
    user = db.xquery('SELECT * FROM users WHERE name = ? AND address = ? AND mynumber = ?',
                     params[:name],
                     params[:address],
                     params[:mynumber]).first
    candidate = candidates_cache.find { |c| c[:name] == params[:candidate] }
    voted_count =
      user.nil? ? 0 : db.xquery('SELECT count FROM votes WHERE user_id = ?', user[:id]).first&.fetch(:count, 0) || 0

    candidates = candidates_cache
    if user.nil?
      return erb :vote, locals: { candidates: candidates, message: '個人情報に誤りがあります' }
    elsif user[:votes] < (params[:vote_count].to_i + voted_count)
      return erb :vote, locals: { candidates: candidates, message: '投票数が上限を超えています' }
    elsif params[:candidate].nil? || params[:candidate] == ''
      return erb :vote, locals: { candidates: candidates, message: '候補者を記入してください' }
    elsif candidate.nil?
      return erb :vote, locals: { candidates: candidates, message: '候補者を正しく記入してください' }
    elsif params[:keyword].nil? || params[:keyword] == ''
      return erb :vote, locals: { candidates: candidates, message: '投票理由を記入してください' }
    end

    transaction do
      db.xquery(
        'INSERT INTO votes (user_id, candidate_id, keyword, count) VALUES (?, ?, ?, ?)',
        user[:id],
        candidate[:id],
        params[:keyword],
        params[:vote_count]
      )
      id = db.xquery(
        'SELECT id from candidate_keywords WHERE candidate_id = ? AND content = ? FOR UPDATE',
        candidate[:id],
        params[:keyword],
      ).first&.fetch(:id, nil)
      if id.nil?
        db.xquery(
          'INSERT INTO candidate_keywords (candidate_id, content, count) VALUES (?, ?, ?)',
          candidate[:id],
          params[:keyword],
          params[:vote_count],
        )
      else
        db.xquery(
          'UPDATE candidate_keywords SET count = count + ? WHERE id = ?',
          params[:vote_count],
          id,
        )
      end
    end


    settings.last_voted_time = DateTime.now
    return erb :vote, locals: { candidates: candidates, message: '投票に成功しました' }
  end

  get '/initialize' do
    db_initialize
  end

  get '/health' do
  end
end
