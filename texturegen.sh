#!/bin/bash
set -eu -o pipefail
IFS=""
TEXDIR="assets/minecraft/textures/trims/items"

for sheet in spritesheets/*.png;
do
	pattern=`basename $sheet`
	pattern=${pattern%.png}

	cat "spritesheets/slices.txt" | while IFS=$'\t\n\r\v\f ' read name x y w h
	do
		dst=$TEXDIR/$name/$pattern.png
		if [[ $dst -ot $sheet ]]
		then
			echo >&2 $dst;
			mkdir -p `dirname $dst`;
			ffmpeg -v warning -i "$sheet" -vf "crop=x=$x:y=$y:w=$w:h=$h" -update true "$dst" -y
		fi;
	done;
done;
