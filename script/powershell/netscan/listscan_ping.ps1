# 指定されたファイルに記載されている IP アドレスに対して ping 通信を試みるスクリプト
# ファイルには 1 行 1 IP アドレスを記載すること

# 第一引数(必須/文字列): IPアドレスが記載されたファイル名
Param( [parameter(mandatory=$true)][string]$filename )

# 環境設定
$OutputEncoding='utf-8' # 日本語出力用。utf-8 BOMあり
$ErrorActionPreference = "silentlycontinue" # エラー非表示

# 共通の関数の読込み
. "$($PSScriptRoot)\commonlib.ps1"

# スキャンを実施
foreach ($target in Get-Content $filename)
{
    $result = Test-Connection $target -count 1 -quiet
    If ($result)
    {
        Write-Host "${target}: 応答あり"
    }
    Else
    {
        Write-Host "${target}: 応答なし"
    }
}
