#!/bin/sh
NIXOS_REBUILD_CMD='nixos-rebuild' # Set default params here
HOME_MANAGER_CMD='home-manager'   # Set default params here
SUBFLAKE="public"                 # Leave empty to disable

show_help() {
  echo "By default, edit the configuration, commit the changes, and rebuild Home."
  echo "The following arguments can be passed in any order."
  echo
  echo "- r[e]:        Enable rebuild only mode, no editing."
  echo "- s[y|ys]:     Rebuild NixOS configuration ($NIXOS_REBUILD_CMD)."
  echo "- ho[m]:       Always rebuild Home Manager configuration ($HOME_MANAGER_CMD)."
  echo "- h[elp]:      Show this help message (and exit if no other arguments)."
  echo "- a[ll]:       Rebuild NixOS and Home Manager configurations."
  echo "- u[p|pd|pg]:  Update every flake inputs (don’t edit the configuration)."
  echo "- am[end]:     Amend the eventual modifications instead of creating a new commit."
  echo "- p[ush]:      Push the Git repositories after sucessful rebuild, rebase if alone."
  echo "- l[og]:       Display Git logs and status of the configuration’s repository."
  echo "- c|d|cd:      Open the default shell ($SHELL) in the flake config directory."
  echo "- off:         Poweroff after all actions, cancels previous reboot/cd argument(s)."
  echo "- boot:        Reboot after all actions, cancels previous poweroff/cd argument(s)."
  echo
  echo "Any remaining argument is appended to the Git commit message,"
  echo "and thus forces the configuration to be edited (unless rebuild-only mode)."
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

cfg_edit() {
  cfg_pull
  $EDITOR .
}

cfg_commit() {
  if [ -n "$SUBFLAKE" ]; then
    cd $SUBFLAKE || return
    git checkout main # Ensure we’re on main FIX
    git add .
    git commit "$@" || return
    cd .. || return
    nix flake update $SUBFLAKE # Update subflake input
  fi
  git commit --all "$@" || return
}

cfg_amend() {
  if [ -n "$(git log @{u}..)" ]; then # Amend only if there’s unpushed commits
    if [ -n "$SUBFLAKE" ]; then
      cd $SUBFLAKE || return
      git checkout main # Ensure we’re on main FIX
      git commit --amend --all --no-edit || return
      cd .. || return
      nix flake update $SUBFLAKE # Update subflake input
    fi
    git commit --amend --all --no-edit || return
  else
    cfg_commit
  fi
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
  if [ -n "$SUBFLAKE" ]; then
    cd $SUBFLAKE || return
    git checkout main
    if [ -n "$(git log @{u}..)" ]; then # Amend pending edits if there’s unpushed commits
      git commit --amend --message="$(git log -1 --pretty=%s)"
    fi
    cd .. || return
  fi
  if [ -n "$(git log @{u}..)" ]; then # Amend pending edits if there’s unpushed commits
    git commit --amend --all --no-edit
  fi
  git push || exit
}

cfg_rebase() {
  if [ -n "$SUBFLAKE" ]; then
    cd $SUBFLAKE || return
    git checkout main
    git rebase -i || exit
    cd .. || return
  fi
  git rebase -i
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
update_inputs=false
amend_edits=false
push_repositories=false
cd=false
commit_message="" # To be constructed with remaining arguments
poweroff=false
reboot=false
while [ "$#" -gt 0 ]; do
  case "$1" in
  # r | re | rebuild) # Rebuild only, don’t edit
  r | re | reb) # Use words unlikely to appear in commit message
    rebuild_only=true
    ;;
  # s | sy | sys | system) # Rebuild System but not Home
  s | sy | sys) # Words less likely to appear in commit messages
    system=true
    ;;
  # ho | home) # Rebuild Home anyway
  ho | hom) # Words less likely to appear in commit messages
    home=true
    ;;
  h | help)   # Show help message
    show_help # Directly show help message…
    exit      # and exit right after
    ;;
  a | all) # Rebuild System and Home
    system=true
    home=true
    ;;
  # u | up | update | upgrade) # Update the flake’s inputs, no rebuild
  u | up | upd | upg) # Words less likely to appear in commit messages
    update_inputs=true
    ;;
  am | amend) # Amend the eventual modifications
    amend_edits=true
    ;;
  p | push) # Push the flake’s repository
    push_repositories=true
    ;;
  l | log)           # Show Git logs and status
    show_logs_status # Directly show Git logs and status
    exit
    ;;
  c | d | cd) # Open default shell into current WD
    cd=true
    ;;
  # off | poweroff) # Turn off the system at the end of the script
  off) # Words less likely to appear in commit messages
    poweroff=true
    ;;
  # boot | reboot) # Restart the system at the end of the script
  boot) # Words less likely to appear in commit messages
    reboot=true
    ;;
  *) # Append any other parameters to the Git commit message
    commit_message="$commit_message $1"
    ;;
  esac
  shift
done

# DEBUG
printf "Rebuild only mode (no edit): %s\n" $rebuild_only
printf "Rebuild system: %s\n" $system
printf "Rebuild home: %s\n" $home
printf "Update flake inputs: %s\n" $update_inputs
printf "Amend edits (no new commits): %s\n" $amend_edits
printf "Push Git repositories: %s\n" $push_repositories
printf "Change directory: %s\n" $cd
printf "Commit message: '%s'\n" "$commit_message"
printf "Poweroff: %s\n" $poweroff
printf "Reboot: %s\n" $reboot
echo

# Execute proper functions according to collected arguments
if $system; then
  sudo echo Asked sudo now for later
fi
if $update_inputs; then
  flake_update_inputs
fi
# Edit by default
# Don’t edit if rebuild-only mode or if updating inputs
# Don’t edit if pushing repositories or changing directory,
#   unless system or home (or all)
# Always edit if commit message not empty or if amending
if [ $rebuild_only = false ] && [ $update_inputs = false ] &&
  { [ $push_repositories = false ] && [ $cd = false ] ||
    [ $system = true ] || [ $home = true ]; } ||
  [ -n "$commit_message" ] || [ $amend_edits = true ]; then
  cfg_edit
  if $amend_edits; then
    cfg_amend
  else
    cfg_commit --message="$(echo "$commit_message" | sed 's/^[ \t]*//')"
  fi
fi
if $system; then
  rebuild_system
fi
# Rebuild home by default,
# Don’t rebuild home if updating inputs or pushing repositories or changing dir or system
# Rebuild if rebuild only mode and no system
# Always rebuild home if home
if { [ $update_inputs = false ] && [ $push_repositories = false ] &&
  [ $cd = false ] && [ $system = false ]; } ||
  { [ $system = false ] && [ $rebuild_only = true ]; } || [ $home = true ]; then
  rebuild_home
fi
# Push repositories if push repositories
if $push_repositories; then
  # Rebase only if not rebuilding and not updating and not turning off or rebooting
  if [ $rebuild_only = false ] && [ $system = false ] && [ $home = false ] &&
    [ $update_inputs = false ] && [ $amend_edits = false ] &&
    [ $poweroff = false ] && [ $reboot = false ] && [ -z "$commit_message" ]; then
    cfg_rebase
  fi
  cfg_push
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
