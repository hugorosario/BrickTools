#!/bin/sh

# Reboot the system
echo "confirm:Reboot the system now?"
read -r response
if [ "$response" == "A" ]; then
    echo "Rebooting..."
    reboot &
else
    echo "Reboot cancelled."
fi

exit 0