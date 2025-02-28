cd=true # Don’t change directory by default
cmd=""
if which "$TERM"; then # Try to find the default terminal command
  cmd=$TERM
else
  cmd=$TERM_COMMAND
fi
if [ -d "$1" ]; then # If the first argument is a directory,
  cd="cd $1"         # open our terminal in it
  shift              # The second argument becomes the first
fi
# if which "$1"; then   # If the first parameter is a command,
#   cmd="$TERM_EXEC $*" # run it (with remaining args) in the new terminal
#   shift               # The second argument becomes the first
# fi
if [ -n "$*" ]; then       # If there are remaining arguments,
  cmd="$cmd $TERM_EXEC $*" # pass them to the new terminal as a command to run
fi
echo "Running: nohup $TERM $cmd &"
$cd || exit
nohup $cmd &
