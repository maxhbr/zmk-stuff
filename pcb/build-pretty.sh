#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/pretty"

while read url; do
    if ! curl --output /dev/null --silent --head --fail "$url"; then
        echo "failed to reach: $url"
        continue
    fi
    fn="$(basename "$url")"
    if [[ -f "$fn" ]]; then
        continue
    fi
    curl "$url" > "$fn"

    licenseURL="$(echo "$url" | sed 's/main.*/main/' | sed 's/master.*/master/')/LICENSE.md"
    if curl --output /dev/null --silent --head --fail "$licenseURL"; then
        curl "$licenseURL" > "$fn.LICENSE.md"
    fi
done <<EOM
https://raw.githubusercontent.com/GEIGEIGEIST/TOTEM/main/PCB/totem_0-3/TOTEMlib.pretty/xiao-ble-smd-cutout.kicad_mod
EOM
