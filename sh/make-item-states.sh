#!/bin/bash
set -eu -o pipefail
IFS=''
source sh/makeutil.sh

function make_composite(){
	local tier=$1
	local dst="templates/model_selector/.composite_$tier.json";

	echo -n $dst

	if ! is_obsolete $dst 'templates/model_selector/composite.json'
	then return 0;
	fi;

	cp 'templates/model_selector/composite.json' $dst

	cat ingredients/materials.txt | while readwords material material_item;
	do
		export material material_item;

		if [[ "$material" = "$tier" ]]
		then export color="${material}_darker"
		else export color="${material}"
		fi;

		local case=`envsubst '$color$material' <templates/model_selector/material_case.json | tr -d $'\r'`
		jq_append $dst ".models[1].cases" $case
	done;
}

function list_composites(){
	while read -r line
	do if [[ $line =~ \$\{composite(_[a-z0-9_]+)?\} ]]
	then
		echo ${BASH_REMATCH[1]};
	fi;
	done | sort --unique;
}


cat ingredients/tools.txt | while readwords tool_item tier tool_type model overrides;
do cat ingredients/patterns.txt | while readwords pattern template;
do
	export tool_item tool_type tier pattern;

	composite_template=`make_composite $tier`;
	src="templates/item_state/$model.json"
	dst="assets/minecraft/items/trimmed_$tool_item/$pattern.json"
	if is_obsolete $dst $src $composite_template
	then
		while read -r suffix
		do
			varname=composite$suffix;
			export base_model="$tool_item$suffix";
			export trim_model="$tool_type$suffix";
			export $varname=`envsubst <$composite_template | tr -d $'\r'`
		done < <(list_composites <$src);

		envsubst_mkdir $src $dst
	fi;
done;
done;
