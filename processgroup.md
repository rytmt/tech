# Process Group

## 概要
各プロセスはプロセスグループIDとセッションIDを持つ。  
プロセスグループIDやセッションIDの確認には ps axjf コマンドを使用。(posix 的には ps -eo FORMAT)

自身のプロセスIDとプロセスグループIDが同一である場合、そのプロセスをプロセスグループリーダーである、という。  
セッションについても同様に、セッションリーダーが存在する。

ps axjf コマンドの STAT カラムのスモールsがセッションリーダーであることを示す。


## プロセスグループの影響範囲
fork により生成された子プロセスは親プロセスと同じプロセスグループIDを持つ。  
(ただし、fork 後 exec が実行されている場合はその限りではない。)

パイプにより繋がれたコマンドは同じプロセスグループIDを持つ。

Ctrl + C などにより SIGINT シグナルを送信する場合、フォアグランドのプロセスが属するプロセスグループに対してシグナルが送信される。kill コマンドを使用している場合も、引数にて指定する pid の前にハイフンを加えることによりシグナルの送信先をプロセスグループとすることが可能。ちなみに、入力したキーに対応するシグナルを確認するには stty -a コマンドを実行する。


## セッションの影響範囲
プロセスグループIDが同一である場合、セッションIDも同一である。つまり、プロセスグループはセッションの部分集合となる。  
あるセッションの全プロセスは一つの制御端末を共有する。セッションリーダーが最初に端末をオープンした際に制御端末は設定される。  
一つのセッションでフォアグランドジョブになれるのは一つのプロセスまで。

例：デーモンプロセスの作成
デーモンプロセス
- バックグラウンド
- 制御端末を持たない
- 他のセッションに属さない


1. fork - exec によりプログラムを実行
1. sedsid(2) によりセッションを生成

