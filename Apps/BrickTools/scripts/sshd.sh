#!/bin/sh

SCRIPTDIR=$(pwd)/scripts
SBOOT=/mnt/SDCARD/System/starts

ACTION=$1

if [ "$ACTION" = "check" ]; then
    # if dropbear binary does not exist, return 0
    if [ ! -f $SCRIPTDIR/bin/sshd/dropbear ]; then
        echo "{{listening=(not installed)}}"
        echo "{{state=0}}"
        exit 0
    fi
    if pgrep -x "$SCRIPTDIR/bin/sshd/dropbear" > /dev/null; then
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
    killall dropbear
    cp $SCRIPTDIR/sshd_boot.sh $SBOOT/
    $SBOOT/sshd_boot.sh > /dev/null 2>&1 &
    sleep 1
    if pgrep -x "$SCRIPTDIR/bin/sshd/dropbear" > /dev/null; then
        echo "SSH Server enabled successfully!"
    else
        echo "Failed to enable SSH Server!"
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "Disabling SSH Server..."
    killall dropbear
    sleep 1
    rm -rf $SBOOT/sshd_boot.sh
    echo "SSH Server disabled successfully!"
    exit 0
fi
