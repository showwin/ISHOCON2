## AppleSilicon 対応後の2回目のチャレンジ

初回ベンチ 8290

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 3"
2024/01/06 13:06:55 Start GET /initialize
2024/01/06 13:06:55 期日前投票を開始します
2024/01/06 13:06:56 期日前投票が終了しました
2024/01/06 13:06:56 投票を開始します  Workload: 3
2024/01/06 13:07:42 投票が終了しました
2024/01/06 13:07:42 投票者が結果を確認しています
2024/01/06 13:07:57 投票者の感心がなくなりました
2024/01/06 13:07:57 {"score": 8290, "success": 7770, "failure": 0}
```

slow_query_log 設定のせいか遅くなった 6534

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 3"
2024/01/06 13:43:29 Start GET /initialize
2024/01/06 13:43:29 期日前投票を開始します
2024/01/06 13:43:29 期日前投票が終了しました
2024/01/06 13:43:29 投票を開始します  Workload: 3
2024/01/06 13:44:15 投票が終了しました
2024/01/06 13:44:15 投票者が結果を確認しています
2024/01/06 13:44:31 投票者の感心がなくなりました
2024/01/06 13:44:31 {"score": 6534, "success": 5942, "failure": 0}
```

vote 改善のためにカラムや index 追加や app code でキャッシュ 3266

捌ききれなくなっているのか？

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 3"
2024/01/06 15:06:41 Start GET /initialize
2024/01/06 15:06:41 期日前投票を開始します
2024/01/06 15:06:41 期日前投票が終了しました
2024/01/06 15:06:41 投票を開始します  Workload: 3
2024/01/06 15:07:27 投票が終了しました
2024/01/06 15:07:27 投票者が結果を確認しています
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/23: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/28: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/27: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/4: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/21: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/7: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/7: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/13: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%9110%E4%BA%BA%E5%A4%A7%E6%B4%BB%E8%BA%8D%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/8: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/28: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/28: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%9110%E4%BA%BA%E5%A4%A7%E6%B4%BB%E8%BA%8D%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/20: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%9110%E4%BA%BA%E5%A4%A7%E6%B4%BB%E8%BA%8D%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/18: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/18: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/29: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/7: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/18: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/30: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/1: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%9110%E4%BA%BA%E5%A4%A7%E6%B4%BB%E8%BA%8D%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/11: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/1: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/15: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/candidates/21: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:41 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/22: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/28: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%B9%B3%E5%92%8C%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/21: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%9110%E4%BA%BA%E5%A4%A7%E6%B4%BB%E8%BA%8D%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/26: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/5: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/15: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/8: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%9110%E4%BA%BA%E5%A4%A7%E6%B4%BB%E8%BA%8D%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/27: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%A4%A2%E5%AE%9F%E7%8F%BE%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/candidates/4: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/political_parties/%E5%9B%BD%E6%B0%91%E5%85%83%E6%B0%97%E5%85%9A: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 Get https://app:443/css/bootstrap.min.css: dial tcp 172.25.0.2:443: connect: cannot assign requested address
2024/01/06 15:07:42 投票者の感心がなくなりました
2024/01/06 15:07:42 {"score": 3266, "success": 32658, "failure": 344}
```

unicorn のワーカ数を増やして、/css へのアクセスは nginx にやらせる 29387

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 3"
2024/01/06 15:10:42 Start GET /initialize
2024/01/06 15:10:42 期日前投票を開始します
2024/01/06 15:10:42 期日前投票が終了しました
2024/01/06 15:10:42 投票を開始します  Workload: 3
2024/01/06 15:11:28 投票が終了しました
2024/01/06 15:11:28 投票者が結果を確認しています
2024/01/06 15:11:43 投票者の感心がなくなりました
2024/01/06 15:11:43 {"score": 29387, "success": 26243, "failure": 0}
```

workload = 4 32756

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 4"
2024/01/06 15:12:20 Start GET /initialize
2024/01/06 15:12:20 期日前投票を開始します
2024/01/06 15:12:20 期日前投票が終了しました
2024/01/06 15:12:20 投票を開始します  Workload: 4
2024/01/06 15:13:06 投票が終了しました
2024/01/06 15:13:06 投票者が結果を確認しています
2024/01/06 15:13:21 投票者の感心がなくなりました
2024/01/06 15:13:21 {"score": 32756, "success": 29428, "failure": 0}
```

静的ファイルの max age を一年に変更 29952

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 4"
2024/01/06 15:15:55 Start GET /initialize
2024/01/06 15:15:55 期日前投票を開始します
2024/01/06 15:15:56 期日前投票が終了しました
2024/01/06 15:15:56 投票を開始します  Workload: 4
2024/01/06 15:16:42 投票が終了しました
2024/01/06 15:16:42 投票者が結果を確認しています
2024/01/06 15:16:57 投票者の感心がなくなりました
2024/01/06 15:16:57 {"score": 29952, "success": 26376, "failure": 0}
```

add etag and last_modified_at 追加など 37768

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 4"
2024/01/06 16:01:06 Start GET /initialize
2024/01/06 16:01:06 期日前投票を開始します
2024/01/06 16:01:07 期日前投票が終了しました
2024/01/06 16:01:07 投票を開始します  Workload: 4
2024/01/06 16:01:52 投票が終了しました
2024/01/06 16:01:52 投票者が結果を確認しています
2024/01/06 16:02:07 投票者の感心がなくなりました
2024/01/06 16:02:07 {"score": 37768, "success": 31784, "failure": 0}
```

keyword 取得クエリ改善など 112325

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 4"
2024/01/06 16:52:54 Start GET /initialize
2024/01/06 16:52:54 期日前投票を開始します
2024/01/06 16:52:55 期日前投票が終了しました
2024/01/06 16:52:55 投票を開始します  Workload: 4
2024/01/06 16:53:40 投票が終了しました
2024/01/06 16:53:40 投票者が結果を確認しています
2024/01/06 16:53:55 投票者の感心がなくなりました
2024/01/06 16:53:55 {"score": 112325, "success": 87037, "failure": 0}
```

workload = 5 113722

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 5"
2024/01/06 16:54:52 Start GET /initialize
2024/01/06 16:54:52 期日前投票を開始します
2024/01/06 16:54:53 期日前投票が終了しました
2024/01/06 16:54:53 投票を開始します  Workload: 5
2024/01/06 16:55:38 投票が終了しました
2024/01/06 16:55:38 投票者が結果を確認しています
2024/01/06 16:55:53 投票者の感心がなくなりました
2024/01/06 16:55:53 {"score": 113722, "success": 87586, "failure": 0}
```

workload = 6 119949

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 6"
2024/01/06 16:57:03 Start GET /initialize
2024/01/06 16:57:03 期日前投票を開始します
2024/01/06 16:57:04 期日前投票が終了しました
2024/01/06 16:57:04 投票を開始します  Workload: 6
2024/01/06 16:57:49 投票が終了しました
2024/01/06 16:57:49 投票者が結果を確認しています
2024/01/06 16:58:04 投票者の感心がなくなりました
2024/01/06 16:58:04 {"score": 119949, "success": 93749, "failure": 0}
```

workload = 8 103865

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 8"
2024/01/06 16:58:25 Start GET /initialize
2024/01/06 16:58:25 期日前投票を開始します
2024/01/06 16:58:26 期日前投票が終了しました
2024/01/06 16:58:26 投票を開始します  Workload: 8
2024/01/06 16:59:11 投票が終了しました
2024/01/06 16:59:11 投票者が結果を確認しています
2024/01/06 16:59:26 投票者の感心がなくなりました
2024/01/06 16:59:26 {"score": 103865, "success": 83857, "failure": 0}
```

cache at nginx layer and disable slow query log 177404

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 6"
2024/01/06 17:11:43 Start GET /initialize
2024/01/06 17:11:43 期日前投票を開始します
2024/01/06 17:11:43 期日前投票が終了しました
2024/01/06 17:11:43 投票を開始します  Workload: 6
2024/01/06 17:12:29 投票が終了しました
2024/01/06 17:12:29 投票者が結果を確認しています
2024/01/06 17:12:44 投票者の感心がなくなりました
2024/01/06 17:12:44 {"score": 177404, "success": 124652, "failure": 0}
```

disable nginx log 287154

```
❯ make bench
docker exec -i ishocon2-bench-1 sh -c "./benchmark --ip app:443 --workload 6"
2024/01/06 17:17:46 Start GET /initialize
2024/01/06 17:17:46 期日前投票を開始します
2024/01/06 17:17:47 期日前投票が終了しました
2024/01/06 17:17:47 投票を開始します  Workload: 6
2024/01/06 17:18:32 投票が終了しました
2024/01/06 17:18:32 投票者が結果を確認しています
2024/01/06 17:18:47 投票者の感心がなくなりました
2024/01/06 17:18:47 {"score": 287154, "success": 208826, "failure": 0}
```
