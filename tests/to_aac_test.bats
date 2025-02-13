#!/usr/bin/env bats

TEST_WAV="test.wav"
OUTPUT_FILE="${TEST_WAV%.*}.m4a"
DURATION=1.0

generate_audio() {
	ffmpeg \
		-nostdin \
		-f lavfi -i "sine=frequency=1000:duration=1" \
		-c:a pcm_s16le \
		-t "$DURATION" \
		"$TEST_WAV"
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

@test "Check if duration match the source file" {
	generate_audio
	run $ORIGINAL_DIR/scripts/to_aac "$TEST_WAV"
	[ "$status" -eq 0 ]
	[ -f "$OUTPUT_FILE" ]
	OUTPUT_DURATION=$(ffprobe -v error \
		-show_entries format=duration \
		-of default=noprint_wrappers=1:nokey=1 \
		"$OUTPUT_FILE")
	TOLERANCE=0.1
	DIFFERENCE=$(echo "$OUTPUT_DURATION - $DURATION" | bc -l | awk '{if($1<0) $1=-$1; print $1}')
	[ "$(echo "$DIFFERENCE < $TOLERANCE" | bc -l)" -eq 1 ]
}
