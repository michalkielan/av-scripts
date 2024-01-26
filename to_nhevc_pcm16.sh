#!/bin/bash

OUT_DIR="h265"
FORMAT="MOV"
# AUDIO_CODEC="pcm_s16le"
AUDIO_CODEC="aac"
mkdir -p "${OUT_DIR}"

total=$(find . -maxdepth 1 -type f -name '*${FORMAT}' | wc -l)
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
        -c:v hevc_nvenc \
        -preset slow \
        -qp 18 \
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
