#!/bin/bash
DAI_URL=$(curl -s "https://www.dailymotion.com/player/metadata/video/x8ockfw" | jq -r '.qualities.auto[0].url')
echo "Playing: $DAI_URL"
ffplay -v error -showmode 0 -autoexit -nodisp -user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" "$DAI_URL"
