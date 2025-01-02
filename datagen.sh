#!/bin/bash
set -eu -o pipefail
IFS=''
ATLAS="assets/minecraft/atlases/blocks.json"
TRIM_DIR=assets/minecraft/textures/trims/items
TRIM_TEX=$TRIM_DIR/*/*.png

function jq_append(){
	local dst=$1
	local path=$2
	local addendum=$3

	local tmp=$(mktemp);
	jq <"$dst" >"$tmp" --tab "$path += $addendum";
	mv "$tmp" "$dst";
}

function is_obsolete(){
	local dst=$1
	shift 1;
	local dependencies=$@

	IFS=' '
	for dep in $dependencies
	do if ! [[ $dst -nt $dep ]]
	then
		return 0;
	fi;
	done;

	return 1;
}

function envsubst_mkdir(){
	local src=$1
	local dst=$2

	echo >&2 $dst;
	mkdir -p `dirname $dst`
	envsubst <$src >$dst
}


# echo >&2 "$ATLAS"
if is_obsolete $ATLAS "templates/atlas.json" $TRIM_TEX
then
	envsubst_mkdir "templates/atlas.json" $ATLAS $TRIM_TEX
	for f in assets/minecraft/textures/trims/items/**/*.png
	do
		pattern=`basename $f`;
		pattern=${pattern%.png};
		tool=`dirname $f`;
		tool=${tool#assets/minecraft/textures/trims/items/};

		jq_append "$ATLAS" ".sources[0].textures" "[\"trims/items/${tool}/${pattern}\"]";
	done;
fi;


echo >&2 "Trim models:"
for f in $TRIM_TEX
do cat ingredients/palettes.txt | while IFS=$'\t\n\r\v\f ' read -r color;
do if [ -f "$f" ]
then
	pattern=`basename $f`
	pattern=${pattern%.png}
	tool_type=$(basename `dirname $f`)

	# echo >&2 "$tool_type $pattern $color"
	export tool_type pattern color
	dst="assets/minecraft/models/trims/items/${tool_type}/${pattern}_${color}.json"
	if is_obsolete $dst "templates/model_trim.json"
	then envsubst_mkdir "templates/model_trim.json" "$dst"
	fi;
fi;
done;
done;

echo >&2 "Item states & recipes:"
cat ingredients/tools.txt | while IFS=$'\t\n\r\v\f ' read -r tool_type tier tool_item;
do for f in $TRIM_DIR/${tool_type}/*.png
do if [ -f "$f" ]
then
	pattern=`basename $f`;
	pattern=${pattern%.png}
	export tool_item tool_type tier pattern;

	update_selector=false;
	model_selector="assets/minecraft/items/trimmed_${tool_item}/${pattern}.json"
	if is_obsolete $model_selector "templates/item_state.json" "ingredients/materials.txt"
	then
		update_selector=true;
		envsubst_mkdir "templates/item_state.json" "$model_selector"
	fi;

	cat ingredients/materials.txt | while IFS=$'\t\n\r\v\f ' read -r material material_item;
	do
		export material material_item;

		if [[ $update_selector = true ]]
		then
			if [[ "$material" = "$tier" ]]
			then export color="${material}_darker"
			else export color="${material}"
			fi;
			jq_append $model_selector ".model.models[1].cases" '[{ "when": "'$material'", "model": {"type":"model", "model":"'trims/items/${tool_type}/${pattern}_${color}'"} }]'
		fi;

		dst="data/minecraft/recipe/trimmed_${tool_item}/${pattern}_${material}.json"
		if is_obsolete $dst "templates/recipe.json"
		then envsubst_mkdir "templates/recipe.json" "$dst"
		fi;
	done;
fi;
done;
done;
