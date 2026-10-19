#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''


cat config/tools.txt | while readwords tool_item tier tool_type model overrides;
do cat config/patterns.txt | while readwords pattern template;
do cat config/materials.txt | while IFS=$'\t\n\r\v\f ' read -r material material_item;
do
	export tool_item pattern template material material_item;

	dst="data/minecraft/recipe/trimmed_${tool_item}/${pattern}_${material}.json"
	if is_obsolete $dst "templates/recipe.json"
	then envsubst_mkdir "templates/recipe.json" "$dst"
	fi;
done;
done;
done;
