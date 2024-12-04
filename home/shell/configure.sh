#!/bin/sh
nixos_rebuild_param=''
home_manager_param=''
git_param="-C ./public/"
nix_flake_param="--flake ./public/"

# Use local substituter if local net
# if ip addr | grep "$local_network"; then
#   local_substituter='http://192.168.42.42:42'
#   local_network='inet 42.42.42.42/24.*wlp166s0' # ip addr regexp
#   home_manager_param="${home_manager_param} --option extra-substituters $local_substituter"
#   nixos_rebuild_param="${nixos_rebuild_param} --option extra-substituters $local_substituter"
#   printf "Passing \"%s\" to nixos-rebuild\n" "$nixos_rebuild_param"
#   printf "Passing \"%s\" to home-manager\n" "$home_manager_param"
# fi

system() {
  printf "\nMounting /boot before system update\n"
  sudo mount -v /boot || return # Use fstab
  printf "\nPerforming system update: \"%s\"\n" "sudo nixos-rebuild $nixos_rebuild_param --flake . switch"
  if systemd-inhibit sudo nixos-rebuild $nixos_rebuild_param --flake . switch; then
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
    "home-manager $home_manager_param --flake . switch"
  systemd-inhibit home-manager $home_manager_param --flake . switch || return
  # home-manager $home_manager_param --flake ".#${USER}@$(hostname)" switch
}

cfg_pull() {
  printf "Pulling latest changes\n"
  git pull --recurse-submodules || printf '\nUnable to pull from %s\n' "$(git remote)"
  echo
}

edit() {
  $EDITOR . && git $git_param add . && git $git_param commit "$@" || return 
  nix flake update public # Update public config
  git commit public flake.lock "$@" || return
}

# Go inside the config directory
cd "$XDG_CONFIG_HOME/flake" || cd "$HOME/.config/flake" \
  || cd /flake || cd /config \
  || cd /etc/flake || cd /etc/nixos \
  || exit

# If no parameters, just edit home
if [ "$#" -eq 0 ]; then
  cfg_pull
  edit && home
  exit
fi

# Main action according to first parameter
case "$1" in
re*) # Rebuild
  cfg_pull
  if [ "$2" != "home" ] && [ "$2" != "system" ] && [ "$2" != "all" ]; then
    home
  fi
  # Further "home", "system" or "all" argument to rebuild
  shift
  ;;
sys*) # System
  sudo echo Asked sudo now for later
  cfg_pull
  edit && system || exit
  shift
  ;;
hom*) # Home
  cfg_pull
  edit && home || exit
  shift
  ;;
all) # System + Home
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
up*) # Upgrade
  if [ "$2" = "system" ] || [ "$2" = "all" ]; then
    sudo echo Asked sudo now for later
  fi
  cfg_pull
  nix flake update $nix_flake_param --commit-lock-file || exit
  nix flake update --commit-lock-file || exit
  shift
  ;;
pu*) # Push
  git $git_param rebase -i || exit
  git commit --amend --all && git rebase -i || exit
  git push || exit
  shift
  ;;
lo*) # (Git) Logs
  git $git_param log --oneline || exit
  echo
  git $git_param status || exit
  shift
  ;;
c?) # cd
  exec $SHELL # We execute a shell at the WD of this script
  ;;
*) # If parameters are a message, update home with this commit message and exit
  cfg_pull
  edit --message="$*" && home
  exit
  ;;
esac

# Go through each following parameters and act accordingly
for param in "$@"; do
  case $param in
  hom*)
    home
    ;;
  sys*)
    system
    ;;
  all*)
    system
    home
    ;;
  pu*)
    git $git_param push
    ;;
  *off)
    systemctl poweroff
    ;;
  *boot)
    systemctl reboot
    ;;
  esac
done
