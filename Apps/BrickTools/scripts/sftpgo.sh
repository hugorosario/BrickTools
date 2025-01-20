#!/bin/bash
PATH="/mnt/SDCARD/System/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"

ACTION=$1

if [ "$ACTION" = "check" ]; then
    # if sftpgo binary does not exist, return 0
    if [ ! -f /mnt/SDCARD/System/sftpgo/sftpgo ]; then
        echo "{{listening=(not installed)}}"
        echo "{{state=0}}"
        exit 0
    fi
    if pgrep -x "/mnt/SDCARD/System/sftpgo/sftpgo" > /dev/null; then
        IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')
        PORT=$(/mnt/SDCARD/System/bin/jq -r '.httpd.bindings[0].port' /mnt/SDCARD/System/sftpgo/sftpgo.json)
        echo "{{listening=Port: $PORT | User/Pwd: trimui/trimui}}"
        echo "{{state=1}}"
    else
        echo "{{listening=(not running)}}"
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" = "1" ]; then
    echo "Enabling SFTPGo..."
    sed -i 's/export NETWORK_SFTPGO="N"/export NETWORK_SFTPGO="Y"/' /mnt/SDCARD/System/etc/ex_config
    pkill /mnt/SDCARD/System/sftpgo/sftpgo
    mkdir -p /opt/sftpgo
    nice -2 /mnt/SDCARD/System/sftpgo/sftpgo serve -c /mnt/SDCARD/System/sftpgo/ >/dev/null &
    sleep 1
    if pgrep -x "/mnt/SDCARD/System/sftpgo/sftpgo" > /dev/null; then
        echo "SFTPGo enabled successfully!"
    else
        echo "Failed to enable SFTPGo!"
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "Disabling SFTPGo..."
    sed -i 's/export NETWORK_SFTPGO="Y"/export NETWORK_SFTPGO="N"/' /mnt/SDCARD/System/etc/ex_config
    pkill /mnt/SDCARD/System/sftpgo/sftpgo
    echo "SFTPGo disabled successfully!"
    exit 0
fi
