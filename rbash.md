# rbash で制限されたユーザを作成する

1. rbash を作成する
```shell
ln -s /usr/bin/bash /usr/bin/rbash
```

2. アカウントを作成する
```shell
useradd --shell /bin/rbash -d /path/to/home accountname
```

3. パスワードを設定する
```shell
echo -n $password | passwd --stdin accountname
```

4. .bash_profile を作成する (644, root:root)
```shell
# .bash_profile

# インタラクティブな SSH セッションを禁止する場合
[ -n "${SSH_TTY}" ] && exit

export PATH=/path/to/home/bin

# ホームディレクトリ上のドットファイルや bin 配下を見せたくない場合
cd ~/work

. ~/.bashrc
```

5. .bashrc を作成する (644, root:root)
```shell
# allow only following commands
# echo, enable, exit, logout, printf, pwd, return, source, test

enable -n alias
enable -n bg
enable -n bind
enable -n break
enable -n builtin
enable -n caller
enable -n cd
enable -n command
enable -n compgen
enable -n complete
enable -n compopt
enable -n continue
enable -n declare
enable -n dirs
enable -n disown
enable -n eval
enable -n exec
enable -n export
enable -n false
enable -n fc
enable -n fg
enable -n getopts
enable -n hash
enable -n help
enable -n history
enable -n jobs
enable -n kill
enable -n let
enable -n local
enable -n mapfile
enable -n popd
enable -n pushd
enable -n read
enable -n readonly
enable -n set
enable -n shift
enable -n shopt
enable -n suspend
enable -n times
enable -n trap
enable -n true
enable -n type
enable -n typeset
enable -n ulimit
enable -n umask
enable -n unalias
enable -n unset
enable -n wait
```

6. 外部コマンドを配置する
```shell
mkdir /path/to/home/bin
ln -s /usr/bin/ls /path/to/home/bin/ls
```

7. おわり
