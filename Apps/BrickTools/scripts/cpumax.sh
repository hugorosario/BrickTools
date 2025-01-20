#!/bin/bash

ACTION=$1

SCRIPTDIR=$(dirname $0)
BOOTFILE="/mnt/SDCARD/System/starts/cpumax_boot.sh"

mkdir -p /mnt/SDCARD/System/starts

if [ "$ACTION" == "check" ]; then
    if [ -f $BOOTFILE ]; then
        echo "{{state=1}}"
    else
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" == "1" ]; then
    pkill -f $BOOTFILE
    rm -f $BOOTFILE
    cp $SCRIPTDIR/cpumax_boot.sh $BOOTFILE
    chmod +x $BOOTFILE
    $BOOTFILE > /dev/null &
    exit 0
fi

if [ "$ACTION" == "0" ]; then
    pkill -f $BOOTFILE
    rm -f $BOOTFILE
    exit 0
fi

