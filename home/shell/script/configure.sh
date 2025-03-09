# TODO make this script a package available in this flake’s nix dev environment

# This script allows to easily manage a two-flakes system & home Nix config,
# with one private config having as single input one public config,
# which contains most of the configurations
RESOURCE_LIMIT='systemd-run --scope -p MemoryHigh=66%'
# -p CPUQuota=666%' # Also limit CPU usage (Nix already limits to 8 threads)
NIXOS_REBUILD_CMD="systemd-inhibit sudo $RESOURCE_LIMIT nixos-rebuild"
HOME_MANAGER_CMD='systemd-inhibit home-manager' # Set default params here

# SYSTEM_LOC='./system' # System (NixOS) configuration
HOME_LOC='./home'       # Home (Home Manager) config
PRIVATE_LOC='./private' # Private configuration location
PUBLIC_LOC='./public'   # Public configuration location
rebuild_home=false      # Whether to rebuild the home
rebuild_system=false    # Whether to rebuild the system

show_help() {
  echo "Default: edit the configuration, amend or commit the changes, rebuild."
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

state() {
  printf '\033[3m' # Start italic
  printf "$@"
  printf '\033[0m\n' # End italic, newline
}

info() {
  printf '\033[1m' # Start bold
  printf "$@"
  printf '\033[0m\n' # End bold, newline
}

public_logs_status() {
  git -C $PUBLIC_LOC log --oneline || exit
  git -C $PUBLIC_LOC status || exit
}

# @1 sub-directory containing Git repository to pull (./public or ./private)
pull_one() { # Git pull private or public config
  remote=$(git -C "$1" remote get-url origin | cut -d'@' -f2 | cut -d':' -f1)
  info 'Test if remote %s is reachable (in less than %ss)' "$remote" 3
  if ping -c 1 -w 3 "$remote"; then
    info '%s reached, pull latest changes from it' "$remote"
    git -C "$1" pull
  else
    info '%s non reachable, move on' "$remote"
  fi
}

pull_both() { # Git pull both private and public config
  info 'Public & Private: Pulling latest changes (asynchronously)'
  pull_one $PUBLIC_LOC &
  pull_one $PRIVATE_LOC &
  wait # Wait for background pulls to finish before moving ong
}

update_inputs() { # Update (public) config flake inputs
  info 'Public: Update flake %s inputs' $PUBLIC_LOC
  nix flake update --flake $PUBLIC_LOC --commit-lock-file
  # Test if the last commit is an unpushed lockfile update
  msg=$(git -C $PUBLIC_LOC log --branches --not --remotes -1 --pretty=format:%s)
  if [ "$msg" = "flake.lock: Update" ]; then
    rebuild_home=true # Rebuild home the flake inputs were update
    state "Rebuild Home Manager home (flake inputs update): %s" $rebuild_home
  fi
}

# @1   sub-directory containing Git repository to commit (./public or ./private)
# @all remaining parameters passed to Git (--amend, --message <string>)
commit_one() {   # Commit @1 config with message @2
  repo_path="$1" # Location of Git repository
  shift          # Remove $1 (repo path) from $@
  git -C "$repo_path" diff
  if [ -d "$repo_path/$HOME_LOC" ]; then
    if [ -n "$(git -C "$repo_path" diff $HOME_LOC)" ] ||
      [ -n "$(git -C "$repo_path" diff flake.*)" ]; then
      rebuild_home=true # Rebuild home as changes have been made
      state "  Rebuild Home Manager home (%s changed): %s" $HOME_LOC $rebuild_home
    fi
  fi
  # Commit all the changes
  if [ "$1" = "--message" ]; then # TEST if necessary for msg to stay one string
    shift                         # Remove $1 "--message" from $*
    info '\t❯ git -C %s commit --all --message "%s"' "$repo_path" "$*"
    git -C "$repo_path" commit --all --message "$*" || return
  elif [ "$1" = "--amend" ]; then
    info '\t❯ git -C %s commit --all --amend --no-edit' "$repo_path"
    git -C "$repo_path" commit --all --amend --no-edit || return
  fi
}

# @1 Git commit message
commit_both() { # Git commit both private and public config
  info 'Public: Commit flake repository'
  if commit_one $PUBLIC_LOC --message "$1"; then # Commit the public flake
    info 'Private: Update flake %s inputs' $PRIVATE_LOC
    nix flake update --flake $PRIVATE_LOC # Update private’s public flake input
  fi
  info 'Private: Commit flake repository (including public input update)'
  commit_one $PRIVATE_LOC --message "$1" # Commit the private flake
}

# @1 sub-directory containing Git repository to commit (./public or ./private)
amend_one() { # Amend public or private config
  if [ -n "$(git -C "$1" log --branches --not --remotes -1)" ]; then
    info '\tExisting non pushed commit(s), amending'
    commit_one "$1" --amend || return # Amend only if there’s unpushed commits
  else
    info '\tAll commits pushed, no one to amend, create new commit instead'
    commit_one "$1" || return # Create new commit instead
  fi
  commit_msg=$(git -C "$1" log -1 --pretty=format:%s)
  commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on message
  state '\tCommit type (edited interactively): "%s"' "$commit_type"
}

amend_both() { # Amend both public and private config
  info 'Public: Amend flake repository'
  if amend_one "$PUBLIC_LOC"; then # May amend the public flake
    info 'Private: Update flake %s inputs' $PRIVATE_LOC
    nix flake update --flake $PRIVATE_LOC # Update private’s public flake input
  fi
  info 'Private: Amend flake repository'
  amend_one "$PRIVATE_LOC" # Amend (if possible) or commit the private flake
}

rebuild_system_cmd() { # Rebuild the NixOS system
  info 'Mount /boot before system update'
  sudo mount -v /boot || exit # Use fstab
  NIXOS_REBUILD_CMD="$NIXOS_REBUILD_CMD --flake $PRIVATE_LOC"
  info 'NixOS system rebuild: "%s"' "$NIXOS_REBUILD_CMD"
  if $NIXOS_REBUILD_CMD switch; then
    info 'Unmount /boot after update'
    sudo umount -v /boot # Unmount for security
  else
    info 'Failed update, unmount /home'
    sudo umount -v /boot # Unmount for security
    return 1             # Failed update status
  fi
}

rebuild_home_cmd() { # Rebuild the Home Manager home
  # info 'Remove .config/mimeapps.list'
  # rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it
  HOME_MANAGER_CMD="$HOME_MANAGER_CMD --flake $PRIVATE_LOC"
  info 'Home Manager home rebuild: "%s"' "$HOME_MANAGER_CMD"
  $HOME_MANAGER_CMD switch || return
}

rebase_both() { # Git rebase both public and private configs
  info 'Public: Rebase flake repository'
  git -C $PUBLIC_LOC rebase -i
  info 'Private: Rebase flake repository'
  msg=$(git -C $PUBLIC_LOC log --branches --not --remotes -1 --pretty=format:%s)
  if [ -n "$msg" ] || # If public and private repos have unpushed commit(s),
    [ -n "${git-C $PRIVATE_LOC log --branches --not --remotes}" ]; then
    # Mirror last public’s Git commit message on private’s last commit
    git -C $PRIVATE_LOC commit --amend --message "$msg"
  fi
  git -C $PRIVATE_LOC rebase -i
}

push_both() { # Git push both public and private configs
  info 'Public & Private: Pushing flake repository (asynchronously)'
  git -C $PUBLIC_LOC push &
  git -C $PRIVATE_LOC push &
}

# Test if we are in the correct directory
if ! [ -d $PUBLIC_LOC ] || ! [ -d $PRIVATE_LOC ]; then
  printf 'This script should be executed from a directory'
  printf 'with private and public configuration sub-directories'
  exit 2
fi

update_inputs=false     # Whether to update flake inputs
commit_msg=''           # Message to be constructed with remaining arguments
commit_type=''          # Type of commit, new feature, bugfix…
push_repositories=false # Whether to push the Git repositories after update
power_state=''          # Whether to suspend, turn off or reboot the computer
while [ "$#" -gt 0 ]; do
  case "$1" in
  h | help | -h | --help)
    show_help # Directly show help message…
    exit      # and exit right after
    ;;
  c | d | cd) # Directly open default shell into current working directory
    info 'You can exit the shell to get back to previous working directory'
    if [ "$2" = "public" ] || [ "$2" = "private" ]; then
      cd "$2" || exit # cd into sub-directory
    fi
    exec $SHELL # Execute the default shell at the WD of this script
    ;;
  l | log | logs | stat | stats | status) # Show Git logs and status
    public_logs_status                    # Directly show Git logs and status
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
  *) # Append any other arguments to the Git commit message
    commit_msg=$(echo "$*" | sed 's/^\s*//' | sed 's/\s*$//')
    # Also clean commit message (remove start and end whitespaces)
    break # The loop should stop anyway, but quicker
    ;;
  esac
  shift # Next argument
done
state 'Rebuild Home Manager home: %s' $rebuild_home
info 'Initial state based on arguments'
state 'Update Flake inputs: %s' $update_inputs
state 'Rebuild NixOS system (explicitly): %s' $rebuild_system
state 'Commit message: "%s"' "$commit_msg"
commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on its message
state 'Commit type: "%s"' "$commit_type"
state 'Push Git repositories: %s' $push_repositories
state 'Power state change: "%s"\n' $power_state

pull_both # Always pull the latest configuration before doing anything
if $update_inputs; then
  update_inputs
fi
# Always edit and commit if commit message is not empty
if [ -n "$commit_msg" ]; then
  info 'Start default text editor'
  $EDITOR .                 # Edit the configuration before commiting,
  commit_both "$commit_msg" # then commit public and private flakes
else                        # Defaults to try amending changes
  if [ $update_inputs = false ] && [ $push_repositories = false ]; then
    cfg_edit # Edit the configuration if not doing other things explicitly
  fi
  amend_both # Amend or commit public and private flakes
fi
if $rebuild_system; then     # Always rebuild system if explicitly set
  rebuild_system_cmd || exit # Don’t continue if the build failed
fi
if $rebuild_home && # Rebuild home/ if new feat or a fix commit
  { [ "$commit_type" = 'feat' ] || [ "$commit_type" = 'fix' ]; }; then
  rebuild_home_cmd || exit # Don’t continue if the build failed
fi
if $push_repositories; then # Push repositories if explicit argument
  # Rebase interactively before pushing, if not doing any other operations
  if [ $rebuild_system = 'false' ] && [ $rebuild_home = 'false' ] &&
    [ $update_inputs = 'false' ] &&
    [ -z "$commit_msg" ] && [ -z "$power_state" ]; then
    rebase_both
  fi
  push_both # Push public and private repositories in the background
fi
if [ -n "$power_state" ]; then # Change power state after other operations
  wait                         # Wait for eventual push to finish
  systemctl $power_state
fi
