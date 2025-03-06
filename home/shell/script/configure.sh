NIXOS_REBUILD_CMD='nixos-rebuild' # Set default params here
HOME_MANAGER_CMD='home-manager'   # Set default params here
RESOURCE_LIMIT='systemd-run --scope -p MemoryHigh=66%'
# -p CPUQuota=666%' # Also limit CPU usage (Nix already limits to 8 threads)

SYSTEM_CFG="./system/" # System (NixOS) configurations location
HOME_CFG="./home/"     # Home (Home Manager) configurations location

show_help() {
  echo "By default, edit the configuration, amend or commit the changes, rebuild."
  echo "The following arguments can be passed in any order."
  echo
  echo "- [--]h[elp]: Show this help message (and exit)."
  echo "- u[pgrade]:  Update every flake inputs (don’t edit the configuration)."
  echo "- p[ush]:     Push the Git repositories after sucessful rebuild."
  echo "- l[og]:      Display Git logs and status of the configuration’s repo."
  echo "- c|d|cd:     Open the default shell ($SHELL) in the flake config dir."
  echo "- [power]off: Poweroff after all actions, cancels previous power args."
  echo "- [re]boot:   Reboot after all actions, cancels previous power args."
  echo "- sus[pend]|sleep: Suspend after all actions, cancels prevs power args."
  echo
  echo "Any remaining argument is appended to the Git commit message,"
  echo "and thus indicates that the configuration should be edited."
}

info() {
  printf '\033[1m' # Start bold
  printf "$@"
  printf '\033[0m\n' # End bold, newline
}

show_logs_status() {
  if [ -d "public" ]; then
    git -C ./public/ log --oneline || exit
    echo
    git -C ./public/ status || exit
  else
    git log --oneline || exit
    echo
    git status || exit
  fi
}

__cfg_pull() {
  remote=$(git "$@" remote get-url origin | cut -d'@' -f2 | cut -d':' -f1)
  timeout=3
  info 'Test if remote %s is reachable (in less than %ss)' "$remote" "$timeout"
  if ping -c 1 -w $timeout "$remote"; then
    info '%s reached, pull latest changes from it' "$remote"
    git "$@" pull
  else
    info '%s non reachable, move on' "$remote"
  fi
}

cfg_pull() {
  if [ -d "public" ]; then
    info 'Public: Pulling latest changes'
    __cfg_pull -C ./public/
    info 'Private: Pulling latest changes'
    __cfg_pull -C ./private/
  else
    info 'Pulling latest changes'
    __cfg_pull
  fi
}

flake_update_inputs() {
  if [ -d "public" ]; then
    info 'Public: Update flake inputs'
    nix flake update --flake ./public/ --commit-lock-file || exit 1
    info 'Private: Update flake inputs'
    nix flake update --flake ./private/ --commit-lock-file || return
  else
    info 'Update flake inputs'
    nix flake update --commit-lock-file || return
  fi
}

cfg_edit() {
  info 'Start default text editor'
  $EDITOR .
}

# Global argument
rebuild_home=false # Whether to rebuild the home with $HOME_MANAGER_CMD

__cfg_commit() {
  amend=''
  info 'Commit %s and flake.nix' $SYSTEM_CFG
  if git "$1" "$2" commit $SYSTEM_CFG flake.nix ${3:+--message "$3"}; then
    rebuild_system=true # Rebuild system as changes have been made
    amend='--amend'     # Amend following commits because there’s already it
  fi
  info 'Commit (or amend) %s' $HOME_CFG
  if git "$1" "$2" commit $amend $HOME_CFG ${3:+--message "$3"}; then
    rebuild_home=true # Rebuild home as changes have been made
    amend='--amend'   # Amend following commits because there’s already it
  fi
  # Commit remaining changes, but don’t trigger a rebuild in these cases
  info 'Commit (or amend) all the remaining: %s' "$3"
  git "$1" "$2" commit $amend --all ${3:+--message "$3"}
}

cfg_commit() {
  if [ -d 'public' ]; then
    info 'Public: Commit flake repository'
    __cfg_commit -C ./public/ "$1"
    info 'Private: Commit flake repository (including public update)'
    nix flake update --flake ./private/ public || exit 1
    git -C ./private/ commit --all ${1:+--message "$1"} || exit # Stop if no changes
  else
    info 'Commit flake repository'
    __cfg_commit '' '' "$1" || exit # Stop if no changes
  fi
}

__cfg_amend() {
  # Amend only if there’s unpushed commits
  if [ -n "$(git log --branches --not --remotes)" ]; then
    git "$@" commit --amend --all --no-edit || exit # Stop if no changes
  else
    info 'All commits pushed, no one to amend, create new commit instead'
    cfg_commit # If needed, new commit
  fi
}

cfg_amend() {
  if [ -d "public" ]; then
    info 'Public: Amend flake repository'
    __cfg_amend -C ./public/
    info 'Private: Amend flake repository'
    nix flake --flake ./private/ update public || exit 1
    __cfg_amend -C ./private/
  else
    info 'Amend flake repository'
    __cfg_amend
  fi
}

rebuild_system() {
  info 'Mount /boot before system update'
  sudo mount -v /boot || exit 1 # Use fstab
  if [ -d "public" ]; then
    NIXOS_REBUILD_CMD="$NIXOS_REBUILD_CMD --flake private/"
  else
    NIXOS_REBUILD_CMD="$NIXOS_REBUILD_CMD --flake ."
  fi
  info 'System: Update: "%s"' "$NIXOS_REBUILD_CMD"
  if systemd-inhibit sudo $RESOURCE_LIMIT $NIXOS_REBUILD_CMD switch; then
    info 'Unmount /boot after update'
    sudo umount -v /boot # Unmount for security
  else
    info 'Failed update, unmount /home'
    sudo umount -v /boot # Unmount for security
    return 1             # Failed update status
  fi
}

rebuild_home() {
  info 'Remove .config/mimeapps.list'
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it
  if [ -d "public" ]; then
    HOME_MANAGER_CMD="$HOME_MANAGER_CMD --flake private/"
  else
    HOME_MANAGER_CMD="$HOME_MANAGER_CMD --flake ."
  fi
  info 'Home: Update: "%s"' "$HOME_MANAGER_CMD"
  systemd-inhibit $HOME_MANAGER_CMD switch || return
}

cfg_push() {
  cfg_amend # Amend before pushing in case there’s uncommited changes
  if [ -d "public" ]; then
    info 'Public: Push flake repository'
    git -C ./public/ push || return
    info 'Private: Push flake repository'
    git -C ./private/ push || return
  else
    info 'Push flake repository'
    git push || exit
  fi
}

cfg_rebase() {
  if [ -d "public" ]; then
    info 'Public: Rebase flake repository'
    git -C ./public/ rebase -i || return
    info 'Private: Rebase flake repository'
    # TODO Automatically sync the private non-pushed commits with the public ones
    git -C ./private/ rebase -i || return # TODO stop that, annoying
  else
    info 'Rebase flake repository'
    git rebase -i || return
  fi
}

# Go inside the config directory, start of the main script
cd "$XDG_CONFIG_HOME/flake" || cd "$HOME_CFG/.config/flake" ||
  cd /flake || cd /config ||
  cd /etc/flake || cd /etc/nixos ||
  exit

# Arguments that are collected in any order
update_inputs=false     # Whether to update flake inputs
rebuild_system=false    # Whether to rebuild the system with $NIXOS_REBUILD_CMD
commit_msg=""           # Message to be constructed with remaining arguments
commit_type=""          # Type of commit, new feature, bugfix…
push_repositories=false # Whether to push the Git repositories after update
power_state=""          # Whether to suspend, turn off or reboot the computer
while [ "$#" -gt 0 ]; do
  case "$1" in
  h | help | -h | --help)
    show_help # Directly show help message…
    exit      # and exit right after
    ;;
  c | d | cd) # Directly open default shell into current working directory
    info 'You can exit the shell to get back to previous working directory'
    if [ "$2" = "public" ] || [ "$2" = "private" ]; then
      cd "$2" || exit 1 # cd into sub-directory
    fi
    exec $SHELL # Execute the default shell at the WD of this script
    ;;
  l | log | logs | stat | stats | status) # Show Git logs and status
    show_logs_status                      # Directly show Git logs and status
    exit
    ;;
  u | up | update | upgrade) # Update the flake’s inputs, no rebuild by default
    update_inputs=true
    ;;
  s | sy | sys | system | os)            # Rebuild the NixOS system
    sudo echo 'Asked sudo now for later' # ask sudo preventively
    rebuild_system=true
    ;;
  p | pu | push) # Push the flake’s repository
    push_repositories=true
    ;;
  sus | sleep | suspend) # Suspend the system at the end of the script
    power_state="suspend"
    ;;
  off | poweroff) # Turn off the system at the end of the script
    power_state="poweroff"
    ;;
  re | boot | reboot) # Restart the system at the end of the script
    power_state="reboot"
    ;;
  feat*) # New feature commit append remaining arguments, rebuild
    commit_msg=$(echo "$*" | sed 's/^\s*//' | sed 's/\s*$//')
    commit_type=feat
    break # The loop should stop anyway, but quicker
    ;;
  fix*) # Bug fix commit, append remaining arguemnts, rebuild
    commit_msg=$(echo "$*" | sed 's/^\s*//' | sed 's/\s*$//')
    commit_type=fix
    break # The loop should stop anyway, but quicker
    ;;
  *) # Append any other arguments to the Git commit message
    commit_msg=$(echo "$*" | sed 's/^\s*//' | sed 's/\s*$//')
    # Also clean commit message (remove start and end whitespaces)
    break # The loop should stop anyway, but quicker
    ;;
  esac
  shift # Next argument
done

printf "Update Flake inputs: %s\n" $update_inputs
printf "Rebuild NixOS system: %s\n" $rebuild_system
printf "Commit message: '%s'\n" "$commit_msg"
printf "Commit type: '%s'\n" "$commit_type"
printf "Push Git repositories: %s\n" $push_repositories
printf "Power state change: '%s'\n" $power_state

if $update_inputs; then
  cfg_pull            # Always pull the latest configuration…
  flake_update_inputs # before updating inputs
fi
# Always edit and commit if commit message not empty
if [ -n "$commit_msg" ]; then
  cfg_pull                 # Always pull the latest configuration…
  cfg_edit                 # before editing the configuration,
  cfg_commit "$commit_msg" # and commiting
# By default (no args), amend if there’s unpushed commits, or else commit
elif [ $update_inputs = false ] && [ $push_repositories = false ]; then
  cfg_pull  # Always pull the latest configuration…
  cfg_edit  # before editing the configuration,
  cfg_amend # and amending the commit
fi
if $rebuild_system; then   # Always rebuild system if explicitly set
  rebuild_system || exit 1 # Don’t continue if the build failed
fi
if $rebuild_home && # Rebuild if home/ changed for a feat or a fix
  { [ $commit_type = feat ] || [ $commit_type = fix ]; }; then
  rebuild_home || exit 1 # Don’t continue if the build failed
fi
# Push repositories if explicit argument
if $push_repositories; then
  # Rebase interactively before pushing, if not doing any other operations
  if [ $rebuild_system = false ] && [ $rebuild_home = false ] &&
    [ $update_inputs = false ] &&
    [ -z "$commit_msg" ] && [ -z "$power_state" ]; then
    cfg_rebase
  fi
  cfg_push
fi
if [ -n "$power_state" ]; then # Change power state after other operations
  systemctl $power_state
fi
