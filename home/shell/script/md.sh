# Make directory(ies) & cd into it (the first)
mkdir -pv "$@" && cd "$1" || return
