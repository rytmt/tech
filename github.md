# GitHub

## 初回 push まで

    ssh-keygen -t rsa -b 4096

    vim ~/.ssh/config
    Host github.com
    Hostname github.com
    identityfile ~/.ssh/id_rsa_github

公開鍵を github に登録後、`ssh git@github.com`  
github 上でリポジトリを作成

    git remote add dotfiles git@github.com:rytmt/dotfiles.git
    git push -u dotfiles master

※ ~/.ssh/config を作成しないと、push コマンドでも ssh コマンドを呼んでいるのか、publickey のエラーがでる。


## クローン
git clone https://github.com/rytmt/dotfiles.git


## リモートリポジトリとのマージ
1. git fetch
1. git diff ditfiles/master
1. git merge


## 特定ファイルのみ別ブランチから取得
    git checkout dotfiles/master -- ${FILENAME}


## 登録済みリモートリポジトリの一覧
    git remote


## リモートリポジトリのリネーム
    git remote rename ${OLD} ${NEW}



