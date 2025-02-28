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

# c() { # Copy a file with improvements
#   systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P "$@"
# }

# commit() { # Commit and lint message
#   if git commit "$@"; then
#     $COMMITLINT_CMD || git reset HEAD^
#   fi
# }

# amend() { # Amend commit and lint message
#   if git git commit --amend "$@"; then
#     $COMMITLINT_CMD || git reset HEAD^
#   fi
# }

# replace() { # Replace occurences of $1 by $2 in $3
#   \rg --passthrough --multiline "$1" -r "${@:2}"
# }

# Delete some annoying autocreated directories in user home (if empty)
for dir in Downloads intelephense pt; do
  if [ -d "${HOME:?}/$dir" ]; then
    rmdir --ignore-fail-on-non-empty "${HOME:?}/$dir"
  fi
done
