#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''


# Make baked models that include only the trims. Those can be combined with the
# tool's orignal baked model using `composite` model selectors.
cat config/models.txt | while readwords tool_type substate model_parent tool_texture trim_override;
do cat config/patterns.txt | while readwords pattern template;
do cat config/palettes.txt | while readwords color palette;
do
	if [ "$substate" == "--" ]
	then substate="";
	fi;

	dst="assets/minecraft/models/trims/items/${tool_type}${substate}/${pattern}_${color}.json"

	export pattern color tool_type model_parent
	export override=$substate;
	export override=$(envsubst <<<"$trim_override");
	if is_obsolete $dst "templates/baked_model/trim_only.json" "config/models.txt"
	then envsubst_mkdir "templates/baked_model/trim_only.json" "$dst"
	fi;
done;
done;
done;
