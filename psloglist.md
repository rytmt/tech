# psloglist

## download
https://learn.microsoft.com/en-us/sysinternals/downloads/psloglist

## csv でイベントログを出力
```powershell
psloglist -sx
```
- デフォルトは system が出力対象
  - application, security も指定可能 (ex. `psloglist -sx application`)
  - security は要管理者権限
