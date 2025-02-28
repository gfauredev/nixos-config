# Make directory(ies) & cd into it (the first)
md() {
  mkdir -pv "$@" && cd "$1" || return
}
