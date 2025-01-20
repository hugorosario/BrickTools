#!/bin/bash

ACTION=$1

SCRIPTDIR=$(realpath "$(dirname $0)")
DAEMON=$SCRIPTDIR/led_daemon.sh
BOOTFILE=/mnt/SDCARD/System/starts/ledmode_boot.sh

mkdir -p /mnt/SDCARD/System/starts

set_led_color() {
    echo 0 > /sys/class/led_anim/effect_enable 
    echo 0 >  /sys/class/led_anim/effect_lr
    echo 0 >  /sys/class/led_anim/effect_m
    echo 0 >  /sys/class/led_anim/effect_f1
    echo 0 >  /sys/class/led_anim/effect_f2    
    echo 0 > /sys/class/led_anim/effect_cycles_lr
    echo 0 > /sys/class/led_anim/effect_cycles_m
    echo 0 > /sys/class/led_anim/effect_cycles_f1
    echo 0 > /sys/class/led_anim/effect_cycles_f2    
    echo 0 > /sys/class/led_anim/effect_duration_lr
    echo 0 > /sys/class/led_anim/effect_duration_m
    echo 0 > /sys/class/led_anim/effect_duration_f1
    echo 0 > /sys/class/led_anim/effect_duration_f2    
    r=$1
    g=$2
    b=$3
    valstr=`printf "%02X%02X%02X" $r $g $b`
    echo "$valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr "\
        "$valstr $valstr $valstr $valstr $valstr $valstr $valstr" > /sys/class/led_anim/frame_hex
}

if [ "$ACTION" == "check" ]; then
    if [ -f $DAEMON ]; then
        mode=$(sed -n 's/^MODE=\([0-9]*\)/\1/p' $DAEMON)
        echo "{{state=$mode}}"
    else 
        echo "{{state=0}}"
    fi
    exit 0
fi

if [ "$ACTION" == "0" ]; then
    echo "Removing boot script..."
    if [ -f $BOOTFILE ]; then
        pkill -f $BOOTFILE
        rm $BOOTFILE
    fi
    echo "Stopping led daemon..."
    pkill -f $DAEMON
    mode=$(sed -n 's/^MODE=\([0-9]*\)/\1/p' $DAEMON)
    sed -i "s/MODE=$mode/MODE=$ACTION/" $DAEMON
    chmod +x $DAEMON    
    # reset the leds
    set_led_color 255 255 255
    exit 0
else
    echo "Setting led daemon..."
    pkill -f $DAEMON
    mode=$(sed -n 's/^MODE=\([0-9]*\)/\1/p' $DAEMON)
    sed -i "s/MODE=$mode/MODE=$ACTION/" $DAEMON
    chmod +x $DAEMON    
    rm -f $BOOTFILE
cat >$BOOTFILE <<-EOM
    #!/bin/sh

    $DAEMON > /dev/null 2>&1 &
EOM
    chmod +x $BOOTFILE
    $BOOTFILE
    exit 0
fi

