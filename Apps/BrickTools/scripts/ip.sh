#!/bin/sh
# This script will display the current IP address

echo "Checking network connection..."
IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')

#if empty, show an error message
if [ -z "$IP" ]; then
    echo "Unable to get IP address.\nPlease check your network connection."
    echo "{{ip_address=not connected}}"
else
    #display the IP address in tag format for updating app labels
    echo "{{ip_address=$IP}}"
    echo "Current IP address\n$IP"
fi
exit 0