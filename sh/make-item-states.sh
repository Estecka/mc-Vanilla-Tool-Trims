#!/bin/bash
set -eu -o pipefail
IFS=''
source sh/makeutil.sh


cat ingredients/tools.txt | while IFS=$'\t\n\r\v\f ' read -r tool_item tier tool_type;
do for f in $TRIM_DIR/${tool_type}/*.png
do if [ -f "$f" ]
then
	pattern=`basename $f`;
	pattern=${pattern%.png}
	export tool_item tool_type tier pattern;

	dst="assets/minecraft/items/trimmed_${tool_item}/${pattern}.json"
	if is_obsolete $dst "templates/item_state.json" "ingredients/materials.txt"
	then
		update_selector=true;
		envsubst_mkdir "templates/item_state.json" "$dst"
		cat ingredients/materials.txt | while IFS=$'\t\n\r\v\f ' read -r material material_item;
		do
			export material material_item;

			if [[ $update_selector = true ]]
			then
				if [[ "$material" = "$tier" ]]
				then export color="${material}_darker"
				else export color="${material}"
				fi;
				jq_append $dst ".model.models[1].cases" '[{ "when": "'$material'", "model": {"type":"model", "model":"'trims/items/${tool_type}/${pattern}_${color}'"} }]'
			fi;
		done;
	fi;
fi;
done;
done;
