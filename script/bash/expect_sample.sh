#!/bin/bash

# xxxx

# Arguments:
#   1. type=str; xxxx
#   2. type=str; xxxx
# stdin: none
# stdout: expect コマンドの実行結果
# return: expect コマンドの戻り値


# ==================================================
# 引数/環境チェック
# ==================================================

# 引数/環境チェック用変数
env_err=''
env_chk=0

# 引数/環境チェック用関数
err_add (){
    env_err="${env_err}${1}\n"
    env_chk=$((env_chk+1))
}

# expect コマンドの存在確認
if ! type expect >/dev/null 2>&1; then
    err_add 'expectコマンドが存在しません'
fi

# 引数の個数チェック
if [ $# -ne 1 ]; then
    err_add '引数の個数が正しくありません'
fi

# 引数チェック結果判定
if [ $env_chk -ne 0 ]; then
    echo -e "${env_err}"
    exit 1
fi


# ==================================================
# メイン処理
# ==================================================

expect -c "
set timeout 5

spawn /usr/bin/ssh hoge@domain.local
expect \"Username:\"
send \"${NAME}\r\"
expect \"${NAME}@${HOST}'s password:\"
send \"${PASS}\r\"

interact
"
