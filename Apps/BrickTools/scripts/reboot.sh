#!/bin/sh

# Reboot the system
echo "confirm:Reboot the system now?"
read -r response
if [ "$response" == "A" ]; then
    echo "Rebooting..."
    reboot > /dev/null 2>&1 &
else
    echo "Reboot cancelled."
fi

exit 0