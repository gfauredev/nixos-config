empty_cr () { # Clear screen & give info on empty line CR
  if [[ -z $BUFFER ]]; then
    clear
    echo $(date)
    echo "Why I am doing what I do ?"
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

# Make directory & cd into it
md () {
  mkdir -p "$@" && cd "$1"
}

term () { # for wezterm
    CMD=$SHELL
    if [ "$#" -eq 0 ]; then OPT="--cwd=$PWD"; fi
    if [ "$#" -eq 1 ]; then OPT="--cwd=$1"; fi
    if [ -n "$2" ]; then
        CMD="$1"
        OPT="--cwd=$2"
        # special cases
        if [[ "$2" == "menu" ]]; then OPT='--class menu'; fi
    fi
    wezterm start $OPT $SHELL -ic $CMD & disown
}

# Link Typst lib, Launch Typst watch mode & open pdf file
typ() {
  TYPST_LIB="$HOME/.local/share/typst"
  ln -s $TYPST_LIB lib.typ
  term "watchexec -w $1 -w $TYPST_LIB typst compile $1; rm -fv lib.typ" .
  pdf="$(echo $1|cut -d"." -f1).pdf"
  echo "Oppening the file $pdf"
  open $pdf
  # $EDITOR $1
}

# Create dl dir in user temp dir # TODO this with Nix directly
[ -d /run/user/''$(id -u)/dl ] || mkdir -m 700 /run/user/$(id -u)/dl
[ -h $XDG_DOWNLOAD_DIR ] || ln -s /run/user/$(id -u)/dl $XDG_DOWNLOAD_DIR #
# Delete some annoying dirs # TODO this with Nix directly
[ -d $HOME/Downloads ] && rmdir $HOME/Downloads
[ -d $HOME/intelephense ] && rmdir $HOME/intelephense
