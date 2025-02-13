#!/usr/bin/env bats

generate_video() {
	local output_file="$1"
	ffmpeg \
		-nostdin \
		-f lavfi -i "testsrc=duration=0.2:size=176x144:rate=30" \
		-c:v libx264 \
		"$output_file"
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

@test "Test with no files in directory" {
	run gen_mediainfo
	[ "$status" -eq 0 ]
}

@test "Test with .mp4 file" {
	generate_video "test.mp4"
	run gen_mediainfo
	[ -f "test.yaml" ]
	[ "$status" -eq 0 ]
}

@test "Test with .MP4 file" {
	generate_video "test.MP4"
	run gen_mediainfo
	[ -f "test.YAML" ]
	[ "$status" -eq 0 ]
}

@test "Test with .mov file" {
	generate_video "test.mov"
	run gen_mediainfo
	[ -f "test.yaml" ]
	[ "$status" -eq 0 ]
}

@test "Test with .MOV file" {
	generate_video "test.MOV"
	run gen_mediainfo
	[ -f "test.YAML" ]
	[ "$status" -eq 0 ]
}

@test "Test with .mkv file" {
	generate_video "test.mkv"
	run gen_mediainfo
	[ -f "test.yaml" ]
	[ "$status" -eq 0 ]
}

@test "Test with .MKV file" {
	generate_video "test.MKV"
	run gen_mediainfo
	[ -f "test.YAML" ]
	[ "$status" -eq 0 ]
}
