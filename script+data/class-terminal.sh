[ -n "$1" ] && WD="--cwd=$1" || WD="--cwd=$PWD"

filename="$(echo "$0" | grep -o "[^/]*$")"

wezterm start $WD --class $filename "${@:2}" & disown
