[ -n "$1" ] && WD="--cwd=$1" || WD="--cwd=$PWD"

wezterm start $WD "${@:2}" & disown
