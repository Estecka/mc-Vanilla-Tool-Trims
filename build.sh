#!/bin/bash
set -eu -o pipefail

TEXTURE_PACK="STK-ToolTrim-assets.zip";
DATA_PACK="STK-ToolTrim-data.zip";
TEXTUREPACK_DIR=""
DATAPACK_DIR=""

echo >&2 -e "\n\t# Texture generation"
sh/make-textures.sh

echo >&2 -e "\n\t# Assets generation"
sh/make-atlas.sh
sh/make-copycat-models.sh
sh/make-trim-models.sh
sh/make-item-states.sh

echo >&2 -e "\n\t# Data generation"
sh/make-tag.sh

if [ $# -ge 1 ] && [ $1 == "--minify" ]
then
	echo >&2 -e "\n\t# Minifying"
	sh/minify.sh >/dev/null
fi;

echo >&2 -e "\n\t# Packing"
sh/pack.sh

if [ ! -z "$TEXTUREPACK_DIR" ] && [ ! -z "$DATAPACK_DIR" ]
then
	echo >&2 -e "\n\t# Deploying"
	cp -v "$TEXTURE_PACK" "$TEXTUREPACK_DIR/$TEXTURE_PACK"
	cp -v "$DATA_PACK"    "$DATAPACK_DIR/$DATA_PACK"
fi;
