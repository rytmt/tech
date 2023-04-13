#!/bin/bash

# usage
# cat iplist | ./ping_scan.sh

P_CNT=1
P_TMOUT=1

echo "result,destination"

while read dst; do

    p_result=''
    ping -c ${P_CNT} -W ${P_TMOUT} "${dst}" >/dev/null 2>&1
    if [ "$?" = "0" ]; then
        p_result='OK'
    else
        p_result='NG'
    fi
    printf "%s,%s\n" "${p_result}" "${dst}"

done
