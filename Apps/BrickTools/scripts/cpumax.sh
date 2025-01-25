#!/bin/sh

ACTION=$1

SCRIPTDIR=$(pwd)/scripts
DAEMONNAME=cpumax_boot.sh
BOOTFILE="/mnt/SDCARD/System/starts/$DAEMONNAME"

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
    killall $DAEMONNAME
    rm -f $BOOTFILE
    cp $SCRIPTDIR/cpumax_boot.sh $BOOTFILE
    chmod +x $BOOTFILE
    $BOOTFILE > /dev/null 2>&1 &
    exit 0
fi

if [ "$ACTION" == "0" ]; then
    killall $DAEMONNAME
    rm -f $BOOTFILE
    exit 0
fi

