# File Server

## Environment
 - OS: CentOS 7.3.1611
 - Samba: 4.4.4-9
 - postfix-2.10.1-6


## ディスク追加
 1. OS がディスクを認識していることを確認  
    `fdisk -l`  
 2. パーティション作成  
    `fdisk /dev/$DISK`  

```
     # fdisk /dev/sdb
     Welcome to fdisk (util-linux 2.23.2).
     
     Changes will remain in memory only, until you decide to write them.
     Be careful before using the write command.
     
     Device does not contain a recognized partition table
     Building a new DOS disklabel with disk identifier 0x1c9f2ca8.
     
     The device presents a logical sector size that is smaller than
     the physical sector size. Aligning to a physical sector (or optimal
     I/O) size boundary is recommended, or performance may be impacted.
     
     
     コマンド (m でヘルプ): p
     
     Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes, 3907029168 sectors
     Units = sectors of 1 * 512 = 512 bytes
     Sector size (logical/physical): 512 bytes / 4096 bytes
     I/O サイズ (最小 / 推奨): 4096 バイト / 4096 バイト
     Disk label type: dos
     ディスク識別子: 0x1c9f2ca8
     
     デバイス ブート      始点        終点     ブロック   Id  システム
     
     コマンド (m でヘルプ): n
     Partition type:
        p   primary (0 primary, 0 extended, 4 free)
        e   extended
     Select (default p): p
     パーティション番号 (1-4, default 1): 1
     最初 sector (2048-3907029167, 初期値 2048):
     初期値 2048 を使います
     Last sector, +sectors or +size{K,M,G} (2048-3907029167, 初期値 3907029167):
     初期値 3907029167 を使います
     Partition 1 of type Linux and of size 1.8 TiB is set
     
     コマンド (m でヘルプ): p
     
     Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes, 3907029168 sectors
     Units = sectors of 1 * 512 = 512 bytes
     Sector size (logical/physical): 512 bytes / 4096 bytes
     I/O サイズ (最小 / 推奨): 4096 バイト / 4096 バイト
     Disk label type: dos
     ディスク識別子: 0x1c9f2ca8
     
     デバイス ブート      始点        終点     ブロック   Id  システム
     /dev/sdb1            2048  3907029167  1953513560   83  Linux
     
     コマンド (m でヘルプ): w
     パーティションテーブルは変更されました！
     
     ioctl() を呼び出してパーティションテーブルを再読込みします。
     ディスクを同期しています。
```
 3. ファイルシステムの作成  
    `mkfs.xfs $DISK`  
    data = bsize=4096  より、ブロックサイズが 4096 byte で作成されていることがわかる  
    ファイルシステムの情報を後から参照する場合は、`xfs_info $MOUNT_POINT` を実行する
 4. 手動マウント
    `mount $DISK $MOUNT_POINT`
 5. 自動マウント設定  
    `blkid $DISK` を実行して、uuid を確認する  
    `vim /etc/fstab` を実行して、行を追加する


## Samba の設定
### インストール
`yum install samba samba-client samba-common`

### 設定例
`vim /etc/samba/smb.conf`  
```
[global]
        unix charset = UTF-8
        dos charset = CP932
        workgroup = WORKGROUP
        security = user
        map to guest = Bad User
        guest account = $USER_NAME

        passdb backend = tdbsam

        printing = cups
        printcap name = cups
        load printers = yes
        cups options = raw

        hosts allow = 192.168.2.

[homes]
        comment = Home Directories
        valid users = %S, %D%w%S
        browseable = No
        read only = No
        inherit acls = Yes

[printers]
        comment = All Printers
        path = /var/tmp
        printable = Yes
        create mask = 0600
        browseable = No

[print$]
        comment = Printer Drivers
        path = /var/lib/samba/drivers
        write list = root
        create mask = 0664
        directory mask = 0775

# この名前をクライアント側から指定するので注意
[public]
        comment = Public Space
        path = /data/
        force user = root
        public = yes
        read only = no
        writable = yes
        guest ok = yes
        only guest = yes
        create mode = 0777
        directory mode = 0777
```
※ 共有するディレクトリの権限も変更しておくこと


## Postfix の設定 (メール通知用)
### インストール
`yum install cyrus-sasl cyrus-sasl-lib cyrus-sasl-plain`

### 設定例
 - 設定ファイルを編集  
`vim /etc/postfix/main.cf`  
```
    inet_interfaces = all
    inet_protocols = ipv4
    
    relayhost = [smtp.googlemail.com]:587
    smtp_use_tls = yes
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_tls_security_options = noanonymous
    smtp_sasl_mechanism_filter = plain, login
    smtp_tls_CApath = /etc/pki/tls/certs/ca-bundle.crt
    broken_sasl_auth_clients = yes
```

 - 認証情報の配置  
```sh
    cat [smtp.googlemail.com]:587 ${USER}:${PASSWORD} >/etc/postfix/sasl_passwd
    chmod 600 /etc/postfix/sasl_passwd
    postmap /etc/postfix/sasl_passwd
    systemctl start postfix
```
※ yahoo メールはメールリレーを受け付けないらしい

### 動作確認
```sh
    $ sendmail ryoto0114@yahoo.co.jp<<EOS
    From:ryoto0114@gmail.com
    To:ryoto0114@yahoo.co.jp
    Subject:test subject
    
    test message.
    
    .
    EOS
```
