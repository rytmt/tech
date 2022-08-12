#!/bin/bash
# usage: split_cert.sh '/path/to/certfile'

if [ $# -ne 1 ]; then
    echo 'Requires one arguments.'
    exit 1
fi
if [ ! -f "$1" ]; then
    echo "cannot open $1. No such file."
    exit 1
fi

trust_name="$1"
tmp_name='beginlist.tmp'

cnt=1
cert_name=''
prefix='^'
suffix='$'

grep -n -F -- '-----BEGIN' $trust_name | cut -d ':' -f 1 > $tmp_name

cat $trust_name | while read line
do
    grep $prefix$cnt$suffix $tmp_name
    if [ $? -eq 0 ]; then
        cert_name="cert-$cnt.crt"
    fi

    echo $line >> $cert_name
    cnt=$((++cnt))
done
