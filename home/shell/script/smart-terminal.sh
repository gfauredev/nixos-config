wd=$PWD
cmd="$SHELL"
if [ -n "$1" ] && $SHELL -ic which "$1"; then
  cmd="$cmd -ic $*"
elif [ -d "$1" ]; then
  wd="$1"
  shift
  if [ -n "$1" ] && $SHELL -ic which "$1"; then
    cmd="$cmd -ic $*"
  fi
fi
