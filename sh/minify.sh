#!/bin/bash
set -eu -o pipefail
shopt -s globstar
IFS=''

tmp=$(mktemp)
for f in assets/**/*.json data/**/*.json
do
	echo >&1 -ne " $f\e[K\r"
	jq -c <$f >$tmp
	mv $tmp $f;
done;
