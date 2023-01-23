#!/usr/bin/env python3

import os
import re
from scapy.all import *


# 指定されなかった環境変数名を格納するためのリスト
neenvlist = []

# 環境変数を取得するための関数
def get_os_environ(keyname):

    tmp = None
    try:
        tmp = os.environ[keyname]
    except KeyError as ke:
        neenvlist.append(str(ke))

    return tmp

# ARP Request の送受信アドレス情報を環境変数から取得
dst_mac = 'ff:ff:ff:ff:ff:ff'
src_mac = get_os_environ('ARPREQ_SRCMAC')
dst_ip = get_os_environ('ARPREQ_DSTIP')
src_ip = get_os_environ('ARPREQ_SRCIP')

# いずれかの環境変数が指定されていなかった場合
if len(neenvlist) != 0:
    neenvlist=','.join(neenvlist)
    print(f'環境変数 ({neenvlist}) が指定されていません')
    exit(1)

# アドレスの(適当)正規表現
regex_mac = '[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}'
regex_ip = '[12]?[0-9]{1,2}\.[12]?[0-9]{1,2}\.[12]?[0-9]{1,2}\.[12]?[0-9]{1,2}'


# 環境変数から取得したアドレス情報が正規表現にマッチしないならスクリプト終了
if re.search(regex_mac, src_mac) and re.search(regex_ip, dst_ip) and re.search(regex_ip, src_ip):
    pass
else:
    print('環境変数 (ARPREQ_SRCMAC, ARPREQ_DSTIP, ARPREQ_SRCIP のいずれか) の形式が正しくありません')
    exit(1)


# ARP Request の type は 1
arp_type = 1

# イーサネットに必要なフレーム数になるようにパディングを追加
pad_size = 18
pad = Padding()
pad.load = '\x00' * pad_size

# ARP Request フレームを送信
arpframe = Ether(dst=dst_mac, src=src_mac) / ARP(op=arp_type, pdst=dst_ip, psrc=src_ip, hwsrc=src_mac)
sendp(arpframe / pad)
