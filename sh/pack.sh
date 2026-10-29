#!/bin/bash
set -eu -o pipefail
IFS=''

allpack="STK-ToolTrim.zip";
texturepack="STK-ToolTrim-assets.zip";
datapack="STK-ToolTrim-data.zip";
TEXTUREPACK_DIR=""
DATAPACK_DIR=""

sh/make-pack-mcmeta.sh
rm -f $allpack $texturepack $datapack;

echo >&2 "Packing assets..."
cp pack-assets.mcmeta pack.mcmeta
zip "$texturepack" -r -9 >/dev/null \
	assets/ \
	overlay_*/assets \
	LICENSE \
	pack.mcmeta \
	pack.png \
	;

echo >&2 "Packing data..."
cp pack-data.mcmeta pack.mcmeta
zip "$datapack" -r -9 >/dev/null \
	data/ \
	LICENSE \
	pack.mcmeta \
	pack.png \
	;

# echo >&2 "Packing all-in-one..."
# cp pack-all.mcmeta pack.mcmeta
# zip "$allpack" -r -9 >/dev/null \
# 	assets/ \
# 	overlay_*/assets \
# 	data/ \
# 	LICENSE \
# 	pack-assets.mcmeta \
# 	pack-data.mcmeta \
# 	pack.mcmeta \
# 	pack.png \
# 	;

if [ ! -z "$TEXTUREPACK_DIR" ] || [ ! -z "$DATAPACK_DIR" ]
then
	echo >&2 -e "\n\t# Deploying"
	[ ! -z "$TEXTUREPACK_DIR" ] && cp -v "$texturepack" "$TEXTUREPACK_DIR/$texturepack"
	[ ! -z "$DATAPACK_DIR"    ] && cp -v "$datapack"    "$DATAPACK_DIR/$datapack"
fi;
