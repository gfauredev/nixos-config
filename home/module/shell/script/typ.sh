# Quickly compile Typst files
if [ "$#" -eq 0 ]; then
  # By default: compiles the most recently modified Typst file
  typst compile "$(\ls --sort=time ./*.typ | head -n1)"
elif [ "$#" -eq 1 ]; then
  # One main file passed: open preview on it, edit it, compiles it afterwards
  # tinymist preview "$1" >/dev/null 2>&1 & # TODO
  typst watch "$1" >/dev/null 2>&1 &
  pid_compile=$!
  zathura --fork "${1%.typ}.pdf" >/dev/null 2>&1 &
  pid_preview=$!
  $EDITOR "$1"
  kill $pid_compile
  kill $pid_preview # Kill previously launched preview
  typst compile "$1"
else
  # Several Typst files passed: compile them all
  for f in "$@"; do
    typst compile "$f"
  done
fi
