#!/usr/bin/env bash

# --- Configuration ---
BATTERY_PATH="/sys/class/power_supply/s2mu005-fg" # YOUR BATTERY DEVICE PATH
ALERT_LOG="/home/wraith/log/battery_alerts.log" # Log file for alerts

# Discord Webhook Configuration
DISCORD_WEBHOOK_URL="" # <<< IMPORTANT: PASTE YOUR DISCORD WEBHOOK URL
DISCORD_USERNAME="Headless Server Battery Monitor" # Name displayed in Discord
DISCORD_AVATAR_URL="https://raw.githubusercontent.com/FortAwesome/Font-Awesome/6.x/svgs/solid/battery-quarter.svg" # Optional: A simple battery icon

# Get battery percentage
BATTERY_PERCENTAGE=$(cat "$BATTERY_PATH/capacity" 2>/dev/null)

# Log current status for debugging/tracking
echo "$(date): Current Battery: $BATTERY_PERCENTAGE%" >> /home/wraith/log/battery_check.log 2>&1

MESSAGE=""

# Condition
if (( BATTERY_PERCENTAGE <= 20)); then
    MESSAGE="LOW BATTERY ALERT: Battery is at **${BATTERY_PERCENTAGE}%**! Please connect power soon."
elif (( BATTERY_PERCENTAGE >= 80 )); then
    MESSAGE="BATTERY ALERT: Battery is at **${BATTERY_PERCENTAGE}**! Disconnect the charger."
fi

# Send Discord Notification
if [[ -n "$MESSAGE" ]]; then
    if [[ -n "$DISCORD_WEBHOOK_URL" ]]; then
        JSON_PAYLOAD="{\"content\": \"$MESSAGE\", \"username\": \"$DISCORD_USERNAME\", \"avatar_url\": \"$DISCORD_AVATAR_URL\"}"
        curl -s -H "Content-Type: application/json" -X POST -d "$JSON_PAYLOAD" "$DISCORD_WEBHOOK_URL"
        echo "$(date): Discord notification sent: $MESSAGE" >> "$ALERT_LOG"
    else
        echo "$(date): Error: DISCORD_WEBHOOK_URL is not set. Cannot send notification." >> "$ALERT_LOG"
    fi
fi

