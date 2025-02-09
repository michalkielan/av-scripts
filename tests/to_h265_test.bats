#!/usr/bin/env bats

setup() {
  ffmpeg \
    -f lavfi -i "smptehdbars=size=176x144:rate=30" \
    -f lavfi -i "sine=frequency=1000:duration=1" \
    -c:v prores \
    -c:a pcm_s16le \
    -t 0.2 \
    -y \
    "test.MOV"
}

@test "Check if videos under 'h265' exists" {
  to_h265
  [ -d "h265" ]
  [ -f "h265/test.MOV" ]
}
