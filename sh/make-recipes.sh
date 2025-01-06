#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''


cat ingredients/tools.txt | while IFS=$'\t\n\r\v\f ' read -r tool_item tier tool_type;
do for f in $TRIM_DIR/${tool_type}/*.png
do if [ -f "$f" ]
then
	export tool_item tool_type tier pattern;
	pattern=`basename $f`;
	pattern=${pattern%.png}

	cat ingredients/materials.txt | while IFS=$'\t\n\r\v\f ' read -r material material_item;
	do
		export material material_item;

		dst="data/minecraft/recipe/trimmed_${tool_item}/${pattern}_${material}.json"
		if is_obsolete $dst "templates/recipe.json"
		then envsubst_mkdir "templates/recipe.json" "$dst"
		fi;
	done;
fi;
done;
done;
