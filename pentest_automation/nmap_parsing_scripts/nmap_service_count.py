#!/usr/bin/env python
#
# Counts the occurrences of each service found in a gnmap file
# Outputs a space delimited list of <service> <count>
#
# 9/20/11 - zenfosec

import sys
import re

if len(sys.argv) != 2:
    print "Usage: servcount.py <gnmap_file>"
    sys.exit()

infile = open(sys.argv[1], "r")

serv_dict = {}

#search for services, add service and count to dict
for line in infile:
    services = re.findall("//[a-zA-Z0-9][^/]*/[,\t\n]", line)
    strippedservices = []
    for service in services:
        strippedservices.append(service[2:-2])
    for service in strippedservices:
        try:
            if serv_dict[service]:
                serv_dict[service] = serv_dict[service] + 1
        except:
            serv_dict[service] = 1


keylist = serv_dict.keys()
keylist.sort()

for key in keylist:
    print key + ", " + str(serv_dict[key])