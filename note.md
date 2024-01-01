- 初回ベンチ

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443"
2024/01/01 23:15:48 Start GET /initialize
2024/01/01 23:15:48 期日前投票を開始します
2024/01/01 23:15:49 期日前投票が終了しました
2024/01/01 23:15:49 投票を開始します  Workload: 3
2024/01/01 23:16:35 投票が終了しました
2024/01/01 23:16:35 投票者が結果を確認しています
2024/01/01 23:16:50 投票者の感心がなくなりました
2024/01/01 23:16:50 {"score": 6980, "success": 6340, "failure": 0}

~/ghq/github.com/mickamy/ISHOCON2 imp1* 1m 2s
```

- Locale/TZ 設定

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443"
2024/01/01 23:34:15 Start GET /initialize
2024/01/01 23:34:15 期日前投票を開始します
2024/01/01 23:35:03 期日前投票が終了しました
2024/01/01 23:35:03 投票を開始します  Workload: 3
2024/01/01 23:35:50 投票が終了しました
2024/01/01 23:35:50 投票者が結果を確認しています
2024/01/01 23:36:05 投票者の感心がなくなりました
2024/01/01 23:36:05 {"score": 6098, "success": 5474, "failure": 0}

~/ghq/github.com/mickamy/ISHOCON2 imp1* 1m 51s
```

TZ 設定できてない :pieng:

- update ruby to 3.1.4

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443"
2024/01/01 23:41:21 Start GET /initialize
2024/01/01 23:41:21 期日前投票を開始します
2024/01/01 23:41:29 期日前投票が終了しました
2024/01/01 23:41:29 投票を開始します  Workload: 3
2024/01/01 23:42:15 投票が終了しました
2024/01/01 23:42:15 投票者が結果を確認しています
2024/01/01 23:42:31 投票者の感心がなくなりました
2024/01/01 23:42:31 {"score": 6948, "success": 6324, "failure": 0}

~/ghq/github.com/mickamy/ISHOCON2 imp1* 1m 11s
```


- show create table

```
| votes | CREATE TABLE `votes` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `user_id` int(32) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `keyword` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=950393 DEFAULT CHARSET=utf8mb4 |

| users | CREATE TABLE `users` (
  `id` int(32) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `address` varchar(256) NOT NULL,
  `mynumber` varchar(32) NOT NULL,
  `votes` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mynumber` (`mynumber`)
) ENGINE=InnoDB AUTO_INCREMENT=4000001 DEFAULT CHARSET=utf8mb4 |

| candidates | CREATE TABLE `candidates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `political_party` varchar(128) NOT NULL,
  `sex` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 |
```

- candidates をメモリに載せる

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443"
2024/01/01 23:53:35 Start GET /initialize
2024/01/01 23:53:35 期日前投票を開始します
2024/01/01 23:53:37 期日前投票が終了しました
2024/01/01 23:53:37 投票を開始します  Workload: 3
2024/01/01 23:54:23 投票が終了しました
2024/01/01 23:54:23 投票者が結果を確認しています
2024/01/01 23:54:39 投票者の感心がなくなりました
2024/01/01 23:54:39 {"score": 7654, "success": 7102, "failure": 0}
```