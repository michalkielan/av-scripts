#!/usr/bin/env bats

TEST_H="test_h.MOV"
TEST_V="test_v.MOV"

generate_video() {
	ffmpeg \
		-nostdin \
		-f lavfi -i "$1" \
		-f lavfi -i "sine=frequency=1000:duration=1" \
		-c:v prores \
		-c:a pcm_s16le \
		-t 1 \
		-y \
		"$2"
}

setup() {
	export ORIGINAL_DIR=$(pwd)
	export TEMP_DIR=$(mktemp -d)
	cd "$TEMP_DIR" || {
		echo "Failed to change to temporary directory"
		exit 1
	}
}

teardown() {
	cd "$ORIGINAL_DIR" || {
		echo "Failed to change back to original directory"
		exit 1
	}
	rm -rf "$TEMP_DIR"
}

@test "Check horizontal video resolution" {
	generate_video "smptehdbars=size=3840x2160:rate=30" "$TEST_H"
	run $ORIGINAL_DIR/scripts/gen_proxy
	[ "$status" -eq 0 ]
	[ -f "proxy/$TEST_H" ]
	resolution=$(ffprobe -v error -show_entries stream=width,height -of csv=p=0 "proxy/$TEST_H")
	IFS=',' read -r width height <<<"$resolution"

	[ 1920 -eq "$width" ]
	[ 1080 -eq "$height" ]
}

@test "Check vertical video resolution" {
	generate_video "smptehdbars=size=2160x3840:rate=30" "$TEST_V"
	run $ORIGINAL_DIR/scripts/gen_proxy
	[ "$status" -eq 0 ]
	[ -f "proxy/$TEST_V" ]
	resolution=$(ffprobe -v error -show_entries stream=width,height -of csv=p=0 "proxy/$TEST_V")
	IFS=',' read -r width height <<<"$resolution"

	[ 1080 -eq "$width" ]
	[ 1920 -eq "$height" ]
}
