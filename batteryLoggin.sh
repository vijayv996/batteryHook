#!/usr/bin/env bash

BATTERY_PATH="/sys/class/power_supply/s2mu005-fg"

BATTERY_PERCENTAGE=$(cat "$BATTERY_PATH/capacity" 2>/dev/null)

# Log current status for debugging/tracking
echo "$(date): Current Battery: $BATTERY_PERCENTAGE%" >> /home/wraith/log/battery_log.log 2>&1