#!/bin/bash
set -eu -o pipefail

echo >&2 -e "\n\t# Texture generation"
sh/make-textures.sh

echo >&2 -e "\n\t# Assets generation"
sh/make-atlas.sh
sh/make-trim-models.sh
sh/make-item-states.sh

echo >&2 -e "\n\t# Data generation"
sh/make-tag.sh

echo >&2 -e "\n\t# Minifying"
sh/minify.sh >/dev/null

echo >&2 -e "\n\t# Packing"
sh/pack.sh
