#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''

# Makes copies of the vanilla models using custom `generated` models in order to
# work around z-fighting. To be used  with `composite` model selectors alongside
# trim-only models,
cat config/tools.txt | while readwords tool_item tier tool_type model override_list;
do cat config/models.txt | while readwords model_tool_type override model_parent tool_texture trim_override;
do if [ $model_tool_type == $tool_type ]
then
	if [ $override == "--" ]
	then override="";
	fi;

	export tool_item override model_parent tool_texture;
	export tool_texture=$(envsubst <<<"$tool_texture");

	dst="assets/estecka/models/copycat/${tool_item}${override}.json"
	if is_obsolete $dst "templates/baked_model/copycat.json" "config/models.txt"
	then envsubst_mkdir "templates/baked_model/copycat.json" "$dst"
	fi;
fi
done
done;
