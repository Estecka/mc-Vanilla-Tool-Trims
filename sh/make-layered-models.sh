#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''


# Make baked models that include both the tool's original texture and the trim's
# texture. Usable on versions  where `composite` model selectors are unavailable
# or don't work properly.
# NOTE: Obsolete. Only used  in older  versions  of the pack, and won't  work on
# spears as is.
cat config/tools.txt | while readwords tool_item tier tool_type model override_list;
do cat config/patterns.txt | while readwords pattern template;
do cat config/materials.txt | while readwords material material_item;
do
	export tool_item tool_type tier;
	export pattern template;
	export material material_item;

	if [[ "$material" = "$tier" ]]
	then export color="${material}_darker"
	else export color="${material}"
	fi;

	dst="assets/minecraft/models/item/trimmed_${tool_item}/${pattern}_${material}.json"
	if is_obsolete $dst "templates/baked_model/${model}.json"
	then envsubst_mkdir "templates/baked_model/${model}.json" "$dst"
	fi;

	if [[ ! -z $override_list ]]
	then echo "$override_list " | while IFS=$'\t\n\r\v\ ' read -d ' ' override
	do
		export override
		dst="assets/minecraft/models/item/trimmed_${tool_item}${override}/${pattern}_${material}.json"
		if is_obsolete $dst "templates/baked_model/override.json"
		then envsubst_mkdir "templates/baked_model/override.json" "$dst"
		fi;

	done;
	fi
done;
done;
done;
