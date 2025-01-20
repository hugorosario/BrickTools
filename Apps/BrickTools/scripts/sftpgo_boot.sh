#!/bin/sh

PROGDIR=/mnt/SDCARD/Apps/BrickTools/scripts/bin/sftpgo
cd $PROGDIR
mkdir -p /opt/sftpgo
nice -2 $PROGDIR/sftpgo serve -c $PROGDIR > /dev/null &