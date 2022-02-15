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

   west build \
       -s zmk/app \
       -b "$board" \
       -- \
           -DZMK_CONFIG="$(pwd)/config" \
           -DSHIELD="${shield}" \
            ${CMAKE_ARGS}
   mkdir -p build/artifacts
   if [ -f build/zephyr/zmk.uf2 ]; then
       cp build/zephyr/zmk.uf2 "build/artifacts/${ARTIFACT_NAME}.uf2"
   elif [ -f build/zephyr/zmk.hex ]; then
       cp build/zephyr/zmk.hex "build/artifacts/${ARTIFACT_NAME}.hex"
   fi
done
