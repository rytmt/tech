#!/bin/bash

# 指定したホストのプロセスを監視して、異常検知時にはメール通知するスクリプト

# オプション
#   -s: 初回異常検知時と復旧時のみメール通知する (cronでの定期実行を想定)
# 第一引数(必須/文字列): 監視対象のFQDNもしくはIPアドレス
# 第二引数(必須/文字列): 監視対象にSSHするための秘密鍵
# 第三引数(必須/文字列): 監視対象のプロセス名
# 第四引数(必須/数値)  : プロセス数の閾値
# 第五引数(必須/文字列): アラート通知先メールアドレス
# 標準入力: なし
# 標準出力: 監視結果

# ==================================================
# 変数定義
# ==================================================

# メールアドレスの正規表現
REGEX_MADDR='^[a-zA-Z0-9_+-]+(.[a-zA-Z0-9_+-]+)*@([a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]*\.)+[a-zA-Z]{2,}$'

# SMTPサーバ
SMTPSV='smtp://example.local:25'

# アラートメールのFromアドレス
HEADER_FROM='example@domain.local'

# スクリプト名とディレクトリ名
SNAME="$(basename $0)"
DNAME="$(cd $(dirname $0); pwd)"

# 状態記録用ファイル
STATUS="${DNAME}/${SNAME}.status"


# ==================================================
# 引数/環境チェック
# ==================================================

# 引数/環境チェック用変数
env_err=''
env_chk=0

# 引数の個数チェック
if [ $# -ne 5 ] && [ $# -ne 6 ]; then
    env_err="${env_err}引数の個数が正しくありません\n"
    env_err="${env_err}- 第一引数: 監視対象のFQDNもしくはIPアドレス\n"
    env_err="${env_err}- 第二引数: 監視対象にSSHするための秘密鍵\n"
    env_err="${env_err}- 第三引数: 監視対象のプロセス名\n"
    env_err="${env_err}- 第四引数: プロセス数の監視閾値\n"
    env_err="${env_err}- 第五引数: アラート通知先メールアドレス\n"
    env_chk=$((env_chk+1))
fi

# オプション有無のチェック
sflg=false
if echo "$1" | grep -qE '^-'; then
    if [ "$1" = "-s" ]; then
        sflg=true
    else
        env_err="${env_err}$1 は有効なオプションではありません\n"
        env_chk=$((env_chk+1))
    fi
    # 第一引数がハイフンから始まっているのでshiftする
    shift
fi

# 第一引数の形式チェック
if ! ping -c 1 -W 3 "$1" >/dev/null 2>&1; then
    env_err="${env_err}$1 に疎通性がありません\n"
    env_chk=$((env_chk+1))
fi

# 第二引数の形式チェック
if ! cat "$2" >/dev/null 2>&1; then
    env_err="${env_err}$2 というファイルは存在しません\n"
    env_chk=$((env_chk+1))
fi

# 第三引数の形式チェック
if [ "x$3" = "x" ]; then
    env_err="${env_err}第三引数が指定されていません\n"
    env_chk=$((env_chk+1))
fi

# 第四引数の形式チェック
if ! echo "$4" | grep -qE '^[0-9]+$'; then
    env_err="${env_err}$4 は数値ではありません\n"
    env_chk=$((env_chk+1))
fi

# 第五引数の形式チェック
if ! echo "$5" | grep -qE "${REGEX_MADDR}"; then
    env_err="${env_err}$5 は有効なメールアドレスではありません\n"
    env_chk=$((env_chk+1))
fi

# メール送信用コマンドのチェック
if ! type mailx >/dev/null 2>&1; then
    env_err="${env_err}メール送信用コマンド(mailx)がインストールされていません\n"
    env_chk=$((env_chk+1))
fi

# 引数チェック結果判定
if [ $env_chk -ne 0 ]; then
    echo -e "${env_err}"
    exit 1
fi

# 各引数をセット
MON_HOST="$1"
MON_SSHKEY="$2"
MON_PROCESS="$3"
MON_THRESH=$4
MON_MADDR="$5"


# ==================================================
# 関数定義
# ==================================================

# メール送信用関数
exec_mailx(){
    echo "$1" | mailx \
    -s "$2" \
    -S "smtp=${SMTPSV}" \
    -S "from=${HEADER_FROM}" \
    "${MON_MADDR}"
}

# ==================================================
# メイン処理
# ==================================================

# 監視対象にSSHしてプロセスの稼働状況を取得
psresult="$(ssh -i "${MON_SSHKEY}" "root@${MON_HOST}" "ps auxww | grep -F ${MON_PROCESS} | grep -v grep")"

# プロセス数をカウント
# 監視結果が空の場合は0にする。wc -lは改行の個数を数えるため
if [ "x${psresult}" = "x" ]; then
    pscnt=0
else
    pscnt=$(echo ${psresult} | wc -l)
fi

# 監視結果判定
# プロセス数が 0 もしくは MON_THRESH 以下の場合
if [ $pscnt -eq 0 ] || [ $pscnt -le $MON_THRESH ]; then
    # ログ出力用文字列をセット
    sbj="${MON_HOST}: PROCESS COUNT ERROR; ps=${MON_PROCESS}, cnt=${pscnt}, thld=${MON_THRESH}"

    # -s オプションありで、既にステータスが ng の場合はメール通知しない
    if $sflg && grep -q 'ng' "${STATUS}">/dev/null 2>&1; then
        :
    else # それ以外の場合はメール通知する
        exec_mailx "${psresult}" "${sbj}"

        # -s オプションありの場合は、ステータスを ng にセットする
        if $sflg; then
            echo 'ng' > "${STATUS}"
        fi
    fi
else # 監視結果が問題ない場合
    # ログ出力用文字列をセット
    sbj="${MON_HOST}: PROCESS COUNT OK; ps=${MON_PROCESS}, cnt=${pscnt}, thld=${MON_THRESH}"

    # -s オプションありの場合
    if $sflg; then
        # かつ、現在のステータスが ng の場合は復旧をメール通知する
        if grep -q 'ng' "${STATUS}">/dev/null 2>&1; then
            exec_mailx "${psresult}" "${sbj}"
        fi
        # ステータスを ok に変更する
        echo 'ok' > "${STATUS}"
    fi
fi

# 監視結果を画面とログに出力
echo "${sbj}" | tee >(logger -t "${SNAME}")
