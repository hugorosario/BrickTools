#!/bin/bash

SCRIPTDIR=$(realpath "$(dirname $0)")

# Copy jq command to the system if it doesn't exist
if [ ! -f /mnt/SDCARD/System/bin/jq ]; then
    mkdir -p /mnt/SDCARD/System/bin
    cp $SCRIPTDIR/bin/jq /mnt/SDCARD/System/bin
    chmod +x /mnt/SDCARD/System/bin/jq
fi