#!/bin/bash
set -eu -o pipefail
IFS=""

src=$1
dst=$2
lut=$3

ffmpeg -v warning -i "$src" -vf "lut1d=file='${lut}':interp=nearest" -update true "$dst" -y
