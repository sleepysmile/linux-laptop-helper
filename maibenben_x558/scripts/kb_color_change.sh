#!/bin/bash
STATEFILE="$HOME/.kbd_color_state"
CURRENT=$(cat "$STATEFILE" 2>/dev/null || echo "0")

case "$CURRENT" in
    0) echo "255 255 255" | sudo tee /sys/class/leds/rgb:kbd_backlight/multi_intensity > /dev/null
       echo 1 > "$STATEFILE" ;;
    1) echo "0 0 255" | sudo tee /sys/class/leds/rgb:kbd_backlight/multi_intensity > /dev/null
       echo 2 > "$STATEFILE" ;;
    2) echo "255 0 0" | sudo tee /sys/class/leds/rgb:kbd_backlight/multi_intensity > /dev/null
       echo 0 > "$STATEFILE" ;;
esac
