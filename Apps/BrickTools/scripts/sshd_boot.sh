#!/bin/sh

PROGDIR=/mnt/SDCARD/Apps/BrickTools/scripts/bin/sshd
cd $PROGDIR
mkdir -p /etc/dropbear
nice -2 $PROGDIR/dropbear -R
