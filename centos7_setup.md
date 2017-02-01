# CentOS7 Setup

## Prerequisite
 - Image: CentOS-7-x86_64-DVD-1511.iso (CentOS 7.2.1511)
 - Packages: Minimal


## Network
`nmtui`  
変更の反映は、`nmtui` もしくは、`nmcli c down $ifname; nmcli c up $ifname`


## firewall
`systemctl stop firewalld`  
`systemctl disable firewalld`  


## SELinux
`setenforce 0`  
`vi /etc/selinux/config`  
```
    SELINUX=disabled
```


## Default Target
`systemctl set-default multi-user.target`


## journald
ディスクへのログの保存  
`mkdir /var/log/journal`


## IPv6 無効化
`vim /etc/sysctl.conf`
```
    net.ipv6.conf.all.disable_ipv6 = 1
    net.ipv6.conf.default.disable_ipv6 = 1
```


## RPM Package
### プロキシの設定
`vi /etc/yum.conf`

### アップデート
yum update

### パッケージのインストール
- bash-completion
- vim
- telnet
- chrony
- ntpdate
- bind-utils
- tcpdump
- psmisc
- lsof
- screen
- wget
- sysstat
- rsync


## ホスト名
hostnamectl set-hostname $hostname


## グループ/ユーザの作成
`groupadd`  
`useradd`  
`passwd`


## su の制限
`vim /etc/pam.d/su`  
以下の行をアンコメント
```
    auth required pam_wheel.so use_uid
```

`vim /etc/login.defs`  
以下の行を追加
```
    SU_WHEEL_ONLY yes  
```

`su` を実行できるユーザを wheel グループに所属させる  
`gpasswd -a $username wheel`


## SSH
以下の設定を変更する  
`vim /etc/ssh/sshd_config`
```
    PermitRootLogin no
    UseDNS no
```
`systemctl restart sshd`


## bashrc
以下を追記する  
`vim ~/.bashrc`
```
    alias grep='grep --color=auto'
    alias ls='ls --color=auto'
    
    HISTSIZE=9999
    HISTTIMEFORMAT='%y/%m/%d %H:%M:%S '
    
    [ -t 0 ] && stty stop undef
    [ -t 0 ] && stty start undef

    PS1='\n\[\033[2m\t \! \j\[\033[00m\] \[\033[38;5;189m\]\[\033[40;1m\]$(printf "${PWD%/*}")/\[\033[38;5;214m\]$(basename "$PWD")\[\033[00m\]\n \[\033[38;5;189m\]\$ \[\033[00m\]'

    export HISTSIZE HISTTIMEFORMAT PS1
```


## logrotate
`/var/log/wtmp` と `/var/log/btmp` の保存期間を変更


## スケルトンディレクトリ
`/etc/skel` ディレクトリに `.bashrc` などを配置


## 不要サービスの停止
`pstree` で確認しつつ、`systemctl disable` と `systemctl mask` で停止させる  


## chrony
時刻同期先を追加  
`vim /etc/chrony.conf`  
```
    server $IP_ADDR iburst
```
※ chrony はデフォルトで NTP クライアントからのアクセスを許可しない

再起動  
`systemctl restart chronyd.service`

動作状況の確認  
`*` が先頭に表示されている行は、同期が成功しているサーバ  
`chronyc sources`  

### ハードウェアクロックとシステムクロックの状態確認
`hwclock --show` コマンドでハードウェアクロックを、`date` コマンドでシステムクロックを確認。  
ハードウェアクロックがずれている場合は、`hwclock -w` コマンドで同期を実行。  


