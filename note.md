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


