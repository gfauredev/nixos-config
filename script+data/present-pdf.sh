present () { # Open with PDF presenter console
  # [ -n "$2" ] && presentation="$2" || presentation="1" FIXME
  # [ -n "$3" ] && presenter="$3" || presenter="0" FIXME
  # pdfpc --presenter-screen=$presenter --presentation-screen=$presentation "$1" & disown
  pdfpc "$1" & disown
}

