#!/usr/bin/env python
#
# Counts the occurrences of each port found in a gnmap file
# Outputs a space delimited list of <port> <count>
#
# 9/20/11 - zenfosec
# Updated 5/15/18

import sys
import re

if len(sys.argv) != 2:
    print "Usage: portcount.py <gnmap_file>"
    sys.exit()

infile = open(sys.argv[1], "r")

port_dict = {}

#search for ports, add port and count to dict
for line in infile:
    splitline=line.split('/')
    host=splitline[0]
    ports = re.findall(" \d*/open", line)
    strippedports= []
    for port in ports:
        strippedports.append(port[1:-5])
    for port in strippedports:
        try:
            if port_dict[port]:
                port_dict[port] = port_dict[port] + 1
        except:
            port_dict[port] = 1

portlist = port_dict.keys()
portlist = map(int, portlist)
portlist.sort()
for port in portlist:
    key = str(port)
    print key, str(port_dict[key])