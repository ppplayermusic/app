#!/bin/bash
DM_URL=$(curl -s "https://www.dailymotion.com/player/metadata/video/xb9u9r6" | jq -r '.qualities.auto[0].url')
echo "Playing: $DM_URL"
ffplay -v error -showmode 0 -autoexit -nodisp -user_agent "Mozilla/5.0" -headers "Referer: https://www.dailymotion.com/" "$DM_URL"
