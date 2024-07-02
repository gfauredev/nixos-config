if [[ "$1" == "*back*" ]]; then
  restic -r "$1" backup $HOME/archive $HOME/data $HOME/data.large $HOME/life* $HOME/project*
else
  restic -r "$1" backup $HOME/data $HOME/life $HOME/project
fi
