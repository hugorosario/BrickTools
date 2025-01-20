#!/bin/bash

ACTION=$1

SCRIPTDIR=$(realpath "$(dirname $0)")
DAEMON=$SCRIPTDIR/led_daemon.sh

mkdir -p /mnt/SDCARD/System/starts

if [ "$ACTION" == "check" ]; then
    if [ -f $DAEMON ]; then
        effect=$(sed -n 's/^DELAY=\([0-9]*\)/\1/p' $DAEMON)
        echo "{{state=$effect}}"
    else 
        echo "{{state=0}}"
    fi
    exit 0
else
    echo "Setting led daemon..."
    pkill -f $DAEMON
    mode=$(sed -n 's/^DELAY=\([0-9]*\)/\1/p' $DAEMON)
    sed -i "s/DELAY=$mode/DELAY=$ACTION/" $DAEMON
    chmod +x $DAEMON    
    $DAEMON > /dev/null 2>&1 &
    exit 0
fi

