# Often used small functions, POSIX compliant
empty_cr() { # Clear screen & give info on empty line CR
  if [ -z "$BUFFER" ]; then
    clear -x
    date
    # echo "Why I am doing what I do ?"
    if [ "$(hostnamectl chassis)" = "laptop" ]; then
      acpi -b
    fi
    echo
    eza --icons --git -l --no-permissions --no-user --sort=age
    if git rev-parse --git-dir >/dev/null 2>&1; then
      echo
      git status
    fi
  fi
  zle accept-line
}
zle -N empty_cr # Define function ran on empty carriage return
bindkey '^M' empty_cr

# Make directory(ies) & cd into it (the first)
md() {
  mkdir -pv "$@" && cd "$1" || return
}

# Delete some annoying autocreated directories in user home (if empty)
for dir in Downloads intelephense pt; do
  if [ -d "${HOME:?}/$dir" ]; then
    rmdir --ignore-fail-on-non-empty "${HOME:?}/$dir"
  fi
done
