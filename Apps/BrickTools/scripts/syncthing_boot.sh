#!/bin/sh

PROGDIR=/mnt/SDCARD/System/syncthing
cd $PROGDIR
./syncthing serve --no-restart --no-upgrade --config="$PROGDIR" --data="$PROGDIR/data" > /dev/null &