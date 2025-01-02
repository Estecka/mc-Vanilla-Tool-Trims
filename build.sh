#!/bin/bash
set -eu -o pipefail

echo >&2 -e "\n\t# Texture generation"
./texturegen.sh

echo >&2 -e "\n\t# Data generation"
./datagen.sh

echo >&2 -e "\n\t# Minifying"
./minify.sh

echo >&2 -e "\n\t# Packing"
./pack.sh
