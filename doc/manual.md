# ISHOCON2マニュアル
## 時間制限
あなたがISHOCON2に興味を持ち続けている間。
制限時間を設ける場合には8時間前後が良いと思います。

## インスタンスの作成
AWSのイメージのみ作成しました。
* アプリケーションAMI: `ami-09568651b65f0daf1`
* ベンチマーカーAMI: `ami-78b66107`
* アプリケーション、ベンチマーカー共に以下のスペック
  * Instance Type: c5.large
  * Root Volume: 8GB, General Purpose SSD (GP2)

要望があればGCPでもイメージを作成するかもしれません。

参考画像  
* 8GB, General Purpose SSD (GP2) を選択してください。
![](https://raw.githubusercontent.com/showwin/ISHOCON2/master/doc/images/instance1.png)

* Security Groupの設定で `TCP 22 (SSH)` と `TCP 443 (HTTPS)` を `Inbound 0.0.0.0/0` からアクセスできるようにしてください。(ベンチマーカーの場合 `TCP 443 (HTTPS)` を開ける必要はありません。)
![](https://raw.githubusercontent.com/showwin/ISHOCON2/master/doc/images/instance2.png)

* 最後の確認画面でこのようになっていればOKです。
![](https://raw.githubusercontent.com/showwin/ISHOCON2/master/doc/images/instance3.png)

## アプリケーションの起動
### アプリケーションインスタンスにログインする

```
$ ssh -i ~/.ssh/your_private_key.pem ubuntu@xxx.xxx.xxx.xxx
```

### ishocon ユーザに切り替える
```
$ sudo su - ishocon
```

```
$ ls
 data    #DB初期化用のdump(後述)
 webapp  #最適化するアプリケーション
```

### Web サーバーを立ち上げる

#### Ruby の場合

```
$ cd ~/webapp/ruby
$ unicorn -c unicorn_config.rb
```

#### Python の場合

```
$ cd ~/webapp/python
$ uwsgi --ini app.ini
```

#### Go の場合

```
$ cd ~/webapp/go
$ go get -t -d -v ./...
$ go build -o webapp *.go
$ ./webapp
```

#### PHP の場合

```
$ cd ~/webapp/php
$ cat README.md
```

#### NodeJS の場合

```
$ cd ~/webapp/nodejs
$ npm install
$ node index.js
```

#### Crystal の場合

```
$ cd ~/webapp/crystal
$ shards install
$ crystal app.cr
```

これでブラウザからアプリケーションが見れるようになるので、IPアドレスにアクセスしてみましょう。  
HTTPS でのみアクセスできることに注意してください。ブラウザによっては証明書のエラーが表示されますが、無視してページを表示してください。

**トップページ**
![トップページ](https://raw.githubusercontent.com/showwin/ISHOCON2/master/doc/images/top.png)

`/vote` から投票が可能です。例えば以下のユーザで投票ができます。
* 氏名: `ウスイ シュンロウ`
* 住所: `宮崎県`
* 私の番号: `67895586`
* 候補者: 誰かを選択する
* 投票理由: 適当な文字列を記入する
* 投票数: 89 以下の数字 (このユーザは89票の投票権を持っています)

**投票画面**
![投票画面](https://raw.githubusercontent.com/showwin/ISHOCON2/master/doc/images/vote.png)


### データベースの設定
3306 番ポートで MySQL(5.5) が起動しています。初期状態では以下のユーザが設定されています。
* ユーザ名: ishocon, パスワード: ishocon
* ユーザ名: root, パスワード: ishocon

別のバージョンのMySQLに変更することも可能です。  
その場合、初期データの挿入は
```
$ cd
$ mysql -u ishocon -pishocon ishocon2 < ./data/ishocon2.dump
```
で行うことができます。  
既存のMySQLを使う限りはこれを実行する必要はありません。

## ベンチマーカーの使い方
### ベンチマーカーインスタンスにログインする

```
$ ssh -i ~/.ssh/your_private_key.pem ubuntu@xxx.xxx.xxx.xxx
$ ls
 benchmark  #ベンチマーカー
```

### ベンチマーカーの実行
```
$ ./benchmark --ip xxx.xxx.xxx.xxx --workload 3
```
* ベンチマーカーは並列実行可能で、負荷量を `--workload` オプションで指定することができます。オプションで指定しない場合は3で実行されます。
* アプリケーションが起動しているIPアドレスを `--ip` オプションで指定してください。

### ベンチマーカーの挙動
1分間の負荷走行によりスコアを算出しますが、リクエストのパターンが途中で切り替わります。

1. `/initialize` にアクセスしてデータを初期化します。(10秒以内にレスポンスを返す必要があります)
1. 期日前投票: 投票の結果が正しく結果表示ページに反映されていることを確認します。この間のリクエストはスコアには影響しません。
1. 投票開始(45秒間): 投票が行われます。アプリケーションの高速化が十分でない場合、45秒を過ぎても数秒間投票が続くことがありますが、これはベンチマーカーの仕様です。
1. 投票結果確認(15秒間): 投票結果の確認が行われます。投票時と同様に15秒を数秒過ぎてベンチマーカーが終わることがありますが、仕様です。

### スコア算出方法
* スコアはベンチマーカーが1分間の負荷走行を行っている間にレスポンスが返された `成功レスポンス数(GET) x 2 + 成功レスポンス数(POST) x 1 - 失敗レスポンス数(200以外) x 100` により算出されます。
* 期日前投票にて、期待しないレスポンスが返ってきた場合にはその時点でベンチマーカーが停止し、スコアは表示されません。
* 投票が1度でも失敗(200でないレスポンス)するとその時点でベンチマーカーが停止し、スコアは表示されません。投票は必ず成功する必要があります。


## その他
### 許されないこと
* インスタンスを複数台用いることや、規定のインスタンスと別のタイプを使用すること。
* ブラウザからアクセスして目視した場合に、初期実装と異なること。
  * 目視で違いが分からなければOKです。
* ベンチマーカーを改変すること。

### 許されること
* DOMを変更する
  * ベンチマーカーにバレなければDOMを変更してもOKです。
* 再起動に耐えられない
  * インスタンスを再起動して、再起動前の状態を復元できる必要はありません。

## 疑問点
[@showwin](https://twitter.com/showwin) にメンションを飛ばすか、 [issues](https://github.com/showwin/ISHOCON2/issues) に書き込んでください。
