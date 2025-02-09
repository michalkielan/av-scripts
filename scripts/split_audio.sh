#!/bin/bash

# Separate vocal from audio using 'demucs'
# The script requires 'demucs' to be installed on your system.
#
# Usage
#   ./split_audio.sh
#
# The vocal and non-vocal files will be saved in working directory.

if [ -z "$1" ]; then
    echo "Usage: $0 <audio file>"
    exit 1
fi

conda run -n demucs --live-stream demucs --two-stems=vocals "$1"
