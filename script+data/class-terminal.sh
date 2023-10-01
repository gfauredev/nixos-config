[ -n "$1" ] && WD="--cwd=$1" || WD="--cwd=$PWD"

wezterm start $WD --class $0 "${@:2}" & disown
