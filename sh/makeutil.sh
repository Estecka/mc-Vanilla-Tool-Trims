TRIM_DIR=assets/minecraft/textures/trims/items
TRIM_TEX=$TRIM_DIR/*/*.png

function jq_append(){
	local dst="$1";
	local path="$2";
	local addendum="$3";
	shift 3;

	local tmp="$(mktemp)";
	jq <"$dst" >"$tmp" --tab $@ "$path += $addendum";
	mv "$tmp" "$dst";
}

function is_obsolete(){
	local target="$1"
	shift 1;
	local dependencies=$@

	local IFS=' '
	for dep in $dependencies
	do if ! [[ $target -nt $dep ]]
	then
		return 0;
	fi;
	done;

	return 1;
}

function envsubst_mkdir(){
	local src="$1";
	local dst="$2";

	echo >&1 "$dst";
	mkdir -p `dirname "$dst"`
	envsubst <"$src" >"$dst";
}

# Read that ignores empty and commented lines.
function readwords(){
	local first=$1

	unset $first

	while [[ ! -v $first ]] || [[ -z ${!first} ]] || [[ ${!first} == '#'* ]];
	do
		IFS=$'\t\n\r\v\f ' read -r $@ || return 1;
	done;
}
