#!/bin/bash

# This script converts video files (.MOV) to H.265/HEVC format. It
# automatically detects the platform (Linux or macOS) and adjusts the FFmpeg
# settings accordingly:
# 
#     Linux: Uses hevc_nvenc for hardware-accelerated encoding.
#     macOS: Uses hevc_videotoolbox for hardware-accelerated encoding.
# 
# If the platform is unsupported, the script will exit with an error.
# Usage
# 
#     ./to_h265.sh
# 
#     The converted files will be saved in the h265 directory.

AUDIO_CODEC_ACC="libfdk_aac"
AUDIO_CODEC_PCM_S16="pcm_s16le"
OUT_DIR="h265"
FORMAT="MOV"
AUDIO_CODEC=$AUDIO_CODEC_ACC
mkdir -p "${OUT_DIR}"

PLATFORM=$(uname -s)
if [[ "$PLATFORM" == "Linux" ]]; then
  VIDEO_CODEC="hevc_nvenc"
  VIDEO_OPTIONS="-preset slow -qp 18"
elif [[ "$PLATFORM" == "Darwin" ]]; then
  VIDEO_CODEC="hevc_videotoolbox"
  VIDEO_OPTIONS="-tag:v hvc1 -q:v 65"
else
  echo "Error: Unsupported platform - $PLATFORM"
  exit 1
fi

total=$(find . -maxdepth 1 -type f -name "*.${FORMAT}" | wc -l)
i=1

for input_file in *.${FORMAT}
do
  echo "${input_file} ${i}/${total}"
  random_string=$(tr -dc 'a-zA-Z' </dev/urandom | fold -w 8 | head -n 1)
  out_file_tmp="${OUT_DIR}/${input_file}${random_string}.tmp.${FORMAT}"
  out_file="${OUT_DIR}/${input_file}"

  if ! ffmpeg \
        -hwaccel auto \
        -i "${input_file}" \
        -c:v ${VIDEO_CODEC} \
        ${VIDEO_OPTIONS} \
        -c:a ${AUDIO_CODEC} \
        -b:a 320k \
        -map_metadata 0 \
        -loglevel info \
        "${out_file_tmp}"; then
    echo "Error: ffmpeg failed"
    exit 1
  fi

  mv "${out_file_tmp}" "${out_file}"
  ((i++))
done
