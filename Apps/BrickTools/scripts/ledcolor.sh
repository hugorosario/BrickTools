#!/bin/sh

ACTION=$1

SCRIPTDIR=$(pwd)/scripts
DAEMONNAME=led_daemon.sh
DAEMON=$SCRIPTDIR/$DAEMONNAME

mkdir -p /mnt/SDCARD/System/starts

echo "Daemon: $DAEMON"

if [ "$ACTION" == "check" ]; then
    if [ -f $DAEMON ]; then
        effect=$(sed -n 's/^COLOR=\([0-9]*\)/\1/p' $DAEMON)
        echo "{{state=$effect}}"
    else 
        echo "{{state=0}}"
    fi
    exit 0
else
    echo "Killing led daemon..."
    killall $DAEMONNAME
    echo "Setting led daemon..."
    mode=$(sed -n 's/^COLOR=\([0-9]*\)/\1/p' $DAEMON)
    sed -i "s/COLOR=$mode/COLOR=$ACTION/" $DAEMON
    chmod +x $DAEMON    
    sync
    $DAEMON > /dev/null 2>&1 &

    exit 0
fi

