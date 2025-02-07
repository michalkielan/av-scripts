#!/bin/bash

AUDIO_CODEC_PCM_S16="pcm_s16le"
OUT_DIR="."
INPUT_FORMAT="MP4"
OUTPUT_FORMAT="MOV"
AUDIO_CODEC=$AUDIO_CODEC_PCM_S16
mkdir -p "${OUT_DIR}"

total=$(find . -maxdepth 1 -type f -name '*${INPUT_FORMAT}' | wc -l)
i=1

for input_file in *.${INPUT_FORMAT}
do
  echo "${input_file} ${i}/${total}"
  random_string=$(tr -dc 'a-zA-Z' </dev/urandom | fold -w 8 | head -n 1)
  out_file_tmp="${OUT_DIR}/${input_file}${random_string}.tmp.${OUTPUT_FORMAT}"
  out_file="${OUT_DIR}/${input_file}"
  if ! ffmpeg \
        -i "${input_file}" \
        -c:v copy \
        -c:a ${AUDIO_CODEC} \
        -movflags faststart \
        -threads 0 \
        "${out_file_tmp}"; then
    echo "Error: ffmpeg failed"
    exit 1
  fi

  mv "${out_file_tmp}" "${out_file%.$INPUT_FORMAT}.$OUTPUT_FORMAT"
  ((i++))
done
