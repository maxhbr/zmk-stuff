#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/pretty"

while read url; do
    fn="$(basename "$url")"
    if [[ -f "$fn" ]]; then
        continue
    fi
    licenseURL="$(echo "$url" | sed 's/main.*/main/' | sed 's/master.*/master/')/LICENSE.md"

    curl "$url" > "$fn"
    curl "$licenseURL" > "$fn.LICENSE"
done <<EOM
https://raw.githubusercontent.com/GEIGEIGEIST/TOTEM/main/PCB/totem_0-3/TOTEMlib.pretty/xiao-ble-smd-cutout.kicad_mod
EOM
