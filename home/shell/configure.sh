#!/bin/sh
NIXOS_REBUILD_CMD='nixos-rebuild' # Set default params here
HOME_MANAGER_CMD='home-manager'   # Set default params here
SUBFLAKE="public"                 # Leave empty to disable

show_help() {
  echo "By default, edit the configuration, commit the changes, and rebuild Home."
  echo "The following arguments can be passed in any order."
  echo
  echo "- r[ebuild]:   Enable rebuild only mode, no editing."
  echo "- s[ystem]:    Rebuild NixOS configuration ($NIXOS_REBUILD_CMD)"
  echo "- ho[me]:      Always rebuild Home Manager configuration ($HOME_MANAGER_CMD)"
  echo "- h[elp]:      Show this help message (and exit if no other arguments)."
  echo "- a[ll]:       Rebuild NixOS and Home Manager configurations."
  echo "- u[pdate]:    Update every flake inputs (don’t edit the configuration)."
  echo "- p[ush]:      Interactively rebase and push the Git repository (don’t edit if only)."
  echo "- l[og]:       Display Git logs and status of the configuration’s repository."
  echo "- c|d|cd:      Open the default shell ($SHELL) in the flake directory."
  echo "- [re]boot:    Reboot after all actions, cancel previous poweroff/cd argument(s)."
  echo "- [power]off:  Poweroff after all actions, cancel previous reboot/cd argument(s)."
  echo
  echo "Any remaining argument is appended to the Git commit message,"
  echo "and thus forces the configuration to be edited (unless rebuild-only mode)"
}

show_logs_status() {
  if [ -n "$SUBFLAKE" ]; then
    git -C ./$SUBFLAKE log --oneline || exit
    echo
    git -C ./$SUBFLAKE status || exit
  else
    git log --oneline || exit
    echo
    git status || exit
  fi
}

cfg_pull() {
  printf "Pulling latest changes\n"
  git pull --recurse-submodules || printf '\nUnable to pull from %s\n' "$(git remote)"
  echo
}

flake_update_inputs() {
  cfg_pull # Always pull the latest configuration
  if [ -n "$SUBFLAKE" ]; then
    nix flake update --flake ./$SUBFLAKE --commit-lock-file || exit
    git commit ./$SUBFLAKE --message="chore($SUBFLAKE): update flake inputs"
  fi
  nix flake update --commit-lock-file || exit
}

edit_commit() {
  cfg_pull
  $EDITOR .
  if [ -n "$SUBFLAKE" ]; then
    cd $SUBFLAKE || return
    git checkout main
    git add .
    git commit "$@" || return
    cd .. || return
    nix flake update $SUBFLAKE # Update subflake input
  fi
  git commit $SUBFLAKE flake.lock "$@" || return
}

rebuild_system() {
  printf "\nMounting /boot before system update\n"
  sudo mount -v /boot || return # Use fstab
  printf "\nPerforming system update: \"%s\"\n" "sudo $NIXOS_REBUILD_CMD --flake . switch"
  if systemd-inhibit sudo $NIXOS_REBUILD_CMD --flake . switch; then
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
    "$HOME_MANAGER_CMD --flake . switch"
  systemd-inhibit $HOME_MANAGER_CMD --flake . switch || return
}

cfg_push() {
  # if [ -n "$SUBFLAKE" ]; then
  #   cd $SUBFLAKE || return
  #   git checkout main # TEST relevance
  #   cd .. || return
  # fi
  if [ -n "$(git log @{u}..)" ]; then # Amend only if there’s unpushed commits
    git commit --amend --all --no-edit
  fi
  git push || exit
}

cfg_rebase_push() {
  if [ -n "$SUBFLAKE" ]; then
    cd $SUBFLAKE || return
    git checkout main
    git rebase -i || exit
    cd .. || return
    if [ -n "$(git log @{u}..)" ]; then # Amend only if there’s unpushed commits
      git commit --amend --message="$(git -C $SUBFLAKE log -1 --pretty=%s)"
    fi
  fi
  if [ -n "$(git log @{u}..)" ]; then # Amend only if there’s unpushed commits
    git commit --amend --all --no-edit
  fi
  git rebase -i && git push || exit
}

# Go inside the config directory, start of the main script
cd "$XDG_CONFIG_HOME/flake" || cd "$HOME/.config/flake" ||
  cd /flake || cd /config ||
  cd /etc/flake || cd /etc/nixos ||
  exit

# Collect arguments in any order
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

# Execute proper functions according to collected arguments
if [ $help = true ]; then
  show_help
fi
if $git_logs_status; then
  show_logs_status
  exit
fi
if $system; then
  sudo echo Asked sudo now for later
fi
if $update_inputs; then
  flake_update_inputs
fi
# Never edit when rebuild-only mode or if updating inputs
# If pushing repositosries or changing directory, only edit if explicitly precised
if [ $rebuild_only = false ] && [ $update_inputs = false ] &&
  { [ $push_repositories = false ] && [ $cd = false ] ||
    [ $system = true ] || [ $home = true ] || [ -n "$commit_message" ]; }; then
  edit_commit --message="$(echo "$commit_message" | sed 's/^[ \t]*//')"
fi
if $system; then
  rebuild_system
fi
# Rebuild home by default, unless: updating inputs, pushing repositories or changing dir
# Always rebuild home if explicitly precised
if [ $home = true ] ||
  { [ $update_inputs = false ] && [ $push_repositories = false ] &&
    [ $cd = false ] && [ $system = false ]; }; then
  rebuild_home
fi
if $push_repositories; then
  if [ $cd = true ] || [ $reboot = true ] || [ $poweroff = true ]; then
    cfg_push
  else
    cfg_rebase_push
  fi
fi
if $cd; then
  exec $SHELL # Execute the default shell at the WD of this script
fi
if $reboot; then
  systemctl reboot
fi
if $poweroff; then
  systemctl poweroff
fi
