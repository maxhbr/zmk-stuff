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
stls/mykeeb_v7a5.case.left.stl:case
stls/mykeeb_v7a5.case.right.stl:case_right
stls/mykeeb_v7a5.base.left.stl:base
stls/mykeeb_v7a5.base.right.stl:base_right
stls/mykeeb_v7a5.tented_base.left.stl:base_tent
stls/mykeeb_v7a5.tented_base.right.stl:base_right_tent
stls/mykeeb_v7a5.LP502245_base.left.stl:base_big-lipo
stls/mykeeb_v7a5.LP502245_base.right.stl:base_right_big-lipo
stls/mykeeb_v7a5.no-lipo_case.left.stl:case_no-lipo
stls/mykeeb_v7a5.no-lipo_case.right.stl:case_right_no-lipo
stls/mykeeb_v7a5.no-lipo_base.left.stl:base_no-lipo
stls/mykeeb_v7a5.no-lipo_base.right.stl:base_right_no-lipo
EOF

wait
times
