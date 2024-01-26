#!/bin/bash

OUT_DIR="rotated"
mkdir -p "${OUT_DIR}"

total=$(find . -type f -name '*MOV' | wc -l)
i=1

while IFS= read -r input_file; do
  echo "${input_file} ${i}/${total}"
  out_file="${OUT_DIR}/${input_file##*/}"
  ffmpeg -i "$input_file" -c:a copy -vf "transpose=1" "$out_file"
  ((i++))
done < <(find . -type f -name '*MOV')
