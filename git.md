# Git


## 初期設定
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


## リポジトリの初期化
    cd ${WORKSPACE}
    git init

※ このコマンドにより作成される .git ディレクトリをリポジトリと呼ぶ。


## リポジトリの状態確認
    git status


## 管理除外ファイルの設定
### グローバル
    git config --global core.excludesfiles ~/.gitignore_global
    echo "${IGNORED_FILENAME} >>~/.gitignore_global"

### リポジトリローカル
- リポジトリ内に .gitignore ファイルを作成し、一行ずつ管理除外するファイル名を記載する。
- \* などのワイルドカードが使用可能。


## 変更の stage
※ unstage の仕方は stage 後に git status で確認できる。
### ファイル追加/変更
    git add ${FILENAME}

### ファイル削除
    git rm ${FILENAME}

### ファイルのリネーム/移動
rm と add


## staging area の コミット
    git commit

※ git commit -a で add を省略可能 (ファイル名は指定できない)


## 差分の確認
### stage する前
    git diff

### stage した後
    git diff --cached

### commit した後
    git diff HEAD^ HEAD


## ログの参照
    git log


## 特定のコミットまで戻る
    git reset --hard ${HASH}

※ ハッシュ値は git log で確認可能。


## ブランチ一覧の表示
    git branch

※ アスタリスクが付いているものが現在選択している branch  
※ 初期設定した git graph の HEAD の部分を見たほうがわかりやすい


## ブランチの作成
    git branch ${BLANCH_NAME}


## ブランチの選択
    git checkout ${BLANCH_NAME}

※ checkout に伴い作業ディレクトリの内容も切り替わる。




