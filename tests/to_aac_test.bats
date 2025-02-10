#!/usr/bin/env bats

TEST_WAV="test.wav"
OUTPUT_FILE="${TEST_WAV%.*}.m4a"
DURATION=1.0

setup() {
    ffmpeg \
        -f lavfi -i "sine=frequency=1000:duration=1" \
        -c:a pcm_s16le \
        -t "$DURATION" \
        -y \
        "$TEST_WAV"
    to_aac "$TEST_WAV"
}

@test "Check if output audio file exists" {
    [ -f "$OUTPUT_FILE" ]
}

@test "Check if duration match the source file" {
    OUTPUT_DURATION=$(ffprobe -v error \
        -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 \
        "$OUTPUT_FILE")
    TOLERANCE=0.1
    DIFFERENCE=$(echo "$OUTPUT_DURATION - $DURATION" | bc -l | awk '{if($1<0) $1=-$1; print $1}')

    [ "$(echo "$DIFFERENCE < $TOLERANCE" | bc -l)" -eq 1 ]
}
