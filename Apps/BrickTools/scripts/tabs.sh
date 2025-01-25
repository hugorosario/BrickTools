#!/bin/sh

ACTION=$1

INDEX=0
OFFSET=0

mkdir -p /mnt/SDCARD/System/starts

hasBest() {
    find /mnt/SDCARD/Best -name config.json -print -quit | grep -q .
    return $?
}

if [ "$ACTION" == "check" ]; then
    if [ -f /mnt/SDCARD/System/starts/start_tab.sh ]; then
        tab="$(grep tabidx /mnt/SDCARD/System/starts/start_tab.sh | sed -E 's/.*:[[:space:]]+([^,]),/\1/')"
        if ! hasBest && [ "$tab" -ge 2 ]; then 
            tab=$((tab + 1))
        fi
        echo "{{state=$tab}}"
    fi
    exit 0
fi

case "$ACTION" in
    0) INDEX=0; OFFSET=0 ;; # Favorites
    1) INDEX=1; OFFSET=0 ;; # Recents
    2) INDEX=2; OFFSET=0 ;; # Best
    3) # Games
        if hasBest; then
            INDEX=3; OFFSET=2
        else
            INDEX=2; OFFSET=1
        fi
        ;;
    4) # Apps
        if hasBest; then
            INDEX=4; OFFSET=2
        else
            INDEX=3; OFFSET=2
        fi
        ;;
    5) # Netplay
        if hasBest; then
            INDEX=5; OFFSET=2
        else
            INDEX=4; OFFSET=2
        fi
        ;;
    6) # Settings
        if hasBest; then
            INDEX=6; OFFSET=3
        else
            INDEX=5; OFFSET=3
        fi
        ;;
esac

cat >/mnt/SDCARD/System/starts/start_tab.sh <<-EOM
cat > /tmp/state.json <<- EOM2
{
	"list":	[{
			"title":	0,
			"type":	0,
			"tabidx":	$INDEX,
			"tabstartidx":	$OFFSET,
			"tabstate":	[{
					"currpos":	0,
					"pagestart":	0,
					"pageend":	0
				}]                        
		}]
}
EOM2
EOM

echo "confirm:A reboot is required to apply the changes.\nDo you want to reboot now?"
read -r response
if [ "$response" == "A" ]; then
    reboot > /dev/null 2>&1 &
fi

exit 0
