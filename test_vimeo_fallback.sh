#!/bin/bash
VIM_FALLBACK=$(curl -s "https://player.vimeo.com/video/76979871/config" | jq -r '.request.files.hls.cdns.akfire_interconnect_quic.fallback_url')
echo "Playing: $VIM_FALLBACK"
ffplay -v error -showmode 0 -autoexit -nodisp -user_agent "Mozilla/5.0" "$VIM_FALLBACK"
