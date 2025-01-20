#!/bin/sh

ACTION=$1

APPDIR=$(pwd)

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

cd "$CurrentTheme/skin/"

# Check state of the toggle
if [ "$ACTION" == "check" ]; then
    if [ -f ./nav-logo-off.png ]; then
        echo "{{state=0}}"
    else
        echo "{{state=1}}"
    fi
    exit 0
fi

# Enable the logo
if [ "$ACTION" == "1" ]; then
    if [ -f ./nav-logo-off.png ]; then
        mv ./nav-logo-off.png ./nav-logo.png
    else
        echo "The file ./nav-logo-off.png doesn't exists."
    fi

    if [ -f ./icon-back-off.png ]; then
        mv ./icon-back-off.png ./icon-back.png
    else
        echo "The file ./icon-back-off.png doesn't exists."
    fi

    if [ -f ./icon-trimui-off.png ]; then
        mv ./icon-trimui-off.png ./icon-trimui.png
    else
        echo "The file ./icon-trimui-off.png doesn't exists."
    fi
fi

# Disable the logo
if [ "$ACTION" == "0" ]; then

    if [ ! -f $APPDIR/empty.png ]; then
        echo "The file empty.png does not exist."
        exit 1
    fi

    if [ ! -f ./nav-logo-off.png ]; then
        mv ./nav-logo.png ./nav-logo-off.png
        cp $APPDIR/empty.png ./nav-logo.png
    else
        echo "The file ./nav-logo-off.png already exists."
    fi

    if [ ! -f ./icon-back-off.png ]; then
        mv ./icon-back.png ./icon-back-off.png
        cp $APPDIR/empty.png ./icon-back.png
    else
        echo "The file ./nav-logo-off.png already exists."
    fi

    if [ ! -f ./icon-trimui-off.png ]; then
        mv ./icon-trimui.png ./icon-trimui-off.png
        cp $APPDIR/empty.png ./icon-trimui.png
    else
        echo "The file ./nav-trimui-off.png already exists."
    fi    
fi

sync

