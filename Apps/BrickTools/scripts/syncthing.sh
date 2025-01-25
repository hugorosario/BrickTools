#!/bin/sh

################################################################################
SYNCUSER=trimui
SYNCPASS=trimuisync
DEVICENAME=Trimui\ Brick
################################################################################

SCRIPTDIR=$(pwd)/scripts
HOMEBIN=$SCRIPTDIR/bin/syncthing
DEFAULTFOLDER=$HOMEBIN/files
SBOOT=/mnt/SDCARD/System/starts

ACTION=$1

if [ "$ACTION" = "check" ]; then
    if pgrep -x "./syncthing" > /dev/null; then
        IP=$(ip route get 1 2>/dev/null | awk '{print $NF;exit}')
        # get port from config.xml in node <address>0.0.0.0:8384</address>
        PORT=$(sed -n 's/.*<address>.*:\([0-9]*\)<\/address>.*/\1/p' $HOMEBIN/config.xml)
        echo "{{listening=HTTP: $PORT | User/Pwd: $SYNCUSER/$SYNCPASS}}"
        echo "{{state=1}}"
    else
        echo "{{listening=(not running)}}"
        echo "{{state=0}}"
    fi
    VERSION=$($HOMEBIN/syncthing --version | sed -n 's/.*v\([0-9]*\.[0-9]*\.[0-9]*\).*/\1/p')
    echo "{{version=$VERSION}}"
    exit 0
fi

if [ "$ACTION" = "1" ]; then
    echo "Enabling Syncthing..."

    echo "Stopping syncthing..."
    killall syncthing
    rm -rf $SBOOT/syncthing_boot.sh
    chmod +x $HOMEBIN/syncthing
    sync

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

    sync

    echo "Setting up Syncthing to run on boot..."
    mkdir -p $SBOOT
    cp $SCRIPTDIR/syncthing_boot.sh $SBOOT/
    $SBOOT/syncthing_boot.sh > /dev/null 2>&1 &

    sync

    sleep 1
    if pgrep -x "./syncthing" > /dev/null; then
        echo "Syncthing enabled successfully!"
    else
        echo "Failed to enable Syncthing!"
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "Disabling Syncthing..."
    killall syncthing
    # wait for syncthing to stop
    sleep 1
    rm -rf $SBOOT/syncthing_boot.sh
    echo "Syncthing disabled successfully!"
    exit 0
fi
