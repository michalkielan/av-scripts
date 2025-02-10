#!/usr/bin/env bats

TEST_H="test_h.MOV"
TEST_V="test_v.MOV"

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
  gen_test_video "smptehdbars=size=3840x2160:rate=30" "$TEST_H"
  gen_test_video "smptehdbars=size=2160x3840:rate=30" "$TEST_V"
  gen_proxy
}

@test "Check if proxy videos exists" {
  [ -d "proxy" ]
  [ -f "proxy/$TEST_H" ]
  [ -f "proxy/$TEST_V" ]
}

@test "Check horizontal video resolution" {
  resolution=$(ffprobe -v error -show_entries stream=width,height -of csv=p=0 "proxy/$TEST_H")
  IFS=',' read -r width height <<< "$resolution"

  [ 1920 -eq "$width" ]
  [ 1080 -eq "$height" ]
}

@test "Check vertical video resolution" {
  resolution=$(ffprobe -v error -show_entries stream=width,height -of csv=p=0 "proxy/$TEST_V")
  IFS=',' read -r width height <<< "$resolution"

  [ 1080 -eq "$width" ]
  [ 1920 -eq "$height" ]
}
