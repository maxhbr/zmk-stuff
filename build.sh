#!/usr/bin/env bash
#
set -euo pipefail

repo="$(pwd)"
context="$( cd -- "$( dirname -- "$(readlink -f "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"

podman build "$context" --tag "maxhbr/zmkbuilder"
set -x
podman run --rm -it \
    -v "$repo:/workspace" \
    -v "$(basename "$repo")-zmk:/workspace/zmk" \
    -v "$(basename "$repo")-zmk-zephyr:/workspace/zephyr" \
    -v "$(basename "$repo")-zmk-zephyr-modules:/workspace/modules" \
    -v "$(basename "$repo")-zmk-zephyr-tools:/workspace/tools" \
    -v "$(basename "$repo")-zmk-zephyr-bootloader:/workspace/bootloader" \
    "maxhbr/zmkbuilder"
