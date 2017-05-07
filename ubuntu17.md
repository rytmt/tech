# Ubuntu 17


## Environment
ubuntu-17.04-desktop-amd64


## Update Packages
```
sudo apt apdate
sudo apt upgrade
```

## Guest Additions (VirtualBox)
```
sudo apt-get install gcc make
mount /dev/cdrom /mnt
cd /mnt
sudo sh ./VBoxLinuxAdditions.run
```

## Install Desktop Environment
```
sudo apt-get install ratpoison
```

## Setup Desktop Environment
```
vim /usr/share/xsessions/ratpoison.desktop
```
```
[Desktop Entry]
Name=Ratpoison
Comment=This session logs you into Ratpoison
Exec=/usr/bin/ratpoison
TryExec=/usr/bin/ratpoison
Icon=
Type=Application
X-Ubuntu-Gettext-Domain=ratpoison-session
```


## ~/.ratpoisonrc (sample)
```
bind f exec firefox
```


## Firefox
  - 言語を日本語に変更
  - 日本語の言語パックをインストール
  - ハードウェアアクセラレーションを停止
  - 以下のアドオンをインストール
     - vimperator
     - adblock plus
     - flashblock
     - tree style tab


## Autokey
### Install
```
sudo apt-get install autokey-gtk
```

### Configuration
```
autokey-gtk -c
```
`keyboard.send_keys("<down>")`, `keyboard.send_keys("<escape>")`  など


## Font
ダウンロードした `.ttf` や `.otf` ファイルを `/usr/local/share/font` に配置


## emacs
```
sudo apt-get install emacs25 emacs-mozc
```


## Git and GitHub
### Install
```
sudo apt-get install git
```

### Configuration
1. Git 全体の設定をする
```
git config --global user.name 'MY NAME'
git config --global user.email 'mymail@local'
git config --global core.editor 'vim'
git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global alias.graph "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
```
`git config --list` で設定の確認ができる

2. GitHub 用の鍵を設定する
vim ~/.ssh/config
```
Host github.com
Hostname github.com
identityfile ~/.ssh/id_rsa_github
```

3. リポジトリをクローンする
```
git clone https://github.com/rytmt/dotfiles.git
```


