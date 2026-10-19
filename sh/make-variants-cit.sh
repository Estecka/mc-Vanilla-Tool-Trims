#!/bin/bash
set -eu -o pipefail
IFS=''
source sh/makeutil.sh


cat config/tools.txt | while readwords tool_item tier tool_type model overrides;
do
	export tool_item;

	dst="assets/estecka/variants-cit/item/trimmed_${tool_item}.json"
	if is_obsolete $dst "templates/variants-cit.json" "config/tools.txt"
	then
		envsubst_mkdir "templates/variants-cit.json" $dst
	fi;
done;
