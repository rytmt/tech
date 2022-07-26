# 指定された FQDN もしくは IP アドレスに対して TCP ポートスキャンを行うスクリプト

# 第一引数(必須/文字列): スキャン対象のFQDNもしくはIPアドレス
Param( [parameter(mandatory=$true)][string]$dsthost )


# 環境設定
$OutputEncoding='utf-8' # 日本語出力用。utf-8 BOMあり
$ErrorActionPreference = "silentlycontinue" # エラー非表示

# 共通の関数の読込み
. "$($PSScriptRoot)\commonlib.ps1"

# スキャンを実行
1..65535 | foreach { tcpsndmsg $dsthost "$_" "hello" }
