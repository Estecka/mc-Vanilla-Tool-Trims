#!/bin/bash
set -eu -o pipefail
IFS=''

source ingredients/pack_format.sh
source sh/makeutil.sh

function pack_mcmeta(){
	dst=$1;

	if is_obsolete $dst 'templates/pack.mcmeta' 'ingredients/pack_format.sh'
	then
		envsubst <templates/pack.mcmeta >$dst
	fi;

}

export FORMAT_MAIN=$ASSETS_MAIN;
export FORMAT_MIN=$ASSETS_MIN;
export FORMAT_MAX=$ASSETS_MAX;
pack_mcmeta pack-assets.mcmeta

export FORMAT_MAIN=$DATA_MAIN;
export FORMAT_MIN=$DATA_MIN;
export FORMAT_MAX=$DATA_MAX;
pack_mcmeta pack-data.mcmeta

export FORMAT_MAIN=$(($DATA_MAIN>$ASSETS_MAIN ? $DATA_MAIN : $ASSETS_MAIN));
export FORMAT_MIN=$(($DATA_MIN<$ASSETS_MIN ? $DATA_MIN : $ASSETS_MIN));
export FORMAT_MAX=$(($DATA_MAX>$ASSETS_MAX ? $DATA_MAX : $ASSETS_MAX));
pack_mcmeta pack-all.mcmeta
