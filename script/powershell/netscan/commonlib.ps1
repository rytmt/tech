# 共通の関数定義

# 環境設定
$OutputEncoding='utf-8' # 日本語出力用。utf-8 BOMあり
$ErrorActionPreference = "silentlycontinue" # エラー非表示

# TCPポート接続と接続後に任意の文字列を送信する関数
# 第一引数(必須/文字列): TCP接続先FQDNもしくはIPアドレス
# 第二引数(必須/文字列): 接続先TCPポート番号
# 第三引数(必須/文字列): TCP接続後に送信する文字列
Function tcpsndmsg([string]$dsthost, [string]$dstport, [string]$msg)
{

    # tcpクライアントを作成
    $sock = New-Object System.net.sockets.tcpclient

    # 引数で指定された dsthost と dstport に接続試行
    $sock.connect($dsthost, $dstport)

    If ( -Not($sock.connected) )
    {
        Write-Host "${dsthost}:${dstport} への接続に失敗しました"
        $sock.Dispose()
        return
    }

    # メッセージ送信用オブジェクト作成
    $stream = $sock.GetStream()
    $stwriter = New-Object System.IO.StreamWriter $stream

    # メッセージの送信
    $stwriter.Write($msg)
    $stwriter.Flush()

    # 結果表示
    Write-Host "${dsthost}:${dstport} に接続して文字列「${msg}」を送信しました"

    # 後処理
    $stwriter.Dispose()
    $stream.Dispose()
    $sock.Dispose()

    return
}
