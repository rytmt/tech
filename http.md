# HTTP

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
