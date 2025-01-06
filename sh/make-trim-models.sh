#!/bin/bash
set -eu -o pipefail
source sh/makeutil.sh
IFS=''


for f in $TRIM_TEX
do cat ingredients/palettes.txt | while IFS=$'\t\n\r\v\f ' read -r color palette;
do
	pattern=`basename $f`
	pattern=${pattern%.png}
	tool_type=$(basename `dirname $f`)

	export tool_type pattern color
	dst="assets/minecraft/models/trims/items/${tool_type}/${pattern}_${color}.json"
	if is_obsolete $dst "templates/model_trim.json"
	then envsubst_mkdir "templates/model_trim.json" "$dst"
	fi;
done;
done;
