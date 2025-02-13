#!/usr/bin/env bats

TEST_VIDEO="test.MP4"
OUTPUT_FILE="${TEST_VIDEO%.*}.MOV"

generate_video() {
	ffmpeg \
		-nostdin \
		-f lavfi -i "smptehdbars=size=176x144:rate=30" \
		-f lavfi -i "sine=frequency=1000:duration=1" \
		-c:v libx264 \
		-c:a aac \
		-t 0.2 \
		-y \
		"$TEST_VIDEO"
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

@test "Check that the audio codec is pcm_s16le" {
	generate_video
	run $ORIGINAL_DIR/scripts/to_pcm "$TEST_WAV"
	[ "$status" -eq 0 ]
	[ -f "$OUTPUT_FILE" ]
	AUDIO_CODEC=$(ffprobe -v error -show_entries stream=codec_name,codec_type -of csv=p=0 "$OUTPUT_FILE" |
		awk -F, '/audio/ {print $1}')
	[ "$AUDIO_CODEC" = "pcm_s16le" ]
}
