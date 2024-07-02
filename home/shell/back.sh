#!zsh
if [[ "$1" == *"back"* ]]; then
# Store everything incrementally with restic in backup drives which label contains "back"
  restic -r "$1" -v backup $HOME/archive $HOME/data $HOME/data.large $HOME/life* $HOME/project*
else
# Store most important directories in drives and sticks which label don’t contains "back"
  rsync --verbose --archive --delete --human-readable $HOME/data $HOME/life $HOME/project "$1"
fi
