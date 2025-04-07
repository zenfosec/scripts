#!/bin/bash

# This script is used to enumerate services on hosts based on the results of a masscan scan.
# It uses nmap to perform the enumeration and outputs the results regular nmap format, 
# grepable format, and XML format.
# Note that the nmap_output_filename will be used to create three files: nmap_output_filename.nmap, 
#nmap_output_filename.gnmap, and nmap_output_filename.xml
# Usage: ./enumerate.sh <input_file> <nmap_output_filename>
# Original script written by zenfosec on 4/7/2025

# Check to see if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi
# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_file> <nmap_output_filename>"
    exit 1
fi
# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: The input file does not exist. Please check your input and try again."
    exit 1
fi
# Check if the input file is empty
if [ ! -s "$1" ]; then
    echo "Error: The input file is empty. No hosts found."
    exit 1
fi
# Perform service enumeration using nmap
echo "Parsing masscan output file..."

# Read the masscan output file and extract the ports
grep "Ports:" "$1" | sed 's/.*Ports: //' | tr ',' '\n' | awk '{print $1}' |cut -d "/" -f1 | sort -u -n > masscan_ports.txt

# Read ports.txt and create a comma-separated list of ports
for port in $(cat masscan_ports.txt); do
    ports+="$port,"
done
# Remove the trailing comma
ports=${ports%,}
echo "Ports: $ports"
# Read the masscan output file and extract the IPs
grep "Host:" "$1" | sed 's/.*Host: //' | tr ',' '\n' | awk '{print $1}' | sort -u -t . -k1,1n -k2,2n -k3,3n -k4,4n > masscan_ips.txt

echo "Performing service enumeration and script scanning using nmap..."
nmap -sV -Pn -p $ports -T4 -iL masscan_ips.txt -oA "$2" -sC --script=default,vuln --host-timeout 10m