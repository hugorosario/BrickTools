#!/bin/bash

################################################################################
SYNCUSER=trimui
SYNCPASS=trimuisync
DEVICENAME=Trimui\ Brick
DEFAULTFOLDER=/mnt/SDCARD/System/syncthing/files
################################################################################

export PATH="/mnt/SDCARD/System/bin:$PATH"
export LD_LIBRARY_PATH="/mnt/SDCARD/System/lib:/usr/trimui/lib:$LD_LIBRARY_PATH"

HOMEAPP=$(pwd)
HOMEBIN=/mnt/SDCARD/System/syncthing
SBOOT=/mnt/SDCARD/System/starts

ACTION=$1

if [ "$ACTION" = "check" ]; then
    if pgrep -x "./syncthing" > /dev/null; then
        IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')
        # get port from config.xml in node <address>0.0.0.0:8384</address>
        PORT=$(sed -n 's/.*<address>.*:\([0-9]*\)<\/address>.*/\1/p' $HOMEBIN/config.xml)
        echo "{{listening=Port: $PORT | User/Pwd: $SYNCUSER/$SYNCPASS}}"
        echo "{{state=1}}"
    else
        echo "{{listening=(not running)}}"
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" = "1" ]; then
    echo "Enabling Syncthing..."

    echo "Stopping syncthing..."
    kill -2 $(pidof syncthing)
    kill -9 $(pidof syncthing)
    rm -rf $SBOOT/syncthing_boot.sh

    echo "Installing syncthing binary..."
    mkdir -p $HOMEBIN/data
    mv $HOMEAPP/bin/syncthing $HOMEBIN/
    chmod +x $HOMEBIN/syncthing

    if [ ! -f $HOMEBIN/config.xml ]; then
        echo "Generating Syncthing config..."
        cd $HOMEBIN/
        ./syncthing generate --no-default-folder --gui-user="$SYNCUSER" --gui-password="$SYNCPASS" --config="$HOMEBIN"
        # allow for external connections and show a better device name 
        sed -i 's|127\.0\.0\.1|0.0.0.0|' $HOMEBIN/config.xml
        sed -i "s|TinaLinux|$DEVICENAME|" $HOMEBIN/config.xml
        mkdir -p $DEFAULTFOLDER
        sed -i "s|\~|$DEFAULTFOLDER|" $HOMEBIN/config.xml        
    fi

    echo "Setting up syncthing to run on boot..."
    mkdir -p /mnt/SDCARD/System/starts
    cp $HOMEAPP/syncthing_boot.sh $SBOOT/
    $SBOOT/syncthing_boot.sh &

    sleep 1
    if pgrep -x "./syncthing" > /dev/null; then
        echo "SyncThing enabled successfully!"
    else
        echo "Failed to enable SyncThing!"
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "Disabling Syncthing..."
    kill -2 $(pidof syncthing)
    kill -9 $(pidof syncthing)
    rm -rf $HOMEAPP/status.lock
    rm -rf $SBOOT/syncthing_boot.sh
    echo "Syncthing disabled successfully!"
    exit 0
fi
