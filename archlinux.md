# Arch Linux

## Install

### 参考
https://wiki.archlinuxjp.org/index.php/インストールガイド
https://wiki.archlinuxjp.org/index.php/LVM
https://wiki.archlinuxjp.org/index.php/カーネルパラメータ
https://wiki.archlinuxjp.org/index.php/GRUB


### 日本語キーボードに対応
```
loadkeys jp106
```

### パーティションの作成
```
fdisk /dev/sda
```
/dev/sda1 を boot 用に 512 M に設定、タイプは 83 で Linux  
/dev/sda2 を LVM 用に残り全て、タイプは 8e で Linux LVM

### LVM の編集
#### Physical Volume の作成
```
pvcreate /dev/sda2
pvs
```

#### Volume Group の作成
```
vgcreate vg01 /dev/sda2
vgs
```

#### Logical Volume の作成
```
lvcreate -L 12G var vg01
lvcreate -L 4G home vg01
lvcreate -L 4G swap vg01
lvcreate -l 100%FREE -n root vg01
lvs
```

### swap 領域の作成・有効化
```
mkswap /dev/vg01/swap
swapon /dev/vg01/swap
swapon -s
```

### ファイルシステムの作成
```
mkfs.xfs /dev/sda1
mkfs.xfs /dev/vg01/root
mkfs.xfs /dev/vg01/var
mkfs.xfs /dev/vg01/home
```

### パーティションのマウント
```
mount /dev/vg01/root /mnt

mkdir /mnt/boot
mkdir /mnt/var
mkdir /mnt/home

mount /dev/sda1 /mnt/boot
mount /dev/vg01/var /mnt/var
mount /dev/vg01/home /mnt/home
```


### IP アドレスの確認
```
ip a
```
デフォルトで DHCP サービスが動作している


### pacman ミラーサイトの編集
```
vim /etc/pacman.d/mirrorlist
```
Japan と書いてあるものを上に持ってくる


### ベースシステムのインストール
```
export http_proxy=http://${PROXY_IP}:${PROXY_PORT}
pacstrap /mnt base base-devel
```

### fstab の作成
```
genfstab -U /mnt >> /mnt/etc/fstab
```


### インストールしたシステムに chroot
```
arch-chroot /mnt
```


### タイムゾーン
```
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc
```


### ロケール
ja_JP.UTF-8 UTF-8 をアンコメント
```
vi /etc/locale.gen
```

以下のコマンドを実行
```
locale-gen
```

ロケールとキーマップを設定
```
echo LANG=ja_JP.UTF-8 >/etc/locale.conf
echo KEYMAP=jp106 >/etc/vconsole.conf
```


### ホスト名
```
echo ${HOSTNAME} >/etc/hostname
```


### initramfs
```
pacman -Qs lvm2
vi /etc/mkinitcpio.conf
```
`HOOKS=` の block と filesystems の間に lvm2 を追加し、以下のコマンドを実行

```
mkinitcpio -p linux
```


### パスワード
```
passwd
```


### ブートローダ
```
pacman -Syy
pacman -S intel-ucode # intel cpu を使用している場合
pacman -S grub
grub-install --target=i386-pc /dev/sda
vi /etc/default/grub
```
`GRUB_CMDLINE_LINUX_DEFAULT` に `root=/dev/mapper/vg01-root` を追加し、以下のコマンドを実行

```
grub-mkconfig -o /boot/grub/grub.cfg
```


### 再起動
```
exit  # chroot から抜ける
reboot
```



## 初期セットアップ

### DHCP クライアント
```
systemctl start dhcpcd
systemctl enable dhcpcd
```


### パッケージの検索とインストール
```
pacman -Ss ${PACKAGE_NAME}    # 検索
pacman -S ${PACKAGE_NAME}     # インストール
pacman -Ql    # インストールされたものの一覧
```


### pacman の設定
```
vi /etc/pacman.conf
```
以下の一行を追加すると、プログレスバーが変化する
```
#VerbosePkgLists
ILoveCandy
```


### 追加パッケージ一覧
   - bash-completion
   - vim
   - screen
   - wget
   - tcpdump
   - curl
   - chrony
   - bind-tools
   - gcc
   - make
   - linux-headers
   - perl



## GUI 環境の導入

### 参考
https://wiki.archlinuxjp.org/index.php/Xorg

### X インストール
```
pacman -S xorg-server xorg-server-utils
pacman -S xorg-xinit
pacman -S xorg-xev
pacman -S xf86-video-vesa xf86-vedio-fbdev  # for virutal box
pacman -S xterm
```

### virtualbox guest addtions
cd をマウントしてインストールを実行  
linux-headers などがないとインストールに失敗する  
これがないと、startx が上手くいかない  
VBoxClient-all を .xinitrc などに記載する  


### ratpoison
```
pacman -S ratpoison
```

### /etc/X11/xorg.conf.d/00-keyboard.conf
```
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "jp"
        Option "XkbModel" "pc106"
EndSection
```

### /etc/modules-load.d/virtualbox.conf
```
vboxguest
vboxsf
vboxvideo
```



### ~/.xinitrc
```
/usr/bin/VBoxClient-all

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
fcitx-autostart

xsetroot -solid black &

xcompmgr -c -f -D 5 &

exec /usr/bin/ratpoison
```

### ~/.Xresources
```
XTerm*termName: xterm-256color
XTerm*locale:   true
XTerm*selectToClipboard: true
XTerm*saveLines: 2000

*xterm*background: #101010
*xterm*foreground: #d0d0d0
*xterm*cursorColor: #d0d0d0
*xterm*color0: #101010
*xterm*color1: #960050
*xterm*color2: #66aa11
*xterm*color3: #c47f2c
*xterm*color4: #30309b
*xterm*color5: #7e40a5
*xterm*color6: #3579a8
*xterm*color7: #9999aa
*xterm*color8: #303030
*xterm*color9: #ff0090
*xterm*color10: #80ff00
*xterm*color11: #ffba68
*xterm*color12: #5f5fee
*xterm*color13: #bb88dd
*xterm*color14: #4eb4fa
*xterm*color15: #d0d0d0
```

### firefox
```
pacman -S firefox otf-ipafont
```
  - 日本語の言語パックをインストール
  - 言語設定を日本語に変更


### 日本語入力
```
pacman fcitx fcitx-mozc fcitx-configtool fcitx-im
```


### ~/.ratpoisonrc
```
bind f exec firefox
```


## 残タスク
  - キーバインドの変更
  - emacs (GUI) のインストール/設定


