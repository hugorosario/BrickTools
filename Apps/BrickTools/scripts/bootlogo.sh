#!/bin/sh

ACTION=$1
SCRIPTDIR=$(pwd)/scripts

if [ "$ACTION" = "check" ]; then
    if [ -f $SCRIPTDIR/bootselection ]; then
        echo "{{state=$(cat $SCRIPTDIR/bootselection)}}"
    else
        echo "{{state=0}}"
    fi
    exit 0
fi

SELECTION=$ACTION

LOGODIR=$(pwd)/bootlogos
LOGO_PATH=$LOGODIR/$SELECTION.bmp

TARGET_PARTITION="/dev/mmcblk0p1"
MOUNT_POINT="/mnt/emmcblk0p1"

echo "Selected bootlogo: $LOGO_PATH"
if [ ! -f $LOGO_PATH ]; then
	echo "$SELECTION.bmp does not exist in $LOGODIR"
	exit 0
fi

echo "Flashing $SELECTION.bmp bootlogo..."
echo "Mounting $TARGET_PARTITION to $MOUNT_POINT..."
mkdir -p $MOUNT_POINT
mount -t vfat $TARGET_PARTITION $MOUNT_POINT
cp "$LOGO_PATH" "$MOUNT_POINT/bootlogo.bmp"
sync
umount $TARGET_PARTITION
rmdir $MOUNT_POINT
echo $SELECTION > $SCRIPTDIR/bootselection
echo "Bootlogo flashed successfully!"

echo "confirm:A reboot is required to apply the changes.\nDo you want to reboot now?"
read -r response
if [ "$response" == "A" ]; then
    echo "Rebooting..."
    reboot &
fi
