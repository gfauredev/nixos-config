CMD=$SHELL
if [ "$#" -eq 0 ]; then OPT="--cwd=$PWD"; fi
if [ "$#" -eq 1 ]; then OPT="--cwd=$1"; fi
if [ -n "$2" ]; then
    CMD="$1"
    OPT="--cwd=$2"
    # special cases
    if [[ "$2" == "menu" ]]; then OPT='--class menu'; fi
fi
wezterm start $OPT $SHELL -ic $CMD & disown
