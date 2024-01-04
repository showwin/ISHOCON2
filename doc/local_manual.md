# Docker を使ってローカルで環境を整える

```
$ git clone git@github.com:showwin/ISHOCON2.git
$ cd ISHOCON2
```

言語を変更するための make command で dockerfile のパスなどを使いたい言語に合わせる。

```
$ make change-lang LANG=${WHATEVER_LANGUAGE_U_WANT}
```

```
$ docker-compose build
$ docker-compose up
# app_1 と bench_1 のログに 'setup completed.' と出たら起動完了
```

## アプリケーション

```
$ docker exec -it ishocon2_app_1 /bin/bash
```

アプリケーションの起動は [マニュアル](https://github.com/showwin/ISHOCON2/blob/master/doc/manual.md) 参照


### Tips

`docker-compose.yml` の `app` でローカルの `webapp` ディレクトリをマウントすると、ローカルのファイル変更がすぐに反映されるので便利です。
```
  app:
    volumes:
      - ./webapp:/home/ishocon/webapp
```

## ベンチマーカー

```
$ docker exec -it ishocon2-bench-1 /bin/bash
$ ./benchmark --ip app:443  # docker-compose.yml で link しているので app で到達できます
```

上と同じものを実行できる benchmark 用の make command も用意されています。

```
$ make bench
```
