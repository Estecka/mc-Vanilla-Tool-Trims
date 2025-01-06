#!/bin/bash
set -eu -o pipefail
IFS=''
source sh/makeutil.sh
ATLAS="assets/minecraft/atlases/blocks.json"


if is_obsolete $ATLAS "templates/atlas.json" "ingredients/palettes.txt" $TRIM_TEX
then
	envsubst_mkdir "templates/atlas.json" $ATLAS

	cat ingredients/palettes.txt | while IFS=$'\t\n\r\v\f ' read -r color palette;
	do
		jq_append $ATLAS ".sources[0].permutations" '{"'$color'": "'$palette'"}'
	done;

	for f in $TRIM_TEX
	do
		pattern=`basename $f`;
		pattern=${pattern%.png};
		tool=$(basename `dirname $f`)

		jq_append $ATLAS ".sources[0].textures" "[\"trims/items/${tool}/${pattern}\"]";
	done;
fi;
