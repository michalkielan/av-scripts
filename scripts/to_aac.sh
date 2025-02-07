#!/bin/bash

# This script converts WAV files to AAC format using the best available AAC
# encoder. It checks for supported encoders in the following order:
# 
#     libfdk_aac (highest quality)
#     aac_at (macOS only)
#     aac (default FFmpeg AAC encoder)
# 
# If no supported encoder is found, the script will exit with an error.
#
# Usage:
# 
#     Run the script with a WAV file as an argument:
#     ./to_aac.sh input_file.wav
# 
#     The output file will be saved as <input_file>.m4a.

AAC_CODECS=("libfdk_aac" "aac_at" "aac")

is_encoder_supported() {
    ffmpeg -encoders 2>/dev/null | grep -q " $1 "
}

SELECTED_CODEC=""
for codec in "${AAC_CODECS[@]}"; do
    if is_encoder_supported "$codec"; then
        SELECTED_CODEC="$codec"
        break
    fi
done

if [ -z "$SELECTED_CODEC" ]; then
    echo "Error: No supported AAC encoder found. Available options: ${AAC_CODECS[*]}"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: to_aac <input_file.wav>"
    exit 1
fi

INPUT_FILE="$1"
BASE_NAME="${INPUT_FILE%.*}"

echo "Using encoder: $SELECTED_CODEC"
ffmpeg -i "$INPUT_FILE" -c:a "$SELECTED_CODEC" -b:a 320k -map a:0 "$BASE_NAME.m4a"
