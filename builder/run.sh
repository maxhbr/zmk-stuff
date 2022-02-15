#!/usr/bin/env bash
#
set -euo pipefail

repo="$(pwd)"
context="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

podman build "$context" --tag "maxhbr/zmkbuilder"
podman run --rm -it \
    -v "$repo:/workspace" \
    -v "$(basename "$context")-zmk:/workspace/zmk" \
    -v "$(basename "$context")-zmk-zephyr:/workspace/zephyr" \
    -v "$(basename "$context")-zmk-zephyr-modules:/workspace/modules" \
    -v "$(basename "$context")-zmk-zephyr-tools:/workspace/tools" \
    -v "$(basename "$context")-zmk-zephyr-bootloader:/workspace/bootloader" \
    "maxhbr/zmkbuilder"
