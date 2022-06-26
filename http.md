# HTTP

## プロトコルの移り変わり

### HTTP 1.0
- 1 TCP 接続で 1 HTTP リクエスト

### HTTP 1.1
- 1 TCP 接続で 1 HTTP リクエスト
- TCP 接続の使い回し (keep-alive) が可能
- 複数の TCP 接続を使って多重化が可能
  - 接続数を増やしても、パフォーマンス敵には 3 way handshake に要する時間や、slow start の影響を受ける
  - 複数の TCP 接続を管理するメモリリソースなども必要
- HTTP レベルでの HoL (Head of Line) Blocking が発生する
  - レスポンスが得られないと次のリクエストを送信できない
  - pipelining でレスポンスを待たずにリクエストを送信できるが、レスポンスはリクエストの順番通りに返す必要があるため、HoL Blocking の解決には至らず

### HTTP 2
- 1 TCP 接続で HTTP リクエストを多重化する (HTTP HoL Blocking の解消)
  - HTTP 1.1 では、レスポンスを待つことでリクエストとレスポンスの対応付けを行っていたが、HTTP 2 ではリクエストとレスポンスに Stream ID を付与することで対応付けを行う
- HTTP 1.1 とは異なりバイナリプロトコルであり、フレーム という単位でデータをやり取りする
- TCP レベルでの HoL Blocking が発生する (1パケットのロスですべてのストリームが停止する)

### HTTP 3
- TCP ではなく UDP + QUIC 上で動作する (TCP HoL Blocking の解消)
- HTTP 2 と同様にバイナリプロトコルであり、フレーム でデータのやり取りが行われる



## Web Proxy への https スキームのリクエスト
https スキームを使用した平文のリクエストを受信した場合に、以下のような動作を行う Web Forward Proxy の実装がある。
    1. オリジンサーバと SSL/TLS で通信を行う。
    2. オリジンサーバからの応答を、クライアントに対しては平文で返す。

実装例：
- CentOS 6.5  squid-3.1.10-29.el6.x86_64

以下の記載によると、そもそも平文で https スキームを使用することは想定されていないため、上記のような実装は必要はないと考えられる。
https://tools.ietf.org/html/rfc7230#page-18
> the user agent MUST ensure that its connection to the origin server is secured
> through the use of strong encryption, end-to-end, prior to sending the first HTTP request.

### 補足
perl などで https リクエストを送信する際に、起こりがちなよう。
http://qiita.com/debug-ito/items/4b3fec645f15af9b4929

curl の ML に上記のようなリクエストを送信する方法についての質問があった。
そのような方法はなく、curl は技術的な標準に基づいた実装になっている、と開発者の人が言っている。
https://curl.haxx.se/mail/archive-2015-12/0009.html


## ブラウザキャッシュ
### ブラウザキャッシュの動作
 - キャッシュが禁止されている
   - 認証が必要なリクエストや HTTPS 通信の場合
   - HTTP レスポンスヘッダの Cache-Control フィールドで no-store が指定されている場合
 - キャッシュが利用できる
   - 失効モデル (リクエストとレスポンスの省略)
     - Cache-Control: max-age もしくは Expires ヘッダによりキャッシュの新鮮さが示され、
       キャッシュが新鮮なうちはキャッシュからコンテンツを読み込む
   - 検証モデル (レスポンスの省略)
     - Last-Modified もしくは ETag ヘッダによりコンテンツの更新時刻が示され、
       これを If-Modified-Since や If-None-Match ヘッダによりサーバに示し、コンテンツが
       更新されているかどうかを確認する(304 Not Modified or 200 OK)

### キャッシュに関連するヘッダ
#### Cache-Control レスポンスヘッダ
 - no-store: キャッシュを禁止
 - no-cache: 検証モデルのキャッシュを行うことを指示
 - private: 複数ユーザが共有する場所にはキャッシュしない
 - public: 複数ユーザが共有する場所にもキャッシュする
 - max-age(他のディレクティブと併用可): クライアントにキャッシュを指示し、有効期限も指定する[秒]

#### Expires レスポンスヘッダ
 - キャッシュが有効な期限(GMT)

#### Last-Modified レスポンスヘッダと If-Modified-Since リクエストヘッダ
Last-Modified のフィールドには、リソースが更新された時刻(GMT)が格納されている。If-Modified-Since のフィールドにはこの Last-Modified から受け取った時刻をセット、サーバへ送信することで、304 Not Modified もしくは 200 OK を受け取る。

#### ETag レスポンスヘッダと If-None-Match リクエストヘッダ
ETag のフィールドには、リソースの情報(URLや更新日時)からハッシュ関数などを用いて生成された値が格納されている。If-None-Match のフィールドにはこの ETag から受け取った値をセットし、サーバへ送信することで、304 Not Modified もしくは 200 OK を受け取る。

#### Pragma レスポンスヘッダ
Cache-Control ヘッダの前に使用されていたヘッダ。
