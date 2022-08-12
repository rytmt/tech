#!/bin/bash
# usage: ping x.x.x.x | ping_dd.sh

dflg=''
old=-1
new=0

while read line; do
    new="$(echo $line | grep -Eo 'icmp_seq=[0-9]+' | cut -d '=' -f 2)"
    withtime="$( echo "$(date '+[%Y/%m/%d %H:%M:%S.%N]') $line")"
    [ "$new" = "" ] && new=0
    [ $((new - old)) -ne 1 ] && dflg='===== Down Detect ====='
    echo "$withtime   $dflg"
    old=$new
    dflg=''
done
