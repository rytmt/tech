# Shell

## POSIX

### xargs
末尾に改行などの区切り文字が存在しない場合、最後の単語を受け取らない実装がある。  
対策のため、間に grep ^ などを挟んで、各行の末尾に必ず改行が存在するようにする。  



## 全般 (not POSIX)

### 未定義変数参照の禁止
`set -u`  
未定義の変数を参照する必要がある場合は、`${VAL-}` として、未定義変数を空文字に置き換える。


### xargs と while read の比較
- xargs のメリット
    + 複数プロセスを使用できるため、高速
- while read のメリット
    + POSIX の範囲で、`while IFS= read -r` とすることで、空白文字などを除去可能
    + xargs とは異なり、read のデリミタは改行もしくは IFS を使用する。
    + read の -r オプションにより、バックスラッシュによるデリミタのエスケープを無効にできる。  
      (xargs の -d オプションによるデリミタ指定は POSIX 外。)

### シェル の起動シーケンス
1. PID 1 が getty(8) (もしくは agetty(8)) を起動
1. getty(8) が login(1) を起動
1. login(1) が /etc/passwd を参照し、シェルを起動

https://linuxjm.osdn.jp/html/GNU_bash/man1/bash.1.html
#### bash の設定ファイルの読み込み順序
- ログインシェルの場合
    1. /etc/profile
    1. 以下のファイルを上から順に探し、一つだけ読み込む
        1. ~/.bash_profile
        1. ~/.bash_login
        1. ~/.profile

- インタラクティブシェルの場合
    1. ~/.bashrc

- 非インタラクティブシェルの場合
    1. $BASH_ENV

#### sh として bash を起動した場合
- ログインシェルの場合
    1. /etc/profile
    1. ~/.profile

- インタラクティブシェルの場合
    1. $ENV

- 非インタラクティブシェルの場合
    1. 何も読み込まない


### rbash による制限付きユーザの作成
1. /etc/shells に /bin/rbash を追加
1. /bin/rbash を /bin/bash のシンボリックリンクとして作成
1. ユーザのログインシェルを /bin/rbash に変更
1. ユーザのホームディレクトリの .bash_profile の PATH を $HOME/bin のみに変更
1. .bash_profile の権限を root:root 755 に変更
1. $HOME/bin に必要なコマンドのシンボリックリンクを作成


### シェルの実行方法
#### 前提
~/script.sh を実行する場合
#### 動作確認環境
GNU bash, version 4.1.2(1)-release (x86_64-redhat-linux-gnu)
1. `~/script.sh`
    - スクリプトファイルに実行権限が必要
    - 新たなプロセスでスクリプトが実行されるため、カレントシェルとシェル変数は共有されない
    - シバンを読み込む
2. `sh ~/script.sh`
    - スクリプトファイルには実行権限は不要
    - 新たなプロセスでスクリプトが実行されるため、カレントシェルとシェル変数は共有されない
    - **指定したシェルを使用してスクリプトを実行するため、シバンが読み込まれない**
3. source ~/script.sh
    - スクリプトファイルには実行権限は不要
    - カレントシェルでスクリプトが実行されるため、シェル変数が共有される
    - コメント行は読み飛ばされるため、シバンは読み込まれない


### while のサブシェル
#### 動作確認環境
GNU bash, version 4.1.2(1)-release (x86_64-redhat-linux-gnu)

#### 確認結果
標準入力があると、while はサブシェルを起動するらしい。  
(while の中でシェル変数を使用したり、exit or break をするときに要注意)  

#### 確認方法
1. 標準入力なし
```sh
while read line ; do echo $BASHPID ; done <<EOS
1
EOS
```
2. 標準入力あり
```sh
echo 1 | while read line ; do echo $BASHPID ; done
```




