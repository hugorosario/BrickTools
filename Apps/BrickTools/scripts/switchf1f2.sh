#!/bin/sh

ACTION=$1

PATCHED=$(dirname $0)/bin/trimui_inputd
INPUTD="/mnt/SDCARD/trimui/app/trimui_inputd"

if [ "$ACTION" = "check" ]; then
    if [ -f $INPUTD ]; then
        echo "{{state=1}}"
    else
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" = "1" ]; then
    echo "confirm:A reboot is required to apply the changes.\n\nReboot now?"
    read -r response
    if [ "$response" == "A" ]; then
        echo "Applying changes..."
        killall trimui_inputd
        mkdir -p /mnt/SDCARD/trimui/app
        cp $PATCHED $INPUTD
        chmod +x $INPUTD    
        echo "Rebooting..."      
        reboot > /dev/null 2>&1 &
    fi
    exit 0
fi

if [ "$ACTION" = "0" ]; then
    echo "confirm:A reboot is required to apply the changes.\n\nReboot now?"
    read -r response
    if [ "$response" == "A" ]; then
        echo "Applying changes..."
        killall trimui_inputd
        rm -f $INPUTD
        echo "Rebooting..."      
        reboot > /dev/null 2>&1 &
    fi
    exit 0
fi