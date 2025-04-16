ARCHIVE=$HOME/archive

source=$PWD
if [ -n "$1" ]; then
  source=$(realpath "$1")
fi

if [ "${source#"$HOME"}" != "$source" ]; then
  dest="$ARCHIVE/${source#"$HOME"/}" # Remove the home directory prefix
  printf "Archiving %s under %s\n" "$source" "$dest"
else
  # Not under the user's home directory, print an error and exit
  printf "Error: Not under user home directory.\n" >&2
  exit 1
fi

mkdir --parents --verbose "$dest"
mv --verbose "$source"/* "$dest"
mv --verbose "$source"/.* "$dest"
rmdir --verbose "$source"
