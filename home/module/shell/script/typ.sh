# Quickly compile Typst files
if [ "$#" -gt 0 ]; then
  for f in "$@"; do
    typst compile "$f"
  done
else
  typst compile "$(\ls --sort=time ./*.typ | head -n1)"
fi
