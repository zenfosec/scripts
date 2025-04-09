#!/usr/bin/env python

# Takes an input nmap xml file and ouputs a comma separated list of open ports
# This does not include open|filtered ports and is used for an nmap command such as:
#
# nmap -sU -sV -p123,137,161,1645,182 10.10.10.10 -oA udp-services
#
# zenfosec 4/2/14

import xml.etree.ElementTree as ET
import sys

if len(sys.argv) != 2:
    print "Usage: portcount.py <nmapresults.xml>"
    sys.exit()

openports = []

# opens file and imports as a tree into "root"
tree = ET.parse(sys.argv[1])
root = tree.getroot()


# iterates through tree and append ports to openports array
for child in root:
    for host in child:
        for port in host:
            for status in port:
                try:
                    if status.attrib['state'] == 'open':
                        port = port.attrib['portid']
                        if port not in openports:
                            openports.append(port)
                except:
                    next

nmapportlist = ",".join(openports)
print nmapportlist