package main

import (
	"bytes"
	"database/sql"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

// Vote information
type Vote struct {
	Name      string
	Address   string
	Mynumber  string
	Candidate string
	Keyword   string
	VoteCount string
}

// Candidate information
type Candidate struct {
	ID    string
	Name  string
	Party string
	Sex   string
}

var db *sql.DB

func init() {
	dbUser := os.Getenv("MYSQL_USER")
	dbPass := os.Getenv("MYSQL_PASS")
	dbHost := os.Getenv("MYSQL_HOST")
	var err error
	db, err = sql.Open("mysql", dbUser+":"+dbPass+"@tcp("+dbHost+":3306)/ishocon2")
	if err != nil {
		log.Fatal(err)
	}
}


func postMessage(message string) {
	now := time.Now().Unix()
	jsonStr := `{"content":"` + message + `","timestamp":"` + strconv.FormatInt(now, 10) + `"}`
	req, _ := http.NewRequest("POST",
		"https://ishocon2.firebaseio.com/messages/"+username+".json",
		bytes.NewBuffer([]byte(jsonStr)))
	req.Header.Set("Content-Type", "application/json")
	client := clients[rand.Intn(len(clients))]

	client.Do(req)
}

func postResult(score int, success int, failure int) {
	now := time.Now().Unix()
	jsonStr := `{"score":` + strconv.Itoa(totalScore) +
		`,"success":` + strconv.Itoa(success) +
		`,"failure":` + strconv.Itoa(failure) +
		`,"timestamp":` + strconv.FormatInt(now, 10) + `}`
	req, _ := http.NewRequest("POST",
		"https://ishocon2.firebaseio.com/teams/"+username+".json",
		bytes.NewBuffer([]byte(jsonStr)))
	req.Header.Set("Content-Type", "application/json")
	client := clients[rand.Intn(len(clients))]

	client.Do(req)
}

func flushMessage() {
	req, _ := http.NewRequest("DELETE", "https://ishocon2.firebaseio.com/messages/"+username+".json", nil)
	client := clients[rand.Intn(len(clients))]
	client.Do(req)
}

func setupVotes(size int, forValidate bool) []Vote {
	var voteSet []Vote

	// size 人数分の投票者を選ぶ
	query := "SELECT name, address, mynumber, votes FROM users WHERE id IN ("
	for i := 0; i < size; i++ {
		id := strconv.Itoa(getRand(1, 4000000))
		query = query + id + ","
	}
	query = query + "0)"

	rows, err := db.Query(query)
	if err != nil {
		panic(err.Error())
	}
	defer rows.Close()
	for rows.Next() {
		var v Vote
		var strMaxVoteCount string
		err = rows.Scan(&v.Name, &v.Address, &v.Mynumber, &strMaxVoteCount)
		maxVoteCount, _ := strconv.Atoi(strMaxVoteCount)
		if forValidate {
			v.VoteCount = strconv.Itoa(getRand(1, 4))
		} else {
			v.VoteCount = strconv.Itoa(getRand(1, maxVoteCount))
		}
		v.Candidate = getRandCandidate()
		v.Keyword = getRandKeyword()

		voteSet = append(voteSet, v)
	}

	return voteSet
}

// from から to までの値をランダムに取得
func getRand(from int, to int) int {
	rand.Seed(time.Now().UnixNano())
	return rand.Intn(to+1-from) + from
}

func getRandCandidate() string {
	set := []string{"佐藤 一郎", "佐藤 次郎", "佐藤 三郎", "佐藤 四郎", "佐藤 五郎", "鈴木 一郎", "鈴木 次郎", "鈴木 三郎", "鈴木 四郎", "鈴木 五郎", "高橋 一郎", "高橋 次郎", "高橋 三郎", "高橋 四郎", "高橋 五郎", "田中 一郎", "田中 次郎", "田中 三郎", "田中 四郎", "田中 五郎", "渡辺 一郎", "渡辺 次郎", "渡辺 三郎", "渡辺 四郎", "渡辺 五郎", "伊藤 一郎", "伊藤 次郎", "伊藤 三郎", "伊藤 四郎", "伊藤 五郎"}
	n := getRand(0, 8)
	id := 0
	if n == 0 {
		id = 3
	} else if n == 1 {
		id = 19
	} else if n == 2 {
		id = 22
	} else if n == 3 || n == 4 {
		id = getRand(0, 10)
	} else if n == 5 {
		id = getRand(1, 20)
	} else if n == 6 {
		id = getRand(25, 29)
	} else {
		id = getRand(13, 22)
	}
	return set[id]
}

func getRandKeyword() string {
	set := []string{
		"他にまともな候補者がいないため",
		"誠実さ",
		"若いから",
		"女性の輝く社会を実現しようと公約を掲げていたため",
		"若干極端な選択だが、この様な声があるのは悪い事ではない。他に良い立候補者がいない。個人的には、左寄りが必要。世界的に見て「ナショナリズム」が台頭しているためこの国も染まってしまう前に左寄りへ。でも極端に左なのは絶対に嫌だ",
		"政策を吟味した結果。あの党の政策は反対だと感じたため、そこに対抗しうる政党を選んだ",
		"ノーコメント",
		"他にまともな候補者がいないため",
		"誰もが人間らしく生きられる社会をめざしているため",
		"若手で、また、働く環境や貧困について真剣に考えてくれているように感じたから",
		"全候補者について、学歴や経歴は見ず、政策や演説だけで判断した結果、最も自分が描いていた社会に近かったから",
		"政権交代して欲しかったため",
		"経歴",
		"愛に対する考え方",
		"実際にお会いする機会があった際、若い世代の問題に取り組む姿勢があり、また質問に誠実に答えてくれる印象を受けたから",
		"税金を無駄遣いしてくれそうだから",
		"私と名前が同じだったから",
		"親戚と顔が似ていたから",
		"一番最初に目に入った名前だったから",
		"気分",
		"顔が好み",
		"声に惹かれた",
		"自分の所属する政党の候補者だったから",
		"教えてたくない",
		"自分でもなぜか分からない",
	}
	seed := getRand(1, 4)
	i := 0
	if seed == 1 {
		i = 0
	} else if seed == 2 {
		i = getRand(0, 10)
	} else if seed == 3 {
		i = getRand(0, 20)
	} else {
		i = getRand(21, 24)
	}
	return set[i]
}

func getCndInfo(name string) Candidate {
	var c Candidate
	err := db.QueryRow("SELECT * FROM candidates WHERE name = ? LIMIT 1", name).Scan(&c.ID, &c.Name, &c.Party, &c.Sex)
	if err != nil {
		panic(err.Error())
	}
	return c
}

// 候補者名から政党名を返す
func getPatryInfo(name string) string {
	var party string
	err := db.QueryRow("SELECT political_party FROM candidates WHERE name = ? LIMIT 1", name).Scan(&party)
	if err != nil {
		panic(err.Error())
	}
	return party
}

func membersOf(party string) (members []string) {
	rows, err := db.Query("SELECT name FROM candidates WHERE political_party = ?", party)
	if err != nil {
		panic(err.Error())
	}
	defer rows.Close()
	for rows.Next() {
		var name string
		err = rows.Scan(&name)
		if err != nil {
			panic(err.Error())
		}
		members = append(members, name)
	}

	return
}
