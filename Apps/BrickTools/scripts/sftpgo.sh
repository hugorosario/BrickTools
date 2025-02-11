#!/bin/sh

SCRIPTDIR=$(pwd)/scripts
SBOOT=/mnt/SDCARD/System/starts

ACTION=$1

if [ "$ACTION" = "check" ]; then
    # if sftpgo binary does not exist, return 0
    if [ ! -f $SCRIPTDIR/bin/sftpgo/sftpgo ]; then
        echo "{{listening=(not installed)}}"
        echo "{{state=0}}"
        exit 0
    fi
    if pgrep -x "$SCRIPTDIR/bin/sftpgo/sftpgo" > /dev/null; then
        HTTP=$(/mnt/SDCARD/System/bin/jq -r '.httpd.bindings[0].port' $SCRIPTDIR/bin/sftpgo/sftpgo.json)
        SFTP=$(/mnt/SDCARD/System/bin/jq -r '.sftpd.bindings[0].port' $SCRIPTDIR/bin/sftpgo/sftpgo.json)
        FTP=$(/mnt/SDCARD/System/bin/jq -r '.ftpd.bindings[0].port' $SCRIPTDIR/bin/sftpgo/sftpgo.json)
        echo "{{listening=HTTP: $HTTP | SFTP: $SFTP | FTP: $FTP | User/Pwd: trimui/trimui}}"
        echo "{{state=1}}"
    else
        echo "{{listening=(not running)}}"
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" = "1" ]; then
    if [ ! -f $SCRIPTDIR/bin/sftpgo/sftpgo ]; then
        echo "SFTPGo binary not found!"
        exit 1
    fi
    echo "Enabling SFTPGo..."
    killall sftpgo
    cp $SCRIPTDIR/sftpgo_boot.sh $SBOOT/
    $SBOOT/sftpgo_boot.sh > /dev/null 2>&1 &

    sleep 1
    if pgrep -x "$SCRIPTDIR/bin/sftpgo/sftpgo" > /dev/null; then
        echo "SFTPGo enabled successfully!"
    else
        echo "Failed to enable SFTPGo!"
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "Disabling SFTPGo..."
    killall sftpgo
    rm -rf $SBOOT/sftpgo_boot.sh
    echo "SFTPGo disabled successfully!"
    exit 0
fi
