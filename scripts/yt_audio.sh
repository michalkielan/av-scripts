#!/bin/bash

# Script to download audio from YouTube videos in FLAC format using 'yt-dlp'.
# The script requires 'yt-dlp' to be installed on your system.
#
# Usage
#   ./yt_audio.sh
#
# The flac file will be saved in ~/Music directory.

if ! command -v yt-dlp &> /dev/null; then
    echo "Error: yt-dlp is not installed. Please install it first."
    exit 1
fi

if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube-link>"
    exit 1
fi

yt-dlp "$1" -f ba --extract-audio --audio-format flac -o "$HOME/Music/%(title)s.%(ext)s"
