# Raspberry Pi CentOS Parameter

## 環境
- Raspberry Pi Model B
- CentOS-Userland-7-armv7hl-Minimal-1603-RaspberryPi3.img
  (初期 root パスワードは centos)


## firewall
systemctl stop firewalld
systemctl disable firewalld


## SELinux
`setenforce 0`  
`vi /etc/selinux/config`  
SELINUX=disabled


## Network
nmtui


## Default Target
systemctl set-default multi-user.target


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
auth required pam_wheel.so use_uid の行をアンコメント  

`vim /etc/login.defs`  
SU_WHEEL_ONLY yes  

`gpasswd -a $username wheel`


## SSH
PermitRootLogin no¬
UseDNS no¬


## TTY
vim で Ctrl-s と Ctrl-q を使用したいため、端末の設定を変更
`stty stop undef`  
`stty start undef`  


## 不要サービスの停止
`pstree` で確認しつつ、`systemctl disable` と `systemctl mask` で停止させる  
