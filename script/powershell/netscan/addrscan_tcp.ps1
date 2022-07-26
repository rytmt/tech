# 指定されたネットワークセグメント(/24)全体に対して特定の TCP ポートでスキャンを試みるスクリプト

# 第一引数(必須/文字列): スキャン対象のネットワークアドレス(/24)
# 第二引数(必須/文字列): スキャン対象のTCPポート番号
Param( [parameter(mandatory=$true)][string]$network, [parameter(mandatory=$true)][string]$dstport )


# 環境設定
$OutputEncoding='utf-8' # 日本語出力用。utf-8 BOMあり
$ErrorActionPreference = "silentlycontinue" # エラー非表示

# 共通の関数の読込み
. "$($PSScriptRoot)\commonlib.ps1"

# ネットワークアドレスをオクテット毎に分割
$oct1, $oct2, $oct3, $oct4 = $network -split "\."

# スキャンを実施
1..254 | foreach { tcpsndmsg "${oct1}.${oct2}.${oct3}.$_" $dstport "hello" }
