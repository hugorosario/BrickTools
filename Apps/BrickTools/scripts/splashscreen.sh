#!/bin/sh

ACTION=$1
SCRIPTDIR=$(pwd)/scripts

if [ "$ACTION" = "check" ]; then
    if [ -f $SCRIPTDIR/splashselection ]; then
        echo "{{state=$(cat $SCRIPTDIR/splashselection)}}"
    else
        echo "{{state=0}}"
    fi
    exit 0
fi

SELECTION=$ACTION

LOGODIR=$(pwd)/splashscreens
LOGO_PATH=$LOGODIR/$SELECTION.png
DESTINATION="/etc/splash.png"

echo "Selected bootlogo: $LOGO_PATH"
if [ ! -f $LOGO_PATH ]; then
	echo "$SELECTION.png does not exist in $LOGODIR"
	exit 0
fi

cp "$LOGO_PATH" $DESTINATION

echo $SELECTION > $SCRIPTDIR/splashselection
echo "Splashscreen set successfully!"

echo "confirm:A reboot is required to apply the changes.\nDo you want to reboot now?"
read -r response
if [ "$response" == "A" ]; then
    echo "Rebooting..."
    reboot > /dev/null 2>&1 &
fi
