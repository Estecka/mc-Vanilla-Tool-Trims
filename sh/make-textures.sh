#!/bin/bash
set -eu -o pipefail
IFS='';
source sh/makeutil.sh


for sheet in spritesheets/*.png;
do
	pattern=`basename $sheet`;
	pattern=${pattern%.png};

	cat "spritesheets/slices.txt" | while readwords x y w h parent name
	do
		dst=$TRIM_DIR/$name/$pattern.png;
		if [[ $dst -ot $sheet ]]
		then
			echo >&2 $dst;
			mkdir -p `dirname $dst`;
			ffmpeg -v warning -i "$sheet" -vf "crop=x=$x:y=$y:w=$w:h=$h" -update true "$dst" -y;
		fi;
	done;
done;
