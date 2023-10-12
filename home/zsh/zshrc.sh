########## Often used, small functions ##########
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

# Open with default MIME handler & detach from term
open () {
  xdg-open "$@" & disown
}

# Make directory(ies) & cd into it (the first)
md () {
  mkdir -pv "$@" && cd "$1"
}

########## Define function ran on empty carriage return ##########
zle -N empty_cr
bindkey '^M' empty_cr

# Create temporary downloads dir
# [ -d /run/user/$UID/dl ] || mkdir -m 700 /run/user/$UID/dl
# [ -h $XDG_DOWNLOAD_DIR ] || ln -s /run/user/$UID/dl $XDG_DOWNLOAD_DIR
# Delete some annoying dirs
[ -d $HOME/Downloads ] && rmdir $HOME/Downloads
[ -d $HOME/intelephense ] && rmdir $HOME/intelephense
