#!/bin/sh

PROGDIR=/mnt/SDCARD/Apps/BrickTools/scripts/bin/syncthing
cd $PROGDIR
./syncthing serve --no-restart --no-upgrade --config="$PROGDIR" --data="$PROGDIR/data" > /dev/null &