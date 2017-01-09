# RedHat Enterprise Linux 7

## Common administrative commands (rhel 5,6,7)
https://access.redhat.com/sites/default/files/attachments/rhel_5_6_7_cheatsheet_27x36_1014_jcs_web.pdf


## Memory managment (要ログイン)
https://access.redhat.com/solutions/16995


## 公式ドキュメント類
https://access.redhat.com/documentation/en/red-hat-enterprise-linux/?version=7/


## ファイルシステムのレイアウト変更
- /bin, /sbin, /lib, /lib64 が /usr ディレクトリ配下に移動。シンボリックリンクとして元の場所に残っている。  
- /usr と / を分けると / をマウントしただけではほぼ何もできなくなるため、分けない方が良い。  
- /var/run ディレクトリが /run に移動し、/var/run は /run へのシンボリックリンクとなっている。  
- また、/run は tmpfs でマウントされているため、再起動でファイルが削除されることに注意。  


## How do I migrate from RHEL5 to RHEL7 ? (要ログイン)
https://access.redhat.com/articles/1211223


##  netstat と ss
TCP ソケットの情報を参照する際、netstat は /proc/net/tcp から、ss は /proc/${PID}/fd 内を readlink したものから、得ている。
(CentOS 6.7 で netstat -nat と ss -nat をそれぞれ strace したことより確認。サーバ高負荷時には /proc/net/tcp の参照に時間がかかる場合がある。)
CentOS 7.2 で ss コマンドを実行したところ、/proc/${PID}/fd を open していなかった。
ss では netlink を使用して高速化をしているよう。
procfs のファイルは proc_create 関数で作成。


## minimal でインストールされないパッケージ
- bash-completion (← systemctl コマンドの補完など)
- telnet
- chrony
- ntpdate
- bind-utils (dig)
- tcpdump
- psmisc (pstree)
- lsof
- screen
- wget
- sysstat
- rsync
- hdparm
- abrt


## Network の設定
- NetworkManager の使用が推奨されている。
- nmtui が使用しやすいが、onboot=no の部分を変更できない。(RHEL7.2はデフォルトno)
- onboot=yes とするために、以下のコマンドを実行。  
  `nmcli c mod ${CONN_NAME} connection.autoconnect yes`
- 変更の反映には systemctl restart NetworkManager を実行。
- service unit として network も定義されているが、これは systemd により自動生成されたファイルであり、
- /run/systemd/generator.late 配下に作成されており、/etc/rc.d/init.d/network スクリプトを実行するように記載されている。
- sysvinit との互換性保持のために生成されているものと考えられる。  
  (chkconfig --list で表示される netconsole も同様だと考えられる。)


## unit の自動起動
以下のいずれかのディレクトリに unit ファイルのシンボリックリンクが配置されている場合、自動起動する。  
/usr/lib/systemd/system もしくは /etc/systemd/system ディレクトリ配下の
- multi-user.target.wants
- basic.target.wants
- sysinit.target.wants

unit ファイルの install セクションに wantedby=multi-user.target と記載した場合のみ、
systemctl enable/disable コマンドにより自動起動の on/off を切り替えることができ、
/etc/systemd/system/multi-user.target.wants ディレクトリに unit ファイルのシンボリックリンクが作成/削除される。

wantedby の記載の有無により systemctl list-unit-files の (enable|disable)/static が決まるため、
enable のみを grep しても自動起動が有効になっているサービスを特定できない。
(static で wants ディレクトリに配置されているような unit が存在するため。)

###追記
type=dbus のサービスの自動起動が変更できない。。。  
→ systemctl mask で /dev/null へのシンボリックリンク /etc/systemd/system/${SERVICE_NAME}.service
が作成され、これにより static なサービスも自動起動を停止させることができる。


## tmpwatch の変更
/etc/cron.daily に tmpwatch はなく、systemd-tmpfiles-clean.timer, systemd-tmpfiles-clean.service に置き換わった。


## 各種初期設定
### デフォルトターゲットの変更
`systemctl set-default multi-user.target`

### irewall/SELinux 無効化
    systemctl disable firewalld
    vim /etc/selinux/config

### ipv6 無効化
https://access.redhat.com/solutions/8709

### 特定サービスのファイルディスクリプタ変更
    mkdir /etc/systemd/system/${SERVICE_NAME}.service.d
    vim /etc/systemd/system/httpd.service.d/limit.conf
    [Service]
    LimitNOFILE=xxxxx


## TODO
systemd が他のサービスの起動に伴い、勝手(wantsなど記載なし)に他のサービスを起動しているかも。
