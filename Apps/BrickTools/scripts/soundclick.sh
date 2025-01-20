#!/bin/bash

ACTION=$1

APPDIR=$(realpath "$(dirname $0)/../")

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
    if [ -f ./click-off.wav ]; then
        echo "{{state=0}}"
    else
        echo "{{state=1}}"
    fi
    exit 0
fi

if [ "$ACTION" == "1" ]; then
    if [ -f ./click-off.wav ]; then
        mv ./click-off.wav ./click.wav
    else
        echo "The file ./click-off.wav doesn't exists."
    fi    
fi

if [ "$ACTION" == "0" ]; then
    if [ ! -f ./click-off.wav ]; then
        mv ./click.wav ./click-off.wav
    else
        echo "The file ./click-off.wav already exists."
    fi
fi

