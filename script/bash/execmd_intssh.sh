#!/bin/bash

# パスワード認証の SSH セッション経由で複数の機器にコマンドを実行するスクリプト

# 第一引数：ログイン先一覧CSVファイル (ログイン先,SSHユーザ名,SSHパスワード,パスワードプロンプト文字列)
# 第二引数：SSH先で実行するコマンド文字列


TARGETLIST="$1"
RCMD="$2"


cat "${TARGETLIST}" | while read targetline; do

    target_host="$(echo -n ${targetline} | cut -d ',' -f 1)"
    target_uname="$(echo -n ${targetline} | cut -d ',' -f 2)"
    target_upass="$(echo -n ${targetline} | cut -d ',' -f 3)"
    target_prompt="$(echo -n ${targetline} | cut -d ',' -f 4)"

    (expect -c "
set timeout 10
spawn ssh ${target_uname}@${target_host} ${RCMD}
expect \"yes/no\" {
    send \"yes\r\"
    expect \"${target_prompt}\"
    send \"${target_upass}\r\"
} \"${target_prompt}\" {
    send \"${target_upass}\r\"
}
expect eof
") | tee "${target_host}_$(echo -n ${RCMD} | sed 's/ /_/g').log"

done

