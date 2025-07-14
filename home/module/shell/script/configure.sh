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
HOME_LOC='./home/'       # Home (Home Manager) config
PRIVATE_LOC='./private/' # Private configuration location
PUBLIC_LOC='./public/'   # Public configuration location
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
emph() {
  printf '\033[3m' # Start italic
}
strong() {
  printf '\033[1m' # Start bold
}
std() {
  printf '\033[0m' # Standard text, remove any style
}

# Show public configuration Git logs and status
public_logs_status() {
  git -C $PUBLIC_LOC log --oneline || exit
  git -C $PUBLIC_LOC status || exit
}

# @param 1 sub-directory containing Git repo to pull (./public or ./private)
pull_one() { # Git pull private or public config
  remote=$(git -C "$1" remote get-url origin | cut -d'@' -f2 | cut -d':' -f1)
  emph # Italic text
  printf 'Test if remote %s is reachable (in less than %ss)\n' "$remote" 3
  if ping -c 1 -w 3 "$remote"; then
    printf '%s reached, pull latest changes from it\n' "$remote"
    git -C "$1" pull
  else
    printf '%s non reachable, move on\n' "$remote"
  fi
  std # Return to normal text
}

# Git pull both private and public config
pull_both() {
  emph # Italic text
  printf 'Public & Private: Pulling latest changes (asynchronously)\n'
  std # Normal text
  pull_one $PUBLIC_LOC &
  pull_one $PRIVATE_LOC &
  wait # Wait for background pulls to finish before moving ong
}

# Update (public) config flake inputs
update_inputs_cmd() {
  emph # Italic text
  printf 'Public: Update flake %s inputs\n' $PUBLIC_LOC
  std
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
  # git -C "$repo_path" diff # FIXME Opens a pager: needs interaction
  # TODO set home_changed when amending changes too
  if has_repo_changed "$repo_path" $HOME_LOC; then
    home_changed=true # Rebuild home as changes have been made
    strong            # Bold text
    printf '\tChanges made in %s configuration\n' $HOME_LOC
    std # Standard text
  # elif [ -d "$repo_path/$HOME_LOC" ]; then
  elif has_repo_changed "$repo_path" flake.nix flake.lock; then
    home_changed=true # Rebuild home as changes have been made
    strong            # Bold text
    printf '\tChanges made in flake.nix / flake.lock\n'
    std # Standard text
  fi
  # Commit all the changes
  emph # Italic text
  printf '\t❯ git -C %s add --verbose .\n' "$repo_path"
  std
  git -C "$repo_path" add --verbose .
  emph # Italic text
  printf '\t❯ git -C %s commit %s\n' "$repo_path" "$*"
  std
  git -C "$repo_path" commit --verbose "$@" || return
}

# @param 1 Git commit message
commit_public_private() { # Git commit both private and public config
  emph
  printf 'Public: Commit flake repository\n'
  std
  if commit_all $PUBLIC_LOC --message "$1"; then # Commit the public flake
    emph
    printf 'Private: Update flake %s inputs\n' $PRIVATE_LOC
    std
    nix flake update --flake $PRIVATE_LOC # Update private’s public flake input
  fi
  emph
  printf 'Private: Commit flake repository (including public input update)\n'
  std
  commit_all $PRIVATE_LOC --message "$1" # Commit the private flake
}

# Add changes made in a Git repo to the last commit, but
# - Fails (return 1) if there are no changes to be added to the last commit
# - Redirect to commit_all() if commits already pushed, to prevent conflicts
# @param 1 sub-directory containing Git repo to amend (./public or ./private)
protected_amend() { # Amend public or private config
  if ! has_repo_changed "$1"; then
    emph
    printf '\tNo non commited changes, not amending\n'
    std
    return 1 # There are no changes to amend, makes no sense, fail
  fi
  if [ -n "$(git -C "$1" log --branches --not --remotes -1)" ]; then
    emph
    printf '\tLast commit is not pushed, amending\n'
    std
    commit_all "$1" --amend || return # Only if unpushed commits
  else
    emph
    printf '\tAll commits pushed, no one to amend, create new commit instead\n'
    std
    commit_all "$1" || return # Create new commit instead
  fi
}

# @param 1 sub-directory containing Git repo to commit (./public or ./private)
last_commit_msg() {
  commit_msg=$(git -C "$1" log -1 --pretty=format:%s)
  commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on message
  strong                             # Bold text
  printf '\tCommit type (edited interactively): "%s"\n' "$commit_type"
  std # Standard text
}

amend_public_private() { # Amend both public and private config
  emph
  printf 'Public: Amend flake repository\n'
  std
  if protected_amend "$PUBLIC_LOC"; then # May amend the public flake
    last_commit_msg $PUBLIC_LOC          # Set commit msg to the last one
    emph
    printf 'Private: Update flake %s inputs\n' $PRIVATE_LOC
    std
    nix flake update --flake $PRIVATE_LOC # Update private’s public flake input
  fi
  emph
  printf 'Private: Amend flake repository\n'
  std
  protected_amend "$PRIVATE_LOC" # Amend or commit the private flake if needed
}

rebuild_system_cmd() { # Rebuild the NixOS system
  emph
  printf 'Mount /boot before system update\n'
  std
  sudo mount -v /boot || exit # Use fstab
  cd $PRIVATE_LOC || exit
  NIXOS_REBUILD_CMD="$NIXOS_REBUILD_CMD --flake . switch"
  emph
  printf 'NixOS system rebuild: "%s"\n' "$NIXOS_REBUILD_CMD"
  std
  if $NIXOS_REBUILD_CMD; then
    emph
    printf 'Unmount /boot after update\n'
    std
    sudo umount -v /boot # Unmount for security
    cd .. || exit
  else
    emph
    printf 'Failed update, unmount /home\n'
    std
    sudo umount -v /boot # Unmount for security
    cd .. || exit
    return 1 # Failed update status
  fi
}

rebuild_home_cmd() { # Rebuild the Home Manager home
  # emph
  # printf 'Remove .config/mimeapps.list'
  # std
  # rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it
  HOME_MANAGER_CMD="$HOME_MANAGER_CMD --flake $PRIVATE_LOC switch"
  emph
  printf 'Home Manager home rebuild: "%s"\n' "$HOME_MANAGER_CMD"
  std
  $HOME_MANAGER_CMD || return
}

rebase_public_private() { # Git rebase both public and private configs
  emph
  printf 'Public: Rebase flake repository\n'
  std
  git -C $PUBLIC_LOC rebase -i
  emph
  printf 'Private: Rebase flake repository\n'
  std
  msg=$(git -C $PUBLIC_LOC log --branches --not --remotes -1 --pretty=format:%s)
  if [ -n "$msg" ] || # If public and private repos have unpushed commit(s),
    [ -n "${git-C $PRIVATE_LOC log --branches --not --remotes}" ]; then
    # Mirror last public’s Git commit message on private’s last commit
    git -C $PRIVATE_LOC commit --amend --message "$msg"
  fi
  git -C $PRIVATE_LOC rebase -i
}

push_public_private() { # Git push both public and private configs
  # emph
  # printf 'Public & Private: Will push flake repository (asynchronously)'
  # std
  emph
  printf 'Public & Private: Push flake repository\n'
  std
  # emph
  # printf 'You have THREE (3) SECONDS to cancel the git push with CTRL+C'
  # std
  # sleep 3 || exit # Give the user 3 seconds to cancel the push if needed
  git -C $PUBLIC_LOC push
  git -C $PRIVATE_LOC push
}

# Test if we are in the correct directory
if ! [ -d $PUBLIC_LOC ] || ! [ -d $PRIVATE_LOC ]; then
  emph
  printf 'This script should be executed from a directory with private and public configuration sub-directories\n'
  std
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
    emph
    printf 'You can exit the shell to get back to previous working directory\n'
    std
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
strong # Bold text
printf 'Update Flake inputs: %s\n' $update_inputs
std    # Standard text
strong # Bold text
printf 'Rebuild NixOS system: %s\n' $rebuild_system
std    # Standard text
strong # Bold text
printf 'Commit message: "%s"\n' "$commit_msg"
std                                # Standard text
commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on its message
strong                             # Bold text
printf 'Commit type: "%s"\n' "$commit_type"
std    # Standard text
strong # Bold text
printf 'Push Git repositories: %s\n' $push_repositories
std    # Standard text
strong # Bold text
printf 'Power state change: "%s"\n' $power_state
std # Standard text

pull_both # Always pull the latest configuration before doing anything
if $update_inputs; then
  update_inputs_cmd
fi
# Always edit and commit if commit message is not empty
if [ -n "$commit_msg" ]; then
  emph
  printf 'Start default text editor\n'
  std
  direnv exec . $EDITOR .             # Edit the configuration before commiting,
  commit_public_private "$commit_msg" # then commit public and private flakes
else                                  # Defaults to try amending changes
  if [ $update_inputs = false ] && [ $push_repositories = false ]; then
    emph
    printf 'Start default text editor\n'
    std
    direnv exec . $EDITOR . # Edit the configuration if not doing other tasks
  fi
  amend_public_private # Amend or commit public and private flakes
fi
if $rebuild_system; then     # Always rebuild system if explicitly set
  rebuild_system_cmd || exit # Don’t continue if the build failed
fi
# Rebuild home/ if
# - It was changed for a new feature or a bugfix
# - Flake inputs were updated FIXME
if [ $home_changed = true ] &&
  { [ "$commit_type" = "feat" ] || [ "$commit_type" = "fix" ]; } ||
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
