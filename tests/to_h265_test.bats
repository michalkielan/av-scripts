#!/usr/bin/env bats

generate_video() {
	ffmpeg \
		-nostdin \
		-f lavfi -i "smptehdbars=size=176x144:rate=30" \
		-f lavfi -i "sine=frequency=1000:duration=1" \
		-c:v prores \
		-c:a pcm_s16le \
		-t 0.2 \
		-y \
		"test.MOV"
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

@test "Check if videos under 'h265' exists" {
	generate_video
	run $ORIGINAL_DIR/scripts/to_h265
	[ "$status" -eq 0 ]
	[ -f "h265/test.MKV" ]
}
