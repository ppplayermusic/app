#!/bin/bash
cd "$(dirname "$0")"
ffmpeg -y -f lavfi -i sine=frequency=440:duration=0.5 -c:a pcm_s16le test.wav
ffmpeg -y -i test.wav -c:a libmp3lame test.mp3
ffmpeg -y -i test.wav -c:a flac test.flac
ffmpeg -y -i test.wav -c:a aac test.m4a
ffmpeg -y -i test.wav -ac 2 -c:a vorbis -strict -2 test.ogg
ffmpeg -y -i test.wav -c:a libopus test.opus
ffmpeg -y -i test.wav -c:a wmav2 test.wma
ffmpeg -y -i test.wav -c:a wavpack test.wv
ffmpeg -y -i test.wav -c:a tta test.tta
