# 指定されたファイルに記載されている IP アドレスと TCP ポートに対して接続を試みるスクリプト
# ファイル記載例 (1行1アドレス+1ポート、アドレスとポート番号はカンマ区切り)
# -----
#   127.0.0.1,443
#   127.0.0.1,80
# -----

# 第一引数(必須/文字列): IPアドレスとポート番号が記載されたファイル名
Param( [parameter(mandatory=$true)][string]$filename )

# 環境設定
$OutputEncoding='utf-8' # 日本語出力用。utf-8 BOMあり
$ErrorActionPreference = "silentlycontinue" # エラー非表示

# 共通の関数の読込み
. "$($PSScriptRoot)\commonlib.ps1"

# スキャンを実施
foreach ($target in Get-Content $filename)
{
    $addr, $port = $target -split ","
    tcpsndmsg $addr $port "hello"
}
