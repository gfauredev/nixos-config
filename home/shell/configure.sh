#!/bin/sh
NIXOS_REBUILD_PARAM=''
HOME_MANAGER_PARAM=''
SUBFLAKE="./public" # Leave empty to disable

# Use local substituter if local net
# if ip addr | grep "$local_network"; then
#   local_substituter='http://192.168.42.42:42'
#   local_network='inet 42.42.42.42/24.*wlp166s0' # ip addr regexp
#   home_manager_param="${home_manager_param} --option extra-substituters $local_substituter"
#   nixos_rebuild_param="${nixos_rebuild_param} --option extra-substituters $local_substituter"
#   printf "Passing \"%s\" to nixos-rebuild\n" "$nixos_rebuild_param"
#   printf "Passing \"%s\" to home-manager\n" "$home_manager_param"
# fi

rebuild_system() {
  printf "\nMounting /boot before system update\n"
  sudo mount -v /boot || return # Use fstab
  printf "\nPerforming system update: \"%s\"\n" "sudo nixos-rebuild $NIXOS_REBUILD_PARAM --flake . switch"
  if systemd-inhibit sudo nixos-rebuild $NIXOS_REBUILD_PARAM --flake . switch; then
    printf "\nUnmounting /boot after update\n"
    sudo umount -v /boot # Unmount for security
  else
    printf "\nFailed update, unmounting /boot\n"
    sudo umount -v /boot # Unmount for security
    return 1             # Failed update status
  fi
}

rebuild_home() {
  printf "\nRemoving .config/mimeapps.list\n"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it
  printf "\nPerforming profile update: \"%s\"\n" \
    "home-manager $HOME_MANAGER_PARAM --flake . switch"
  systemd-inhibit home-manager $HOME_MANAGER_PARAM --flake . switch || return
  # home-manager $home_manager_param --flake ".#${USER}@$(hostname)" switch
}

cfg_pull() {
  printf "Pulling latest changes\n"
  git pull --recurse-submodules || printf '\nUnable to pull from %s\n' "$(git remote)"
  echo
}

edit_commit() {
  $EDITOR .
  if [ -n "$SUBFLAKE" ]; then
    git -C $SUBFLAKE add .
    git -C $SUBFLAKE commit "$*"
    nix flake update $SUBFLAKE # Update subflake input
  fi
  git commit $SUBFLAKE flake.lock "$@" || return
}

show_help() {
  echo "By default: Edit the configuration, commit the changes, then rebuild Home."
  echo "Arguments can be passed in any order."
  echo
  echo "r[ebuild]:   Enable rebuild only mode, no editing."
  echo "s[ystem]:    Rebuild NixOS configuration."
  echo "ho[me]:      Always rebuild Home Manager configuration."
  echo "h[elp]:      Show this help message (and exit if no other arguments)."
  echo "a[ll]:       Rebuild NixOS and Home Manager configurations."
  echo "u[pdate]:    Update every flake inputs."
  echo "p[ush]:      Interactively rebase and push the Git repository,"
  echo "             don’t rebuild Home by default."
  echo "l[og]:       Display Git logs and status of the configuration’s repository."
  echo "c|d|cd:      Open the default shell ($SHELL) in the flake directory."
  echo "[re]boot:    Reboot after all actions, cancel previous poweroff/cd argument(s)."
  echo "[power]off:  Poweroff after all actions, cancel previous reboot/cd argument(s)."
  echo "*:           Append argument to the Git commit message."
}

# Go inside the config directory, start of the main script
cd "$XDG_CONFIG_HOME/flake" || cd "$HOME/.config/flake" ||
  cd /flake || cd /config ||
  cd /etc/flake || cd /etc/nixos ||
  exit

# Collect arguments
rebuild_only=false # Whether to forcefully not edit
system=false
home=false
help=false
update_inputs=false
push_repositories=false
git_logs_status=false
cd=false
commit_message="" # To be constructed with remaining arguments
poweroff=false
reboot=false
while [ "$#" -gt 0 ]; do
  case "$1" in
  r | re | rebuild) # Rebuild only, don’t edit
    rebuild_only=true
    ;;
  s | sys | system) # Rebuild System but not Home
    system=true
    ;;
  ho | home) # Rebuild Home anyway
    home=true
    ;;
  h | help) # Show help message
    help=true
    ;;
  a | all) # Rebuild System and Home
    system=true
    home=true
    ;;
  u | up | update | upgrade) # Update the flake’s inputs, no rebuild
    update_inputs=true
    ;;
  p | push) # Push the flake’s repository
    push_repositories=true
    ;;
  l | log) # Show Git logs and status
    git_logs_status=true
    ;;
  c | d | cd) # Open default shell into current WD
    cd=true
    ;;
  off | poweroff) # Turn off the system at the end of the script
    poweroff=true
    ;;
  boot | reboot) # Restart the system at the end of the script
    reboot=true
    ;;
  *) # Append any other parameters to the Git commit message
    commit_message="$commit_message $1"
    ;;
  esac
  shift
done

if $help; then
  show_help
  exit
fi
if $git_logs_status; then
  if [ -n "$SUBFLAKE" ]; then
    git -C $SUBFLAKE log --oneline || exit
    echo
    git -C $SUBFLAKE status || exit
  else
    git log --oneline || exit
    echo
    git status || exit
  fi
  exit
fi
if $system; then
  sudo echo Asked sudo now for later
fi
if $update_inputs; then
  cfg_pull # Always pull the latest configuration
  if [ -n "$SUBFLAKE" ]; then
    nix flake update --flake $SUBFLAKE --commit-lock-file || exit
    git commit $SUBFLAKE --message="chore($SUBFLAKE): update flake inputs"
  fi
  nix flake update --commit-lock-file || exit
fi
# Never edit when rebuild-only mode or if updating inputs
# If pushing repositosries or changing directory, only edit if explicitly precised
if [ $rebuild_only = false ] && [ $update_inputs = false ] &&
  { [ "$push_repositories" = false ] && [ "$cd" = false ] ||
    [ $system = true ] || [ $home = true ]; }; then
  cfg_pull # Always pull the latest configuration
  edit_commit --message="$(echo "$commit_message" | sed 's/^[ \t]*//')"
fi
if $system; then
  rebuild_system
fi
# Rebuild home by default, unless: updating inputs, pushing repositories or changing dir
# Always rebuild home if explicitly precised
if [ $home = "true" ] ||
  { [ $update_inputs = "false" ] && [ $push_repositories = "false" ] &&
    [ $cd = "false" ]; }; then
  rebuild_home
fi
if $push_repositories; then # TODO factorize, modularize ($git_param)
  if [ -n "$SUBFLAKE" ]; then
    git -C $SUBFLAKE rebase -i || exit
  fi
  git commit --amend --all && git rebase -i && git push || exit
fi
if $cd; then
  exec $SHELL # Execute the default shell at the WD of this script
  exit        # Stop the script
fi
if $reboot; then
  systemctl reboot
fi
if $poweroff; then
  systemctl poweroff
fi
