#!/usr/bin/env nix-shell
#! nix-shell -i bash -p parallel openscad

set -euo pipefail

buildConfig() {
    if [[ "$1" ]]; then
        local stl="$(echo "$1" | cut -d':' -f1)"
        local part="$(echo "$1" | cut -d':' -f2)"

        mkdir -p "$(dirname "$stl")"

        (set -x;
         openscad --hardwarnings \
             -o "$stl" \
             -p "openscad.configs.json" \
             -P "$part" \
             mykeeb_v7a5.scad
        )
    fi
}
export -f buildConfig

cat <<EOF | parallel --progress buildConfig {} 1>&2
stls/mykeeb_v7a5.left.stl:case
stls/mykeeb_v7a5.right.stl:case_right
stls/mykeeb_v7a5.base.left.stl:base
stls/mykeeb_v7a5.base.right.stl:base_right
stls/no-lipo/mykeeb_v7a5.left.stl:case_no-lipo
stls/no-lipo/mykeeb_v7a5.right.stl:case_right_no-lipo
stls/no-lipo/mykeeb_v7a5.base.left.stl:base_no-lipo
stls/no-lipo/mykeeb_v7a5.base.right.stl:base_right_no-lipo
stls/tent/mykeeb_v7a5.left.stl:case_tent
stls/tent/mykeeb_v7a5.right.stl:case_right_tent
EOF

wait
times
