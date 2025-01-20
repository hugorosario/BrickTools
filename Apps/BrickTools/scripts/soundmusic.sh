#!/bin/sh

ACTION=$1

CurrentTheme=$(/mnt/SDCARD/System/bin/jq -r .theme /mnt/UDISK/system.json)
if [ -z "$CurrentTheme" ]; then
    echo "Unable to determine the current theme."
    exit 1
fi

if [ $CurrentTheme == "../res/" ]; then
    CurrentTheme="/usr/trimui/res"
fi

if [ ! -d "$CurrentTheme" ]; then
    echo "The current theme directory does not exist."
    exit 1
fi

cd "$CurrentTheme/sound/"

if [ "$ACTION" == "check" ]; then
    if [ -f ./bgm-off.mp3 ]; then
        echo "{{state=0}}"
    else
        echo "{{state=1}}"
    fi
    exit 0
fi

if [ "$ACTION" == "1" ]; then
    if [ -f ./bgm-off.mp3 ]; then
        mv ./bgm-off.mp3 ./bgm.mp3
    else
        echo "The file ./bgm-off.mp3 doesn't exists."
    fi    
fi

if [ "$ACTION" == "0" ]; then
    if [ ! -f ./bgm-off.mp3 ]; then
        mv ./bgm.mp3 ./bgm-off.mp3
    else
        echo "The file ./bgm-off.mp3 already exists."
    fi
fi

