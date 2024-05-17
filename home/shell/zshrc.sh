########## Often used, small functions ##########
# Clear screen & give info on empty line CR
empty_cr () {
  if [[ -z $BUFFER ]]; then
    clear -x
    date; echo -n
    # echo "Why I am doing what I do ?"
    if [ "$(hostnamectl chassis)" = "laptop" ]; then
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
# Define function ran on empty carriage return
zle -N empty_cr
bindkey '^M' empty_cr

# Open with default MIME handler & detach from term
open () {
  xdg-open "$@" & disown
}

# Make directory(ies) & cd into it (the first)
md () {
  mkdir -pv "$@" && cd "$1" || return
}

# Replace occurences of $1 by $2 in $3
replace () {
  \rg --passthrough --multiline "$1" -r "${@:2}"
}

# Delete some annoying autocreated directories in user home
UNWANTED=("Downloads" "intelephense" "pt")
for dir in "${UNWANTED[@]}"; do
  if [ -d "${HOME:?}/$dir" ]; then
    rmdir --ignore-fail-on-non-empty "${HOME:?}/$dir"
  fi
done
