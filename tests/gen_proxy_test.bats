#!/usr/bin/env bats

gen_test_video() {
  ffmpeg \
    -f lavfi -i "$1"\
    -f lavfi -i "sine=frequency=1000:duration=1" \
    -c:v prores \
    -c:a pcm_s16le \
    -t 1 \
    -y \
    "$2"
}

setup() {
  gen_test_video "smptehdbars=size=3840x2160:rate=30" "test_h.MOV"
  gen_test_video "smptehdbars=size=2160x3840:rate=30" "test_v.MOV"
}

@test "Check if proxy videos exists" {
  gen_proxy
  [ -d "proxy" ]
  [ -f "proxy/test_h.MOV" ]
  [ -f "proxy/test_v.MOV" ]
}
