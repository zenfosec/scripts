#!/usr/bin/env python

# Takes an input nmap xml file and script name and outputs the ip, port, and script results
#
# zenfosec 4/16/2014

import xml.etree.ElementTree as ET
import sys
import re

if len(sys.argv) != 3:
    print "Usage: script_miner.py <nmapresults.xml> <script_title>"
    sys.exit()

scriptname = sys.argv[2]

# opens file and imports as a tree into "root"
tree = ET.parse(sys.argv[1])
root = tree.getroot()


# iterates through tree and prints "ip:port script_output"
for child in root:
    for host in child:
        if host.tag == 'address':
            ip = host.attrib['addr']
        for port in host:
            if port.tag == 'port':
                portnumber = port.attrib['portid']
            for status in port:
                try:
                    if status.tag == "script":
                        if status.attrib['id'] == scriptname:
                            output = repr(status.attrib['output'])
                            output = re.sub(r'\\n', '', output)
                            output = re.sub("\'", '', output)
                            output = re.sub(r'\s+', ' ', output)
                            print "%s:%s %s: %s" % (ip,portnumber,scriptname,output)
                except:
                    next