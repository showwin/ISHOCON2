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


