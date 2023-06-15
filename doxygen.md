# doxygen / graphviz

## install
```shell
sudo apt install doxygen graphviz
```

## 設定ファイル(doxyfile)作成
```shell
doxygen -g
```

## 設定ファイル編集
```shell
vim Doxyfile
```

### 変更箇所のサンプル
```
PROJECT_NAME           = ""
EXTRACT_ALL            = YES
EXTRACT_PRIVATE        = YES
EXTRACT_PRIV_VIRTUAL   = YES
EXTRACT_PACKAGE        = YES
EXTRACT_STATIC         = YES
EXTRACT_LOCAL_METHODS  = YES
EXTRACT_ANON_NSPACES   = YES
RECURSIVE              = YES
SOURCE_BROWSER         = YES
INLINE_SOURCES         = YES
GENERATE_TREEVIEW      = YES
GENERATE_LATEX         = NO
CALL_GRAPH             = YES
CALLER_GRAPH           = YES
```

## ドキュメント生成
```shell
doxygen Doxyfile
```
