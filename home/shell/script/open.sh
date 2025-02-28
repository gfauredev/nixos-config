# Open with default MIME handler & detach from term
open() {
  # nohup xdg-open "$@" >/dev/null & # FIXME
  xdg-open "$@" &
  disown # Bashism
}
