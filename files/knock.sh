#!/bin/bash

if [[ $1 = open ]]; then
    nmap -p 5013 192.168.255.1 >/dev/null
    nmap -p 6012 192.168.255.1 >/dev/null
    nmap -p 7011 192.168.255.1 >/dev/null

    echo "ssh port opened"
elif [[ $1 = close ]]; then
    nmap -p 5011 192.168.255.1 >/dev/null
    nmap -p 6010 192.168.255.1 >/dev/null
    nmap -p 7009 192.168.255.1 >/dev/null

    echo "ssh port closed"
else
    echo "unknown command"
fi
