# Often used small functions, POSIX compliant
# Clear screen & give info on empty line CR
empty_cr() {
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
      zsh -ic "status"
    fi
  fi
  zle accept-line
}
# Define function ran on empty carriage return
zle -N empty_cr
bindkey '^M' empty_cr

# Open with default MIME handler & detach from term
open() {
  # nohup xdg-open "$@" >/dev/null & # FIXME
  xdg-open "$@" &
  disown # Bashism
}

# Make directory(ies) & cd into it (the first)
md() {
  mkdir -pv "$@" && cd "$1" || return
}

# Edit a file prepending the ISO date
de() {
  $EDITOR "$(date -I)".$*
}

# Copy a file with improvements
c() {
  systemd-inhibit rsync -v --recursive --update --mkpath --perms -h -P "$@"
}

# Replace occurences of $1 by $2 in $3
# replace() {
#   \rg --passthrough --multiline "$1" -r "${@:2}"
# }

# Inhib kills the (buggy) idle service for a given time
inhib() {
  systemctl --user stop hypridle.service && systemd-inhibit sleep "$1"
  systemctl --user start hypridle.service
}

# Present a PDF file
present() {
  nohup pdfpc "$@" >/dev/null &
}

# Quickly compile Typst files
typ() {
  if [ "$#" -gt 0 ]; then
    for f in "$@"; do
      typst compile "$f"
    done
  else
    typst compile "$(\ls --sort=time ./*.typ | head -n1)"
  fi
}

usb() {
  if [ "$1" ]; then
    devs=$*
  else
    lsblk --output TRAN,NAME,SIZE,MOUNTPOINTS || udisksctl status
    printf "Space-separated device(s) to mount, without /dev/ : "
    read -r devs
  fi
  [ -h "$HOME/usb" ] || ln -s "/run/media/$USER" "$HOME/usb" # Create USB link if needed
  for dev in $devs; do
    udisksctl mount -b /dev/"$dev" || return
  done
  cd ~/usb/ || return
}

unusb() {
  if [ "$1" ]; then
    devs=$*
  else
    lsblk --output TRAN,NAME,SIZE,MOUNTPOINTS || udisksctl status
    printf "Space-separated device(s) to unmount, without /dev/ : "
    read -r devs
  fi
  cd ~ || return
  for dev in $devs; do
    udisksctl unmount -b /dev/"$dev" || return
    udisksctl power-off -b /dev/"$dev"
  done
  \rm "$HOME"/usb
}

# Delete some annoying autocreated directories in user home (if empty)
for dir in Downloads intelephense pt; do
  if [ -d "${HOME:?}/$dir" ]; then
    rmdir --ignore-fail-on-non-empty "${HOME:?}/$dir"
  fi
done
