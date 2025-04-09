#!/bin/bash

# This script is used to discover the available devices and open ports on an IP address or range of IP addresses.
# It uses masscan to perform the discovery and outputs the results in masscan's format.
# Usage: ./discover.sh <input_file> <output_file>
# Original script written by zenfosec on 4/7/2025

# Check to see if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input_file> <ips_up_output_file> <masscan_output_file>"
    exit 1
fi

# Perform host discovery using nmap
echo "Performing host discovery using nmap ICMP echo scan..."
nmap -sn -PE -n -iL $1 |grep "scan report" |awk '{print $5}' |sort -u -t . -k1,1n -k2,2n -k3,3n -k4,4n > $2
if [ $? -ne 0 ]; then
    echo "Error: nmap command failed. Please check your input and try again."
    exit 1
fi
echo "Host discovery completed. Results saved to $2."

# Check if the output file is empty
if [ ! -s "$2" ]; then
    echo "Error: The output file is empty. No hosts found."
    exit 1
fi
# Check if the output file exists
if [ ! -f "$2" ]; then
    echo "Error: The output file does not exist. Please check your input and try again."
    exit 1
fi

# Perform port scanning using masscan
echo "Performing port scanning using masscan..."
masscan --rate=10000 -p1-65535 --open --banners -iL "$2" -oG "$3"
if [ $? -ne 0 ]; then
    echo "Error: masscan command failed. Please check your input and try again."
    exit 1
fi
echo "Discovery completed. Results saved to $3."
# Check if the output file is empty
if [ ! -s "$2" ]; then
    echo "Error: The masscan output file is empty. No open ports found."
    exit 1
fi
# Check if the output file exists
if [ ! -f "$2" ]; then
    echo "Error: The masscan output file does not exist. Please check your input and try again."
    exit 1
fi
