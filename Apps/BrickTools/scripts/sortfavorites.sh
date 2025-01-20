#!/bin/sh

ROMS_DIR=/mnt/SDCARD/Roms
FAV_FILE=favourite2.json

echo "Sorting favourites file..."

if [ ! -d $ROMS_DIR ]; then
    echo "Roms directory not found"
    exit 0
fi

if [ ! -f $ROMS_DIR/$FAV_FILE ]; then
    echo "Favourites file not found"
    exit 0
fi

if [ ! -f /mnt/SDCARD/System/bin/jq ]; then
    echo "jq command not found"
    exit 0
fi

cd $ROMS_DIR
cp $FAV_FILE $FAV_FILE.bak
/mnt/SDCARD/System/bin/jq -S -c -s 'sort_by(.label)[]' < $FAV_FILE > $FAV_FILE.tmp
mv $FAV_FILE.tmp $FAV_FILE
sync

echo "Favorites file sorted successfully!"

exit 0