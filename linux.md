# Linux


## namespace
### 参考サイト
https://linuxjm.osdn.jp/html/LDP_man-pages/man7/namespaces.7.html
http://enakai00.hatenablog.com/entry/20130923/1379927579
http://gihyo.jp/admin/serial/01/linux_containers/0002

### 概要
- kernel 2.6 くらいからの機能
- プロセス毎に異なるディレクトリ構造にアクセスさせることなどが可能
- /proc/${PID}/ns ディレクトリ配下の各ファイルに対して setns(2) を実行することで、名前空間の関連付けを変更する。

### 利用例
systemd の service セクションのオプションの一つである readonlydirectories は、
該当の unit に対して readonly とするディレクトリを指定できるが、これは指定した
ディレクトリをそのディレクトリ自身で bind mount し、readonly オプションを付けて
リマウントすることで実現している。このときに、マウント名前空間を使用して、特定の
プロセスにのみ readonly の bind mount を有効にしている。unshare(1) や unshare(2)
を用いて、マウント状態などを切り離すことができる。


## netem (Network Emulator)
Kernel 2.6 の機能で、tc コマンド(in iproute)から実行可能であり、NIC に対して
遅延やパケットロスなどを発生させることができる。  
https://wiki.linuxfoundation.org/networking/netem

例：eth0 に対して 100±50ms の遅延、10% のパケットロスを設定する

    tc qdisc add dev eth0 root netem delay 100ms 50ms 10%


## 削除したファイルの復元 (ができるかも)
削除したファイルが、プロセスで開かれていたりする場合には、  
`lsof | grep deleted` でファイルディスクリプタを特定し、`cp /proc/${pid}/${fd} recovery.dat` で復元

lsof で拾えない場合も、debugfs から lsdel で inode 番号が確認できれば、`cat <inode>` などで復元できる


## ロケール
`LANG < LC_* < LC_ALL`  
date コマンドなどは、`LC_TIME` を使用する。`LC_*` が設定されていない場合は、`LANG` が使用される。  
`LC_ALL` が設定されている場合は、`LC_*` が設定されていても参照されず、`LC_ALL` が使用される。  
`LC_*` は設定されていないことが多く、`LANG` が使用されている。  
というのは、`locale` コマンドで確認できる現在適用されているロケールの状態と、  
`printenv | grep -i lc_` による環境変数の状態を比較するとわかる。
http://linuxjm.osdn.jp/html/LDP_man-pages/man7/locale.7.html
http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap07.html


## バッファリング
コマンドの実行結果をファイルにリダイレクトした場合、端末(標準出力)に出力した場合とは異なり、
バッファリングされている様子が見られる場合がある。  
これは、ファイルと標準出力では使用されるバッファが異なることが原因となっている。  
(デフォルトでは、ファイルにはブロックバッファ、標準出力にはラインバッファが使用される。)  
詳細は `man setbuf` を参照。