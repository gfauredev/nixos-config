#!zsh
if [[ "$1" == *"back"* ]]; then
  restic -r "$1" -v backup $HOME/archive $HOME/data $HOME/data.large $HOME/life* $HOME/project*
else
  restic -r "$1" -v backup $HOME/data $HOME/life $HOME/project
fi
