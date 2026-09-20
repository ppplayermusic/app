#!/bin/bash
VIM_MP4=$(curl -s "https://player.vimeo.com/video/76979871/config" | jq -r '.request.files.progressive[0].url')
echo "Playing: $VIM_MP4"
ffplay -v error -showmode 0 -autoexit -nodisp -user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" "$VIM_MP4"
