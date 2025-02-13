#!/bin/bash

is_encoder_supported() {
	ffmpeg -encoders 2>/dev/null | grep -q " $1 "
}

gen_random_string() {
    echo $(mktemp -u XXXXXXXXX | tr -d '/')
}
