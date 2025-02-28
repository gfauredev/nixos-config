# Open with default MIME handler & detach from term
# nohup xdg-open "$@" >/dev/null & # FIXME
xdg-open "$@" &
disown # Bashism
