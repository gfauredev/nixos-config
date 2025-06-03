# Quickly compile Typst files
if [ "$#" -eq 0 ]; then
  # By default: compiles the most recently modified Typst file
  typst compile "$(\ls --sort=time ./*.typ | head -n1)"
elif [ "$#" -eq 1 ]; then
  # One main file passed: open preview on it, edit it, compiles it afterwards
  tinymist preview "$1" &
  $EDITOR "$1"
  typst compile "$1"
else
  # Several Typst files passed: compile them all
  for f in "$@"; do
    typst compile "$f"
  done
fi
