#!/bin/bash
set -eu -o pipefail
IFS=''
source sh/makeutil.sh


cat ingredients/tools.txt | while IFS=$'\t\n\r\v\f ' read -r tool_item tier tool_type;
do
	export tool_item;

	dst="assets/estecka/variants-cit/item/trimmed_${tool_item}.json"
	if is_obsolete $dst "templates/variants-cit.json" "ingredients/tools.txt"
	then
		envsubst_mkdir "templates/variants-cit.json" $dst
	fi;
done;
