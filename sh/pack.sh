#!/bin/bash
set -eu -o pipefail
IFS=''

allpack="STK-ToolTrim.zip";
texturepack="STK-ToolTrim-assets.zip";
datapack="STK-ToolTrim-data.zip";

sh/make-pack-mcmeta.sh
rm -f $allpack $texturepack $datapack;

echo >&2 "Packing assets..."
cp pack-assets.mcmeta pack.mcmeta
zip "$texturepack" -r -9 >/dev/null \
	assets/ \
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

echo >&2 "Packing all-in-one..."
cp pack-all.mcmeta pack.mcmeta
zip "$allpack" -r -9 >/dev/null \
	assets/ \
	data/ \
	LICENSE \
	pack-assets.mcmeta \
	pack-data.mcmeta \
	pack.mcmeta \
	pack.png \
	;
