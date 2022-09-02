#! /usr/bin/env python3

from scapy.all import *

dst_mac = 'ff:ff:ff:ff:ff:ff'
src_mac = '00:50:56:b3:77:1b'

dst_ip = '192.168.66.58'
src_ip = '192.168.66.57'

arp_type = 1

pad_size = 18
pad = Padding()
pad.load = '\x00' * pad_size

arpframe = Ether(dst=dst_mac, src=src_mac) / ARP(op=arp_type, pdst=dst_ip, psrc=src_ip, hwsrc=src_mac)

sendp(arpframe / pad)
