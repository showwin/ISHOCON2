<img src="https://user-images.githubusercontent.com/1732016/41643273-b4994c02-74a5-11e8-950d-3a1c1e54f44f.png" width="250px">

© [Chie Hayashi](https://www.facebook.com/hayashichie)

# ISHOCON2
iikanjina showwin contest 2nd (like ISUCON)  
ISHOCONとは `Iikanjina SHOwwin CONtest` の略で、[ISUCON](http://isucon.net/)と同じように与えられたアプリケーションの高速化を競うコンテスト(?)です。  

## 問題概要
今回のテーマは「ネット選挙」です。  
2016年9月現在、日本ではオンラインでの選挙はまだ実現されていませんが、近い将来にネット選挙が実現し、そのアプリケーションをあなたが実装することになるかもしれません。大量の投票に耐えられるようにアプリケーションチューニングの練習をしておきましょう。  
この選挙では1人1票ではなく、納税額によって各人投票できる票数が異なります。

![](https://raw.githubusercontent.com/showwin/ISHOCON2/master/doc/images/top.png)

## 問題詳細
* マニュアル: [ISHOCON2マニュアル](https://github.com/showwin/ISHOCON2/blob/master/doc/manual.md)
* アプリケーションAMI: `ami-09568651b65f0daf1`
* ベンチマーカーAMI: `ami-78b66107`
* インスタンスタイプ: `c5.large` (アプリ、ベンチ共に)
* 参考実装言語: Ruby, Python, Go, PHP, NodeJS, Crystal
* 推奨実施時間: 1人で8時間

* AWSではなく手元で実行したい場合には [Docker を使ってローカルで環境を整える](https://github.com/showwin/ISHOCON2/blob/master/doc/local_manual.md) をご覧ください。

## 関連リンク
* [社内ISUCONでISHOCON2を使用するための手順まとめ](http://showwin.hatenablog.com/entry/2018/08/27/000108) (by [@showwin](https://twitter.com/showwin))
  * ISHOCON2でISUCONイベントやる時の参考にしてください。
* [ISHOCON2というISUCONの個人大会で惨敗してきました【優勝スコアと同等の参考実装付き】](https://serinuntius.hatenablog.jp/entry/2018/08/26/201418) (by [@_serinuntius](https://twitter.com/_serinuntius))
  * ISHOCON2の最高得点の解説記事です。
* [ISHOCON2に参加してきました](http://www.denzow.me/entry/2018/08/26/000949) (by [@denzowill](https://twitter.com/denzowill))
  * ISHOCON2にPythonで取り組んだ記事です。
* [ISHOCON2に参加して来たよ！](https://goryudyuma.hatenablog.jp/entry/2018/08/26/190411) (by [@Goryudyuma](https://twitter.com/Goryudyuma))
  * ISHOCON2にCrystalで取り組んで、優勝余裕だろ！と思っていたら抜かれた記事です笑
* [ISHOCON2のWriteup](https://owl-works.org/essay/entries/ishocon2_writeup) (by [@Owl_Works](https://twitter.com/Owl_Works))
  * Top10入りしたISHOCON2のイベント参加記録です。
* [ISHOCON2を意地でPythonで20万点だした](http://www.denzow.me/entry/2018/08/29/001136) (by [@denzowill](https://twitter.com/denzowill))
  * Python実装で20万点超えていてすごい…
* [今年も isucon を開催しました！](https://tech.basicinc.jp/articles/180) (by [@rorensu2236](https://twitter.com/rorensu2236))
  * [株式会社ベーシック](https://basicinc.jp/)さんの社内ISUCONで使っていただきました！

## ISHOCONシリーズ
* [ISHOCON1](https://github.com/showwin/ISHOCON1)
* [ISHOCON2](https://github.com/showwin/ISHOCON2)
