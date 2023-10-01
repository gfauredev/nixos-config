empty_cr () { # Clear screen & give info on empty line CR
  if [[ -z $BUFFER ]]; then
    clear
    echo $(date)
    # echo "Why I am doing what I do ?"
    if [ $(hostnamectl chassis) = "laptop" ]; then
      acpi -b
    fi
    echo
    eza --icons --git -l --no-permissions --no-user --sort=age
    if git rev-parse --git-dir > /dev/null 2>&1 ; then
      echo
      zsh -ic "status"
    fi
  fi
  zle accept-line
}
# Use this function when entering in an empty line
zle -N empty_cr
bindkey '^M' empty_cr

# Open with default MIME handler & detach from term
open () {
  xdg-open "$@" & disown
}

# Open with PDF presenter console
present () {
  [ -n "$2" ] && presentation="$2" || presentation="1"
  [ -n "$3" ] && presenter="$3" || presenter="0"
  pdfpc --presenter-screen=$presenter --presentation-screen=$presentation "$1" & disown
}

# Make directory(ies) & cd into it (the first)
md () {
  mkdir -p "$@" && cd "$1"
}

# Create temporary dirs
[ -d /run/user/$UID/dl ] || mkdir -m 700 /run/user/$UID/dl
[ -h $XDG_DOWNLOAD_DIR ] || ln -s /run/user/$UID/dl $XDG_DOWNLOAD_DIR
# Delete some annoying dirs
[ -d $HOME/Downloads ] && rmdir $HOME/Downloads
[ -d $HOME/intelephense ] && rmdir $HOME/intelephense
