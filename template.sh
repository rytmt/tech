#!/bin/sh

# clear all alias if defined unalias command
[ "$(type unalias >/dev/null 2>&1)" ] && unalias -a

# error occur when refer undefined variable
set -u

# set default permission
umask 0022

# env variables
PATH='/bin:/usr/bin:/sbin:/usr/sbin'
IFS=$(printf ' \t\n_'); IFS=${IFS%_}
LANG=C; LC_ALL=C
export PATH IFS LANG LC_ALL

# check arguments
if [ $# -ne 0 ]; then
    echo 'Argument error.'
    exit 1
fi
