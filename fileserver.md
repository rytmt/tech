# File Server

## Environment
 - OS: CentOS 7.3.1611
 - Samba: 4.4.4-9
 - postfix-2.10.1-6


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
