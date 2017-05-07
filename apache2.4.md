# Apache Web Server 2.4


## 新機能/特徴 (2.2 との比較)
https://httpd.apache.org/docs/current/new_features_2_4.html

- Event MPM
- httpd バイナリの統一化 (MPM を変えても同じバイナリ)  
  (CentOS 7.2 のデフォルトは prefork)
- モジュールもしくはディレクトリ毎のログレベルの設定
- NameVirtualHost ディレクティブの廃止
- メモリ使用量の削減
- mod_proxy_express モジュール
    + DB にフロントのサーバ名と転送先を格納し、これを書き換えることで apache の再起動なく proxypass の追加が可能
    + 変換元は HTTP リクエストヘッダの Host 部分のみを見ているようなので、変換元のパス部分に応じた転送はできなさそう
- mod_ratelimit
    + KByte/sec を単位として転送速度を調節可能
- mod_proxy の proxypass ディレクティブの最適化
    + 二つのパラメータを使用する proxypass より Location ディレクティブなどと併用した場合の方が良いパフォーマンスとのこと


## 2.2 からの upgrade
https://httpd.apache.org/docs/current/upgrading.html

- MaxRequestsPerChild は MaxConnectionsPerChild に名前変更 (古い名前も引き続き利用可能)
- MaxClients は MaxRequestWorkers に名前変更 (古い名前も引き続き利用可能)
- AllowOverride のデフォルト値を None に変更
- mod_ssl
    + SSLv2 サポートの廃止
    + SSLProxyCheckPeerCN と SSLProxyCheckPeerExpire がデフォルトで有効  
      (502 Bad Gateway で失敗するとのこと)  
      (SSLProxyVerify は相変わらずデフォルト無効だが、上記 CN と Expire のチェックのみでも動作した。)  



