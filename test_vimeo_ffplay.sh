#!/bin/bash
VIM_URL=$(curl -s "https://player.vimeo.com/video/76979871/config" | jq -r '.request.files.hls.cdns | .[keys[0]].url')
echo "Playing: $VIM_URL"
ffplay -v error -showmode 0 -autoexit -nodisp -user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" "$VIM_URL"
