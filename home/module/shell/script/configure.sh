# TODO make this script a package available in this flake’s nix dev environment

# This script allows to easily manage a two-flakes system & home Nix config,
# with one private config having as single input one public config,
# which contains most of the configurations
RESOURCE_LIMIT='systemd-run --scope -p MemoryHigh=66%'
# -p CPUQuota=888%' # Also limit CPU usage (Nix already limits to 8 threads)
NIXOS_REBUILD_CMD="systemd-inhibit sudo $RESOURCE_LIMIT nixos-rebuild"
HOME_MANAGER_CMD='systemd-inhibit home-manager' # Set default params here

# Global CONSTANTS
# SYSTEM_LOC='./system' # System (NixOS) configuration
HOME_LOC='./home'       # Home (Home Manager) config
PRIVATE_LOC='./private' # Private configuration location
PUBLIC_LOC='./public'   # Public configuration location
# Global variables
home_changed=false # Have changes been made to home config
commit_msg=''      # Message to be constructed with remaining arguments
commit_type=''     # Type of commit, new feature, bugfix…

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

# Stylized (italic and bold) printing for state change and config information
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

# Show public configuration Git logs and status
public_logs_status() {
  git -C $PUBLIC_LOC log --oneline || exit
  git -C $PUBLIC_LOC status || exit
}

# @param 1 sub-directory containing Git repo to pull (./public or ./private)
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

# Git pull both private and public config
pull_both() {
  info 'Public & Private: Pulling latest changes (asynchronously)'
  pull_one $PUBLIC_LOC &
  pull_one $PRIVATE_LOC &
  wait # Wait for background pulls to finish before moving ong
}

# Update (public) config flake inputs
update_inputs_cmd() {
  info 'Public: Update flake %s inputs' $PUBLIC_LOC
  nix flake update --flake $PUBLIC_LOC --commit-lock-file
  # Test if the last commit is an unpushed lockfile update
  # msg=$(git -C $PUBLIC_LOC log --branches --not --remotes -1 --pretty=format:%s)
}

# Return 0 if there are uncommited changes, 1 otherwise
# @param 1 sub-directory containing Git repo to test (./public or ./private)
# @param * eventual sub-directories to which restrict the test for changes
has_repo_changed() {
  repo_path="$1" # Location of Git repository
  shift          # Remove $1 (repo path) from $@
  [ -n "$(git -C "$repo_path" diff "$@")" ]
}

# Return the state of the commit
# @param 1 sub-directory containing Git repo to commit (./public or ./private)
# @param * remaining parameters passed to Git (--amend, --message <string>)
commit_all() {   # Commit $1 config with message $2
  repo_path="$1" # Location of Git repository
  shift          # Remove $1 (repo path) from $@
  git -C "$repo_path" diff
  if [ -d "$repo_path/$HOME_LOC" ]; then
    if has_repo_changed "$repo_path" $HOME_LOC flake.nix flake.lock; then
      home_changed=true # Rebuild home as changes have been made
      state '\tChanges made in %s configuration' $HOME_LOC
    fi
  fi
  # Commit all the changes
  info '\t❯ git -C %s add --verbose .' "$repo_path"
  git -C "$repo_path" add --verbose .
  info '\t❯ git -C %s commit %s' "$repo_path" "$@"
  git -C "$repo_path" commit --verbose "$@" || return
}

# @param 1 Git commit message
commit_public_private() { # Git commit both private and public config
  info 'Public: Commit flake repository'
  if commit_all $PUBLIC_LOC --message "$1"; then # Commit the public flake
    info 'Private: Update flake %s inputs' $PRIVATE_LOC
    nix flake update --flake $PRIVATE_LOC # Update private’s public flake input
  fi
  info 'Private: Commit flake repository (including public input update)'
  commit_all $PRIVATE_LOC --message "$1" # Commit the private flake
}

# Add changes made in a Git repo to the last commit, but
# - Fails (return 1) if there are no changes to be added to the last commit
# - Redirect to commit_all() if commits already pushed, to prevent conflicts
# @param 1 sub-directory containing Git repo to amend (./public or ./private)
protected_amend() { # Amend public or private config
  if ! has_repo_changed "$1"; then
    info '\tNo non commited changes, not amending'
    return 1 # There are no changes to amend, makes no sense, fail
  fi
  if [ -n "$(git -C "$1" log --branches --not --remotes -1)" ]; then
    info '\tLast commit is not pushed, amending'
    commit_all "$1" --amend || return # Only if unpushed commits
  else
    info '\tAll commits pushed, no one to amend, create new commit instead'
    commit_all "$1" || return # Create new commit instead
  fi
}

# @param 1 sub-directory containing Git repo to commit (./public or ./private)
last_commit_msg() {
  commit_msg=$(git -C "$1" log -1 --pretty=format:%s)
  commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on message
  state '\tCommit type (edited interactively): "%s"' "$commit_type"
}

amend_public_private() { # Amend both public and private config
  info 'Public: Amend flake repository'
  if protected_amend "$PUBLIC_LOC"; then # May amend the public flake
    last_commit_msg $PUBLIC_LOC          # Set commit msg to the last one
    info 'Private: Update flake %s inputs' $PRIVATE_LOC
    nix flake update --flake $PRIVATE_LOC # Update private’s public flake input
  fi
  info 'Private: Amend flake repository'
  protected_amend "$PRIVATE_LOC" # Amend or commit the private flake if needed
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

rebase_public_private() { # Git rebase both public and private configs
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

push_public_private() { # Git push both public and private configs
  # info 'Public & Private: Will push flake repository (asynchronously)'
  info 'Public & Private: Push flake repository'
  # info 'You have THREE (3) SECONDS to cancel the git push with CTRL+C'
  # sleep 3 || exit # Give the user 3 seconds to cancel the push if needed
  git -C $PUBLIC_LOC push
  git -C $PRIVATE_LOC push
}

# Test if we are in the correct directory
if ! [ -d $PUBLIC_LOC ] || ! [ -d $PRIVATE_LOC ]; then
  info 'This script should be executed from a directory with
  private and public configuration sub-directories'
  exit 2
fi

update_inputs=false     # Whether to update flake inputs
rebuild_system=false    # Has the user explicitly asked to rebuild the system
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
state 'Update Flake inputs: %s' $update_inputs
state 'Rebuild NixOS system: %s' $rebuild_system
state 'Commit message: "%s"' "$commit_msg"
commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on its message
state 'Commit type: "%s"' "$commit_type"
state 'Push Git repositories: %s' $push_repositories
state 'Power state change: "%s"\n' $power_state

pull_both # Always pull the latest configuration before doing anything
if $update_inputs; then
  update_inputs_cmd
fi
# Always edit and commit if commit message is not empty
if [ -n "$commit_msg" ]; then
  info 'Start default text editor'
  direnv exec . $EDITOR .             # Edit the configuration before commiting,
  commit_public_private "$commit_msg" # then commit public and private flakes
else                                  # Defaults to try amending changes
  if [ $update_inputs = false ] && [ $push_repositories = false ]; then
    info 'Start default text editor'
    direnv exec . $EDITOR . # Edit the configuration if not doing other tasks
  fi
  amend_public_private # Amend or commit public and private flakes
fi
if $rebuild_system; then     # Always rebuild system if explicitly set
  rebuild_system_cmd || exit # Don’t continue if the build failed
fi
# Rebuild home/ if
# - It was changed for a new feature of a bugfix
# - Flake inputs are updated
if [ $home_changed = true ] &&
  { [ "$commit_type" = feat ] || [ "$commit_type" = fix ]; } ||
  [ $update_inputs = true ]; then
  rebuild_home_cmd || exit # Don’t continue if the build failed
fi
if $push_repositories; then # Push repositories if explicit argument
  # Rebase interactively before pushing, if not doing any other operations
  if [ $rebuild_system = false ] && [ $home_changed = false ] &&
    [ $update_inputs = false ] &&
    [ -z "$commit_msg" ] && [ -z "$power_state" ]; then
    rebase_public_private
  fi
  push_public_private # Push public and private repositories in the background
fi
if [ -n "$power_state" ]; then # Change power state after other operations
  wait                         # Wait for eventual push to finish
  systemctl $power_state
fi
