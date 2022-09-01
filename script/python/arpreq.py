#! /usr/bin/env python3

from scapy.all import *

dst_mac = 'ff:ff:ff:ff:ff:ff'
src_mac = 'xx:xx:xx:xx:xx:xx'

dst_ip = 'x.x.x.x'
src_ip = 'x.x.x.x'

arp_type = 1

pad_size = 18
pad = Padding()
pad.load = '\x00' * pad_size

arpframe = Ether(dst=dst_mac, src=src_mac) / ARP(op=arp_type, pdst=dst_ip, psrc=src_ip, hwsrc=src_mac)

sendp(arpframe / pad)
