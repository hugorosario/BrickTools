#!/bin/sh

ACTION=$1

SCRIPTDIR=$(pwd)/scripts
DAEMONNAME=led_daemon.sh
DAEMON=$SCRIPTDIR/$DAEMONNAME

mkdir -p /mnt/SDCARD/System/starts

echo "Deamon: $DAEMON"

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
    killall $DAEMONNAME
    mode=$(sed -n 's/^DELAY=\([0-9]*\)/\1/p' $DAEMON)
    sed -i "s/DELAY=$mode/DELAY=$ACTION/" $DAEMON
    chmod +x $DAEMON    
    $DAEMON > /dev/null 2>&1 &
    exit 0
fi

