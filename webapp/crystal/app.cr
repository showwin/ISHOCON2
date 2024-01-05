require "kemal"
require "kemal-session"
require "ecr"
require "mysql"

ENV["ISHOCON2_DB_HOST"] = ENV["ISHOCON2_DB_HOST"]? || "localhost"
ENV["ISHOCON2_DB_PORT"] = ENV["ISHOCON2_DB_PORT"]? || "3306"
ENV["ISHOCON2_DB_USER"] = ENV["ISHOCON2_DB_USER"]? || "ishocon"
ENV["ISHOCON2_DB_PASSWORD"] = ENV["ISHOCON2_DB_PASSWORD"]? || "ishocon"
if ENV["ISHOCON2_DB_PASSWORD"] != ""
  ENV["ISHOCON2_DB_PASSWORD"] = ":" + ENV["ISHOCON2_DB_PASSWORD"]
end
ENV["ISHOCON2_DB_NAME"] = ENV["ISHOCON2_DB_NAME"]? || "ishocon2"
Database = DB.open "mysql://#{ENV["ISHOCON2_DB_USER"]}#{ENV["ISHOCON2_DB_PASSWORD"]}@#{ENV["ISHOCON2_DB_HOST"]}:#{ENV["ISHOCON2_DB_PORT"]}/#{ENV["ISHOCON2_DB_NAME"]}"

public_folder "public"

Kemal::Session.config do |config|
  config.secret = ENV["ISHOCON2_SESSION_SECRET"]? || "showwin_happy"
end

class CandidateWithCount
  getter id : Int32
  getter name : String
  getter political_party : String
  getter sex : String
  getter count : Int64

  def initialize(@id : Int32, @name : String, @political_party : String, @sex : String, @count : Int64)
  end
end

def election_results
  query = <<-SQL
SELECT c.id, c.name, c.political_party, c.sex, v.count
FROM candidates AS c
LEFT OUTER JOIN
  (SELECT candidate_id, COUNT(*) AS count
  FROM votes
  GROUP BY candidate_id) AS v
ON c.id = v.candidate_id
ORDER BY v.count DESC
SQL
  ret = [] of CandidateWithCount
  Database.query query do |r|
    r.each do
      id, name, political_party, sex, count = r.read(Int32, String, String, String, Int64?)
      count = count || 0_i64
      ret.push(CandidateWithCount.new(id, name, political_party, sex, count))
    end
  end
  return ret
end

def voice_of_supporter(candidate_ids : Array(Int32))
  placeholders = candidate_ids.join(", ")
  query = <<-SQL
SELECT keyword
FROM votes
WHERE candidate_id IN (#{placeholders})
GROUP BY keyword
ORDER BY COUNT(*) DESC
LIMIT 10
SQL
  ret = [] of String
  Database.query query do |r|
    r.each do
      ret.push(r.read(String))
    end
  end
  return ret
end

def db_initialize
  Database.exec "DELETE FROM votes"
end

get "/" do
  candidates = [] of CandidateWithCount
  election_results.map_with_index do |r, i|
    # 上位10人と最下位のみ表示
    if i < 10 || 28 < i
      candidates.push(r)
    end
  end

  parties_set = Database.query_all "SELECT political_party FROM candidates GROUP BY political_party", as: {String}
  parties = {} of String => Int32
  parties_set.each do |a|
    parties[a] = 0
  end
  election_results.each do |r|
    parties[r.political_party] += r.count || 0
  end

  sex_ratio = {"男" => 0, "女" => 0}
  election_results.each do |r|
    sex_ratio[r.sex] += r.count
  end

  render "views/index.ecr", "views/layout.ecr"
end

class Candidate
  getter id : Int32
  getter name : String
  getter political_party : String
  getter sex : String

  def initialize(@id : Int32, @name : String, @political_party : String, @sex : String)
  end
end

get "/candidates/:id" do |env|
  candidate = Candidate.new(0, "", "", "")
  begin
    id, name, political_party, sex = Database.query_one "SELECT * FROM candidates WHERE id = ?", env.params.url["id"], as: {Int32, String, String, String}
    candidate = Candidate.new(id, name, political_party, sex)
  rescue
    env.redirect "/"
  end

  votes = Database.query_one "SELECT COUNT(*) AS count FROM votes WHERE candidate_id = ?", env.params.url["id"], as: {Int64}
  keywords = voice_of_supporter([env.params.url["id"].to_i])

  render "views/candidate.ecr", "views/layout.ecr"
end

get "/political_parties/:name" do |env|
  votes = 0
  election_results.each do |r|
    if r.political_party == env.params.url["name"]
      votes += r.count || 0
    end
  end
  candidates = [] of Candidate
  Database.query "SELECT * FROM candidates WHERE political_party = ?", env.params.url["name"] do |r|
    r.each do
      id, name, political_party, sex = r.read(Int32, String, String, String)
      candidates.push(Candidate.new(id, name, political_party, sex))
    end
  end
  candidate_ids = candidates.map { |c| c.id }
  keywords = voice_of_supporter(candidate_ids)
  political_party = env.params.url["name"]

  render "views/political_party.ecr", "views/layout.ecr"
end

get "/vote" do
  candidates = [] of Candidate
  Database.query "SELECT * FROM candidates" do |r|
    r.each do
      id, name, political_party, sex = r.read(Int32, String, String, String)
      candidates.push(Candidate.new(id, name, political_party, sex))
    end
  end
  message = ""

  render "views/vote.ecr", "views/layout.ecr"
end

class User
  getter id : Int32
  getter name : String
  getter address : String
  getter mynumber : String
  getter votes : Int32

  def initialize(@id : Int32, @name : String, @address : String, @mynumber : String, @votes : Int32)
  end
end

post "/vote" do |env|
  message = ""
  user = User.new(0, "", "", "", 0)
  begin
    id, name, address, mynumber, votes = Database.query_one "SELECT * FROM users WHERE name = ? AND address = ? AND mynumber = ?",
      env.params.body["name"],
      env.params.body["address"],
      env.params.body["mynumber"], as: {Int32, String, String, String, Int32}
    user = User.new(id, name, address, mynumber, votes)
  rescue
    message = "個人情報に誤りがあります"
  end

  voted_count_n = Database.query_one "SELECT COUNT(*) AS count FROM votes WHERE user_id = ?", user.id, as: {Int64?}
  voted_count = voted_count_n || 0_i64
  if message == "" && (!env.params.body["vote_count"] || user.votes < (env.params.body["vote_count"].to_i + voted_count))
    message = "投票数が上限を超えています"
  end

  if message == "" && (!env.params.body["candidate"] || env.params.body["candidate"] == "")
    message = "候補者を記入してください"
  end

  candidate = Candidate.new(0, "", "", "")
  begin
    id, name, political_party, sex = Database.query_one "SELECT * FROM candidates WHERE name = ?", env.params.body["candidate"], as: {Int32, String, String, String}
    candidate = Candidate.new(id, name, political_party, sex)
  rescue
    if message == ""
      message = "候補者を正しく記入してください"
    end
  end

  candidates = [] of Candidate
  Database.query "SELECT * FROM candidates" do |r|
    r.each do
      id, name, political_party, sex = r.read(Int32, String, String, String)
      candidates.push(Candidate.new(id, name, political_party, sex))
    end
  end

  if message == "" && (!env.params.body["keyword"] || env.params.body["keyword"] == "")
    message = "投票理由を記入してください"
  end

  if message == ""
    env.params.body["vote_count"].to_i.times do
      Database.exec "INSERT INTO votes (user_id, candidate_id, keyword) VALUES (?, ?, ?)",
        user.id,
        candidate.id,
        env.params.body["keyword"]
    end
    message = "投票に成功しました"
  end

  render "views/vote.ecr", "views/layout.ecr"
end

get "/initialize" do
  db_initialize
end

get "/health" do
end

Kemal.run port = 8080
