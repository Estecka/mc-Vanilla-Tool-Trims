#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''


cat spritesheets/slices.txt | while readwords x y w h model_parent tool_type;
do cat ingredients/patterns.txt | while readwords pattern template;
do cat ingredients/palettes.txt | while readwords color palette;
do
	export model_parent tool_type pattern color
	dst="assets/minecraft/models/trims/items/${tool_type}/${pattern}_${color}.json"
	if is_obsolete $dst "templates/baked_model/trim_only.json"
	then envsubst_mkdir "templates/baked_model/trim_only.json" "$dst"
	fi;
done;
done;
done;
