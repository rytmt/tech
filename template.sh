#!/bin/sh

# --------------------------------------------------
# Script Name: 
# Version: 
# Abstruct:
#   
# Designed On  by 
# --------------------------------------------------


# --------------------------------------------------
# Common initialization
# --------------------------------------------------

# clear all alias if defined unalias command
[ "$(\type unalias >/dev/null 2>&1)" ] && \unalias -a

# env variables
PATH='/bin:/usr/bin:/sbin:/usr/sbin'
IFS=$(printf ' \t\n_'); IFS=${IFS%_}
LANG=C; LC_ALL=C
export PATH IFS LANG LC_ALL

# error function
err() {
    printf "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@\n" >&2
}

# check arguments
if [ $# -ne 0 ]; then
    err 'Argument error.\n'
    exit 1
fi

# set default permission
umask 0022

# global redirect for standard error
exec 2> "$(basename ${0}).error.$(date +%Y%m%d%H%M%S).log"

# error occur when refer undefined variable
set -u

# the shell shall write its input to standard error as it is read
set -v

# the shell shall write to standard error a trace
set -x



# --------------------------------------------------
# Variable initialization
# --------------------------------------------------



# --------------------------------------------------
# Main processing
# --------------------------------------------------


