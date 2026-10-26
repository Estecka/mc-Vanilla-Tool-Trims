#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''

# Makes copies of the vanilla models using custom `generated` models in order to
# work around z-fighting. To be used  with `composite` model selectors alongside
# trim-only models,
cat config/tools.txt | while readwords tool_item tier tool_type model override_list;
do cat config/models.txt | while readwords archetype override model_parent texture_suffix;
do if [ $archetype == $tool_type ]
then
	if [ $override == "--" ]
	then override="";
	fi;

	if [ -z $texture_suffix ]
	then texture_suffix=$override
	fi;

	export tool_item override model_parent texture_suffix;

	dst="assets/estecka/models/copycat/${tool_item}${override}.json"
	if is_obsolete $dst "templates/baked_model/copycat.json" "config/models.txt"
	then envsubst_mkdir "templates/baked_model/copycat.json" "$dst"
	fi;
fi
done
done;
