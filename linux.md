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


## ファイルの削除
`rm` コマンドなどでファイルを削除した場合、inode とファイル名のリンクが解除されるが、
あるプロセスがそのファイルを使用している場合などは、inode とディスク上のデータ自体は
削除されない(プロセスがファイルを開放するまで)。  
ディスク上の実使用容量を確認する場合は `df` コマンドが、ファイル名から容量を確認する場合は
`du` コマンドが利用できる。  
(NTFS などはそもそもファイルが他のプロセスで使用されている場合、移動や削除ができない。)

### 削除したファイルの復元 (ができるかも)
削除したファイルが、プロセスで開かれていたりする場合には、  
`lsof | grep deleted` でファイルディスクリプタを特定し、`cp /proc/${pid}/${fd} recovery.dat` で復元できるかも。

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


## 出力のバッファリング
出力のバッファリングはストリーム(FILE構造体のポインタ)の機能である。
つまり、fopen や fprintf を使用したさいにはデフォルトで出力のバッファリングが有効になるが、
open(2) や write(2) を使用して、直接 fd を操作するような場合は、バッファリングはされない。

ストリームのバッファリング機能は、出力先によりデフォルトの動作が異なり、
stdout(標準出力)の場合はラインバッファ、ファイル出力の場合はブロックバッファが使用される。
(ちなみに、stderr はバッファリングされない。)  
これらの動作についての詳細は、`man setbuf` を参照。

例：`tail -f | grep`  
grep 単体で使用する場合は、プログラム自体がすぐに終了するためバッファリングの動作を意識することはないが、
GNU grep はブロックバッファを使用している。GNU grep は --line-buffered オプションにより、ラインバッファに
切り替えることが可能。

TODO: fopen/fprintf と open/write のプログラム例で、バッファリングの動作を検証したい。



## 端末上での制御文字の入力
Ctrl キーと他のキーを同時にタイプすることで、端末上で制御文字を入力することができる。
例えば、Ctrl + J や Ctrl + M では改行を入力することができる。  
(通常、端末で予約されている Ctrl + S とか Ctrl + V とかはそちらが優先されるので注意)

改行以外にも様々な制御文字を入力することが可能で、Ctrl と同時にタイプすることで、そのキーの文字コード(ascii)から 0x40 を引いた値に相当する文字を入力できる。
改行の場合は、LF(Line Feed) は 0x0A であるから、0x0A + 0x40 = 0x4A (=J) より、J を入力することになる。(ascii については、man ascii で一覧を確認できる。)  

ascii コード表を見れば、制御文字を入力するために 0x40 をずらすのは適切なやり方なのはわかるが、0x40 というのはどこで定義されているのかを見つけられなかった(TODO)。
端末というより、ascii コード一般に関することなので、そもそも linux カテゴリとしてまとめるのはおかしかった気がする。

### 具体例
- 行末の `^M`  
Windows で編集したテキストファイルを Linux で開くと、末尾に `^M` と表示されていることがあるが、これは CR(Carriage Return) = 0x0D = 0x4D(=M) - 0x40 から、CR が入力されているということがわかる。  
(Ctrl キーを `^` で表記することは、文字コードとは関係なく、古くから使用されている書き方のよう。いつから、とかの出典は見つからず。TODO)

- Ctrl + D でログアウト  
端末の設定で、Ctrl + D には eof(end of file)が割り当てられていることが多いため、入力することでシェルを抜けることができる。
ただし、`stty eof undef` などでこれを無効にしても、Ctrl + D = 0x4D - 0x40 = 0x0D = EOT(End Of Transmission) であり、シェルを抜けられることがある。

## プロセスの停止
### CentOS 6.x の sysV init スクリプトの場合
`/etc/init.d/functions` の `killproc` 関数を使用してプロセスを停止する。  
`killproc` 関数は、`SIGTERM` を送信してプロセスの停止を試み、停止できなかった場合に `SIGKILL` を送信する。

### CentOS 7.x の systemd の場合
既定の設定では、CentOS 6.x と同様に、`SIGTERM` → `SIGKILL` の順にシグナルを使用してプロセスの停止を試みる。  
これらの動作は unit ファイルの service セクションで変更が可能。`man systemd.kill` を参照。  

`strace -p ${PID}` でプロセスへのシグナルを確認できる。


## logrotate
プロセスがファイルにログを書き出しているとき、そのプロセスが指定しているのは inode 番号であるため、
ファイル名を変更してもそのファイルにログが書き出され続ける。ログの書き出しを他のファイルに変更するには、
プロセスが指定する inode 番号を変更する必要がある。  

CentOS 6.x の場合、init スクリプトの `reload` オプションを使用していることがあり、`reload` オプションは
SIGHUP を用いてファイルを開き直していることがある。

CentOS 7.x の場合、`systemctl reload` が使用されていることがあり、D-Bus 経由で対象のバイナリにメッセージを
送信しているよう。D-Bus が動作しなかった場合、SIGHUP が使われるよう。  
`systemctl.c` を参照

