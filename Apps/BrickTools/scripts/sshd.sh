#!/bin/bash
PATH="/mnt/SDCARD/System/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"

ACTION=$1

if [ "$ACTION" = "check" ]; then
    # if dropbear binary does not exist, return 0
    if [ ! -f /mnt/SDCARD/System/bin/dropbear ]; then
        echo "{{listening=(not installed)}}"
        echo "{{state=0}}"
        exit 0
    fi
    if pgrep -x "dropbear" > /dev/null; then
        IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')
        echo "{{listening=User/Pwd: root/tina}}"
        echo "{{state=1}}"
    else
        echo "{{listening=(not running)}}"
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" = "1" ]; then
    echo "Enabling SSH Server..."
    pkill dropbear
    sed -i 's/export NETWORK_SSH="N"/export NETWORK_SSH="Y"/' /mnt/SDCARD/System/etc/ex_config
    mkdir -p /etc/dropbear
    nice -2 dropbear -R
    sleep 1
    if pgrep -x "dropbear" > /dev/null; then
        echo "SSH Server enabled successfully!"
    else
        echo "Failed to enable SSH Server!"
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "Disabling SSH Server..."
    pkill dropbear
    sed -i 's/export NETWORK_SSH="Y"/export NETWORK_SSH="N"/' /mnt/SDCARD/System/etc/ex_config
    echo "SSH Server disabled successfully!"
    exit 0
fi
