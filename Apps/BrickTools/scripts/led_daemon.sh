#!/bin/sh

MODE=0
EFFECT=0
DELAY=0
COLOR=0

disable_effects(){
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
}

set_led_color() {
    disable_effects
    r=$1
    g=$2
    b=$3
    valstr=`printf "%02X%02X%02X" $r $g $b`
    echo "$valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr $valstr "\
        "$valstr $valstr $valstr $valstr $valstr $valstr $valstr" > /sys/class/led_anim/frame_hex
}

set_effect() {
    disable_effects
    if [ $EFFECT -eq 0 ]; then
        # set black color = disable
        set_led_color 0 0 0
        return
    fi
    # color=0 = random from the list
    if [ $COLOR -eq 0 ]; then
        NEWCOLOR=$(hexdump -n 1 -e '/1 "%u"' /dev/urandom | awk '{print ($1 % 7) + 1}')
    else    
        NEWCOLOR=$COLOR
    fi
    COLORHEX="000000"
    case $NEWCOLOR in
        1) COLORHEX="FF0000" ;; # Red
        2) COLORHEX="00FF00" ;; # Green
        3) COLORHEX="0000FF" ;; # Blue
        4) COLORHEX="FFFF00" ;; # Yellow
        5) COLORHEX="FF00FF" ;; # Purple
        6) COLORHEX="00FFFF" ;; # Cyan
        7) COLORHEX="FFFFFF" ;; # White
    esac
    DELAYMS=$(((DELAY + 1) * 1000))

    echo 1 > /sys/class/led_anim/effect_enable 
    echo $COLORHEX > /sys/class/led_anim/effect_rgb_hex_lr
    echo $COLORHEX > /sys/class/led_anim/effect_rgb_hex_m
    echo $COLORHEX > /sys/class/led_anim/effect_rgb_hex_f1
    echo $COLORHEX > /sys/class/led_anim/effect_rgb_hex_f2
    echo 1 > /sys/class/led_anim/effect_cycles_lr
    echo 1 > /sys/class/led_anim/effect_cycles_m
    echo 1 > /sys/class/led_anim/effect_cycles_f1
    echo 1 > /sys/class/led_anim/effect_cycles_f2
    echo $DELAYMS > /sys/class/led_anim/effect_duration_lr
    echo $DELAYMS > /sys/class/led_anim/effect_duration_m
    echo $DELAYMS > /sys/class/led_anim/effect_duration_f1
    echo $DELAYMS > /sys/class/led_anim/effect_duration_f2
    echo $EFFECT >  /sys/class/led_anim/effect_lr
    echo $EFFECT >  /sys/class/led_anim/effect_m
    echo $EFFECT >  /sys/class/led_anim/effect_f1
    echo $EFFECT >  /sys/class/led_anim/effect_f2
}

# battery level
if [ $MODE -eq 1 ]; then
    battery_capacity_file="/sys/devices/platform/soc/7081400.s_twi/i2c-6/6-0034/axp2202-bat-power-supply.0/power_supply/axp2202-battery/capacity"
    while true; do
        battery_level=$(cat $battery_capacity_file)
        
        case $battery_level in
            100|9[0-9]) set_led_color 0 255 0 ;; # Green
            8[0-9]|7[0-9]) set_led_color 127 255 0 ;; # Chartreuse Green
            6[0-9]) set_led_color 255 255 0 ;; # Yellow
            5[0-9]) set_led_color 255 165 0 ;; # Orange
            4[0-9]) set_led_color 255 140 0 ;; # Dark Orange
            3[0-9]) set_led_color 255 69 0 ;; # Red Orange
            2[0-9]) set_led_color 255 20 0 ;; # Vermilion
            *) set_led_color 255 0 0 ;; # Red
        esac  
        sleep 60 
    done
fi

# cpu speed
if [ $MODE -eq 2 ]; then
    cpu_speed_file="/sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq"
    while true; do
        cpu_speed=$(cat $cpu_speed_file)
        cpu_speed=$((cpu_speed / 1000))
        if [ $cpu_speed -le 1200 ]; then
            set_led_color 0 255 0  # Green
        elif [ $cpu_speed -le 1300 ]; then
            set_led_color 127 255 0  # Chartreuse Green
        elif [ $cpu_speed -le 1900 ]; then
            set_led_color 255 140 0  # Dark Orange
        elif [ $cpu_speed -le 1991 ]; then
            set_led_color 255 20 0  # Vermilion
        else
            set_led_color 255 0 0  # Red
        fi
        sleep 5
    done
fi

# cpu temperature
if [ $MODE -eq 3 ]; then
    cpu_temp_file="/sys/class/thermal/thermal_zone0/temp"
    while true; do
        cpu_temp=$(cat $cpu_temp_file)
        cpu_temp=$((cpu_temp / 1000)) 
        if [ $cpu_temp -le 40 ]; then
            set_led_color 0 255 0  # Green
        elif [ $cpu_temp -le 45 ]; then
            set_led_color 127 255 0  # Chartreuse Green
        elif [ $cpu_temp -le 50 ]; then
            set_led_color 255 255 0  # Yellow
        elif [ $cpu_temp -le 55 ]; then
            set_led_color 255 165 0  # Orange
        elif [ $cpu_temp -le 60 ]; then
            set_led_color 255 140 0  # Dark Orange
        elif [ $cpu_temp -le 65 ]; then
            set_led_color 255 69 0  # Red Orange
        elif [ $cpu_temp -le 70 ]; then
            set_led_color 255 20 0  # Vermilion
        else
            set_led_color 255 0 0  # Red
        fi
        sleep 5
    done
fi

# effect
if [ $MODE -eq 4 ]; then
    while true; do
        set_effect > /dev/null 2>&1
        sleep $((DELAY + 1))
    done
fi