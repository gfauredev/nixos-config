#!/bin/sh
nixos_param=''
home_manager_param=''
local_substituter='http://192.168.42.42:42'
local_network='inet 42.42.42.42/24.*wlp166s0' # ip addr regexp

# Use local substituter if local net
if ip addr | grep "$local_network"; then
  home_manager_param="${home_manager_param} --option extra-substituters $local_substituter"
  nixos_param="${nixos_param} --option extra-substituters $local_substituter"
  printf "Passing \"%s\" to nixos-rebuild\n" "$nixos_param"
  printf "Passing \"%s\" to home-manager\n" "$home_manager_param"
fi
echo

system() {
  printf "\nMounting /boot before system update\n"
  sudo mount -v /boot || return # Use fstab

  printf "\nPerforming system update: \"%s\"\n" "sudo nixos-rebuild $nixos_param --flake . switch"
  if systemd-inhibit sudo nixos-rebuild $nixos_param --flake . switch; then
    printf "\nUnmounting /boot after update\n"
    sudo umount -v /boot # Unmount for security
  else
    printf "\nFailed update, unmounting /boot\n"
    sudo umount -v /boot # Unmount for security
    return 1             # Failed update status
  fi
}

home() {
  printf "\nRemoving .config/mimeapps.list\n"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it

  printf "\nPerforming profile update: \"%s\"\n" \
    "home-manager $home_manager_param --flake .#${USER}@$(hostname) switch"
  # "home-manager $home_manager_param --flake . switch" # to TEST the default
  systemd-inhibit home-manager $home_manager_param --flake ".#${USER}@$(hostname)" switch || return
  # systemd-inhibit home-manager $home_manager_param --flake . switch || return
}

cfg_pull() {
  printf "Pulling latest changes\n"
  git pull --recurse-submodules || printf '\nUnable to pull from %s\n' "$(git remote)"
  echo
}

edit() {
  $EDITOR . && git add . && git commit "$@" || return
}

# cd /config || exit # Go inside the config directory
cd "$XDG_CONFIG_HOME/flake" || cd "$HOME/.config/flake" || cd /flake || cd /config \
 || cd /etc/nixos || cd /etc/flake || exit # Go inside the config directory

if [ "$#" -eq 0 ]; then
  cfg_pull
  # cd home || exit # FIXME
  edit && home
  exit
fi

# Main action according to first parameter
case "$1" in
"rebuild")
  cfg_pull
  if [ "$2" != "home" ] && [ "$2" != "system" ] && [ "$2" != "all" ]; then
    home
  fi
  # Further "home", "system" or "all" argument to rebuild
  shift
  ;;
"system")
  sudo echo Asked sudo now for later
  cfg_pull
  # cd system || exit # FIXME
  edit && system || exit
  shift
  ;;
"home")
  cfg_pull
  # cd home || exit # FIXME
  edit && home || exit
  shift
  ;;
"all")
  sudo echo Asked sudo now for later
  cfg_pull
  if edit; then
    system
    home || exit
  else
    exit
  fi
  shift
  ;;
"update")
  if [ "$2" = "system" ] || [ "$2" = "all" ]; then
    sudo echo Asked sudo now for later
  fi
  cfg_pull
  nix flake update --commit-lock-file || exit
  shift
  ;;
"push")
  git rebase -i || exit
  git push || exit
  shift
  ;;
"log")
  git log --oneline || exit
  echo
  git status || exit
  shift
  ;;
"cd")
  exec $SHELL # We execute a shell at the WD of this script
  ;;
*) # If parameters are a message, update home with this commit message and exit
  cfg_pull
  # cd home || exit # FIXME
  edit -m "$*" && home
  exit
  ;;
esac

# Go through each following parameters and act accordingly
for param in "$@"; do
  case $param in
  "home")
    home
    ;;
  "system")
    system
    ;;
  "all")
    system
    home
    ;;
  "push")
    git push
    ;;
  "off")
    systemctl poweroff
    ;;
  "poweroff")
    systemctl poweroff
    ;;
  "boot")
    systemctl reboot
    ;;
  "reboot")
    systemctl reboot
    ;;
  esac
done
