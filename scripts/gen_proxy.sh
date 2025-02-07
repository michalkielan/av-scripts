#!/bin/bash

# This script creates proxy videos for editing. It processes all .MOV files in
# the current directory, scales them to 1080p based on their orientation
# (horizontal or vertical) and encodes the using the ProRes codec.
# 
# Usage
# 
#     ./gen_proxy.sh
# 
#     The converted files will be saved in the 'proxy' directory.
#

AUDIO_CODEC_PCM_S16="pcm_s16le"
OUT_DIR="proxy"
FORMAT="MOV"
AUDIO_CODEC=$AUDIO_CODEC_PCM_S16
VIDEO_CODEC="prores_ks"
VIDEO_OPTIONS="-profile:v 0"
mkdir -p "${OUT_DIR}"

total=$(find . -maxdepth 1 -type f -name "*.${FORMAT}" | wc -l)
i=1

for input_file in *.${FORMAT}
do
  echo "${input_file} ${i}/${total}"
  random_string=$(tr -dc 'a-zA-Z' </dev/urandom | fold -w 8 | head -n 1)
  out_file_tmp="${OUT_DIR}/${input_file}${random_string}.tmp.${FORMAT}"
  out_file="${OUT_DIR}/${input_file}"

  DIMENSIONS=$(ffprobe -v error -show_entries stream=width,height -of csv=p=0 "$input_file")
  WIDTH=$(echo "$DIMENSIONS" | cut -d ',' -f 1)
  HEIGHT=$(echo "$DIMENSIONS" | cut -d ',' -f 2)

  if [ "$WIDTH" -ge "$HEIGHT" ]; then
    SCALE="scale=1920:-2"
  else
    SCALE="scale=-2:1920"
  fi

  if ! ffmpeg \
        -hwaccel auto \
        -i "${input_file}" \
        -c:v ${VIDEO_CODEC} \
        ${VIDEO_OPTIONS} \
        -vf ${SCALE} \
        -c:a ${AUDIO_CODEC} \
        -map_metadata 0 \
        -loglevel info \
        "${out_file_tmp}"; then
    echo "Error: ffmpeg failed"
    exit 1
  fi

  mv "${out_file_tmp}" "${out_file}"
  ((i++))
done
