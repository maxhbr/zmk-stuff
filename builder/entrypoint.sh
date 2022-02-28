#!/usr/bin/env bash

set -euo pipefail
set -x

west init -l config || true
west update
west zephyr-export

for row in $(cat build.yaml |
        python3 -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read())))' |
        jq -r ".include[] | @base64"); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
   board="$(_jq '.board')"
   shield="$(_jq '.shield')"
   CMAKE_ARGS="$(_jq '.cmake-args' || true)"
   ARTIFACT_NAME="${shield}-${board}-zmk"
   BUILD_DIR="build-${ARTIFACT_NAME}"

   west build \
       -s zmk/app \
       -b "$board" \
       -d "${BUILD_DIR}" \
       -- \
           -DZMK_CONFIG="$(pwd)/config" \
           -DSHIELD="${shield}" \
            ${CMAKE_ARGS}
   mkdir -p artifacts
   if [ -f "${BUILD_DIR}/zephyr/zmk.uf2" ]; then
       cp "${BUILD_DIR}/zephyr/zmk.uf2" "artifacts/${ARTIFACT_NAME}.uf2"
   elif [ -f "${BUILD_DIR}/zephyr/zmk.hex" ]; then
       cp "${BUILD_DIR}/zephyr/zmk.hex" "artifacts/${ARTIFACT_NAME}.hex"
   fi
done
