#!/usr/bin/env bats

TEST_VIDEO="test.MP4"
OUTPUT_FILE="${TEST_VIDEO%.*}.MOV"

setup() {
    ffmpeg \
        -f lavfi -i "smptehdbars=size=176x144:rate=30" \
        -f lavfi -i "sine=frequency=1000:duration=1" \
        -c:v libx264 \
        -c:a aac \
        -t 0.2 \
        -y \
        "$TEST_VIDEO"
    to_pcm
}

@test "Check if output video exists" {
    [ -f "$OUTPUT_FILE" ]
}

@test "Check that the audio codec is pcm_s16le" {
    AUDIO_CODEC=$(ffprobe -v error -show_entries stream=codec_name,codec_type -of csv=p=0 "$OUTPUT_FILE" |
        awk -F, '/audio/ {print $1}')
    [ "$AUDIO_CODEC" = "pcm_s16le" ]
}
