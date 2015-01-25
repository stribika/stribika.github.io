#!/bin/sh

set -o errexit
set -o pipefail

for x in "./${1}"*.dia; do
    name="$(echo "$x" | sed -r 's/\.dia$//')"
    dia --export="${name}.step1.png" "$x"
    convert "${name}.step1.png" -extent 914x362 -background white "${name}.step2.png"
done

convert -delay 200 -loop 0 ./*.step2.png "${1}.gif"

#rm ./*.step*.png
