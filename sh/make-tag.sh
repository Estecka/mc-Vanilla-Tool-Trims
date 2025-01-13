#!/bin/bash
set -eu -o pipefail
IFS=''
source sh/makeutil.sh
TAG="data/minecraft/tags/item/trimmable_armor.json"


if is_obsolete $TAG "templates/tag.json" "ingredients/tools.txt"
then
	envsubst_mkdir "templates/tag.json" $TAG $TRIM_TEX
	cat ingredients/tools.txt | while readwords tool_item tier tool_type model override_list;
	do
		jq_append $TAG ".values" "[\"${tool_item}\"]";
	done;
fi;
