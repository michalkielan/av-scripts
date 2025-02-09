#!/bin/bash

is_encoder_supported() {
    ffmpeg -encoders 2>/dev/null | grep -q " $1 "
}

