# This script allows to easily manage Nix flake system & home configs.
# It supports having a sub flake (eg. public) used as input by the top-level.
# TODO make this script able to install NixOS from live ISO if autodected in
#   this situation; clone the latest config (+ needed Git token)
#   into the writeable /mnt/config and falls back to copying the
#   readonly /etc/config-flake into /mnt/config after a 3s timeout
CPU_LIMIT='cpulimit -l 888'     # Limit CPU usage to 888% accross threads
MEM_LIMIT=$((10 * 1024 * 1024)) # Limit memory usage to 10 Go
NIXOS_REBUILD_CMD="sudo $CPU_LIMIT nixos-rebuild"
HOME_MANAGER_CMD="$CPU_LIMIT home-manager"

# Global CONSTANTS
SUBFLAKE='public' # Sub flake (usually public config) location
HOME_CFG='home'   # Home (Manager) configuration location
# ESP='/boot'     # EFI System Partition
# Global variables
commit_msg=''      # Message to be constructed with remaining arguments
commit_type=''     # Type of commit, new feature, bugfix…
home_changed=false # Have changes been made to home config

show_help() {
  echo "Default: edit the configuration, amend or commit the changes, rebuild."
  echo "The following arguments can be passed in any order."
  echo
  echo "- c[d]:       Open the default shell ($SHELL) in the flake config dir."
  echo "- l[og]:      Display Git logs and status of the configuration’s repo."
  echo "- p[ush]:     Push the Git repositories after sucessful rebuild."
  echo
  echo "- re[build]:  Force home config rebuild even if no edits."
  echo "- s[ystem]:   Rebuild the NixOS system with nixos-rebuild (asks sudo)."
  echo "- u[pdate]:   Update every flake inputs (don’t edit the configuration)."
  echo
  echo "- [--]h[elp]: Show this help message (and exit)."
  echo
  echo "Power state change (last argument superseedes if several):"
  echo "  - [power]off: Turn computer off after all actions."
  echo "  - [re]boot:   Reboot computer after all actions."
  echo "  - sleep|sus:  Suspend computer after all actions."
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
regular() {
  printf '\033[0m' # Standard text, remove any style
}

# Show public configuration Git logs and status
public_logs_status() {
  git -C $SUBFLAKE log --oneline || exit
  git -C $SUBFLAKE status || exit
}

# @param 1 (sub)directory containing Git repo to pull
pull_one() { # Git pull a (sub)directory (eg. private or public config)
  remote=$(git -C "$1" remote get-url origin | cut -d'@' -f2 | cut -d':' -f1)
  emph # Italic text
  printf 'Test if remote %s is reachable (in less than %ss)\n' "$remote" 3
  if ping -c 1 -w 3 "$remote"; then
    printf '%s reached, pull latest changes from it\n' "$remote"
    git -C "$1" pull
  else
    printf '%s non reachable, move on\n' "$remote"
  fi
  regular # Return to normal text
}

ensure_default_branch() {
  printf '%s: Check which branch we use to build\n' "$1"
  current_branch=$(git -C "$1" symbolic-ref --short HEAD 2>/dev/null)
  if [ -z "$current_branch" ]; then
    echo "Result: Detached HEAD state (not on any branch)."
    return 1
  fi
  # Read server’s default branch
  default_branch=$(git -C "$1" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)
  # If origin/HEAD is missing locally, ask git to query/update it
  if [ -z "$default_branch" ]; then
    echo "Querying 'origin', local cache missing default branch ref" >&2
    git -C "$1" remote set-head origin --auto >/dev/null 2>&1
    default_branch=$(git -C "$1" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null)
  fi
  if [ -z "$default_branch" ]; then
    echo "Cannot determine remote default branch (no 'origin' remote?)" >&2
    exit 2
  fi
  # Strip 'refs/remotes/origin/' to get just the branch name
  # POSIX parameter expansion handles this perfectly without needing sed/grep
  default_branch=${default_branch#refs/remotes/origin/}
  echo "Current branch: $current_branch"
  echo "Server default branch: $default_branch"
  if [ "$current_branch" != "$default_branch" ]; then
    printf "WARN: Not on the server’s default branch (%s), but %s!\n" \
      "$default_branch" "$current_branch"
    printf "Press n to cancel rebuild, any other to continue (25s timeout): "
    stty_save=$(stty -g)
    stty -icanon min 0 time 255
    res=$(dd bs=1 count=1 2>/dev/null)
    stty "$stty_save"
    echo
    case "$res" in [nN]*) exit 0 ;; *) return 0 ;; esac
  fi
}

# Pull the current Git repository, recursing into submodules
pull_recurse() { # Git pull private or public config
  emph           # Italic text
  printf 'top-level: Pull latest changes (pulls submodules too)\n'
  regular # Normal text
  remote=$(git remote get-url origin | cut -d'@' -f2 | cut -d':' -f1)
  emph # Italic text
  printf 'Test if remote %s is reachable (in less than %ss)\n' "$remote" 3
  if ping -c 1 -w 3 "$remote"; then
    printf '%s reached, pull latest changes from it\n' "$remote"
    git pull --recurse-submodules=yes
    # ensure_attached_head "$SUBFLAKE" TODO
  else
    printf '%s non reachable, move on\n' "$remote"
  fi
  regular # Return to normal text
}

# Update public config flake inputs
update_subflake_inputs() {
  emph # Italic text
  # ensure_attached_head "$SUBFLAKE" TODO
  regular
  emph # Italic text
  printf '%s: Update flake inputs\n' $SUBFLAKE
  regular
  nix flake update --flake ./$SUBFLAKE --commit-lock-file
  emph # Italic text
  printf 'top-level: Commit Git %s submodule\n' $SUBFLAKE
  regular # TODO ensure submodule is committed everywhere it might be edited
  git commit --message "$SUBFLAKE: Update inputs" $SUBFLAKE
  # Test if the last commit is an unpushed lockfile update
  # msg=$(git -C $PUBLIC_LOC log --branches --not --remotes -1 --pretty=format:%s)
}

# Update top-level config flake inputs
update_toplevel_inputs() {
  emph # Italic text
  printf 'top-level: Update %s flake inputs\n' "$(pwd)"
  regular
  nix flake update # --flake . # Always update top-level Flake submodules inputs
}

# Return 0 if there are uncommited changes, 1 otherwise
# @param 1 (sub)directory containing Git repository to test
# @param * eventual (sub)directories to which restrict the test for changes
has_repo_changed() {
  repo_path="$1" # Location of Git repository
  shift          # Remove $1 (repo path) from $@
  [ -n "$(git -C "$repo_path" diff "$@")" ]
}

# Return the state of the commit
# @param 1 (sub)directory containing Git repository to commit
# @param * remaining parameters passed to Git (--amend, --message <string>)
commit_all_changes() { # Commit $1 config with message $2
  repo_path="$1"       # Location of Git repository
  shift                # Remove $1 (repo path) from $@
  # git -C "$repo_path" diff # FIXME Opens a pager: needs interaction
  # TODO set home_changed when amending changes too
  if has_repo_changed "$repo_path" $HOME_CFG; then
    home_changed=true # Rebuild home as changes have been made
    strong            # Bold text
    printf '\tChanges made in %s configuration\n' $HOME_CFG
    regular # Standard text
  # elif [ -d "$repo_path/$HOME_LOC" ]; then
  elif has_repo_changed "$repo_path" flake.nix flake.lock; then
    home_changed=true # Rebuild home as changes have been made
    strong            # Bold text
    printf '\tChanges made in flake.nix / flake.lock\n'
    regular # Standard text
  fi
  # Commit all the changes
  emph # Italic text
  printf '\t❯ git -C %s add --verbose .\n' "$repo_path"
  regular
  git -C "$repo_path" add --verbose .
  emph # Italic text
  printf '\t❯ git -C %s commit %s\n' "$repo_path" "$*"
  regular
  git -C "$repo_path" commit --verbose "$@" || return
}

# @param 1 Git commit message
commit_all() { # Git commit top-level and submodule flake repositories
  emph         # Italic text
  ensure_default_branch "$SUBFLAKE"
  regular
  emph # Italic text
  printf '%s: Commit flake repository\n' "$SUBFLAKE"
  regular
  if commit_all_changes $SUBFLAKE --message "$1"; then # Commit the sub flake
    git -C $SUBFLAKE push                              # Nix needs it pushed
    update_toplevel_inputs                             # Update changed sub
  fi
  emph
  printf 'top-level: Commit flake repository (including eventual inputs update)\n'
  regular
  commit_all_changes . --message "$1" # Commit the private flake
}

# Add changes made in a Git repo to the last commit, but
# - Fails (return 1) if there are no changes to be added to the last commit
# - Redirect to commit_all() if commits already pushed, to prevent conflicts
# @param 1 (sub)directory containing Git repo to amend
protected_amend() { # Amend top-level or submodule flake repositories
  DIR="$1"
  if [ "$1" = "." ]; then
    DIR="top-level"
  fi
  if ! has_repo_changed "$1"; then
    emph
    printf '%s: No non commited changes, not amending\n' "$DIR"
    regular
    return 1 # There are no changes to amend, makes no sense, fail
  fi
  if [ -n "$(git -C "$1" log --branches --not --remotes -1)" ]; then
    emph
    printf '%s: Last commit is not pushed, amending\n' "$DIR"
    regular
    commit_all_changes "$1" --amend || return # Only if unpushed commits
  else
    emph
    printf '%s: All commits pushed, no one to amend, create new commit instead\n' "$DIR"
    regular
    commit_all_changes "$1" || return # Create new commit instead
  fi
}

# @param 1 sub-directory containing Git repository to commit
extract_last_commit_msg() {
  commit_msg=$(git -C "$1" log -1 --pretty=format:%s)
  commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on message
  strong                             # Bold text
  printf '\tCommit type (edited interactively): "%s"\n' "$commit_type"
  regular # Standard text
}

amend_all() {                          # Amend top-level and submodule flake repositories
  if protected_amend "$SUBFLAKE"; then # May amend the sub flake
    git -C $SUBFLAKE push              # Nix needs the sub flake pushed
    extract_last_commit_msg $SUBFLAKE  # Set commit msg to the last one
    update_toplevel_inputs             # Update private inputs if amending
  fi
  protected_amend .
}

rebuild_system_cmd() { # Rebuild the NixOS system
  # emph
  # printf 'Mount ESP (%s) before system update\n' "$ESP"
  # regular
  # sudo mount -v $ESP || exit # Use fstab
  if [ "$power_state" = "poweroff" ] || [ "$power_state" = "reboot" ]; then
    NIXOS_REBUILD_CMD="$NIXOS_REBUILD_CMD --flake . boot" # Will reboot anyway
  else
    NIXOS_REBUILD_CMD="$NIXOS_REBUILD_CMD --flake . switch"
  fi
  emph
  printf 'NixOS system rebuild: "%s"\n' "$NIXOS_REBUILD_CMD"
  regular
  if ! $NIXOS_REBUILD_CMD; then
    emph
    printf 'Failed update, exiting\n' # , unmount /home\n'
    regular
    return 1 # Failed update status
  fi
  # printf 'Unmount ESP (%s) for security\n' "$ESP"
  # sudo umount -v $ESP # Unmount for security
}

rebuild_home_cmd() { # Rebuild the Home Manager home
  # emph
  # printf 'Remove .config/mimeapps.list'
  # regular
  # rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it
  HOME_MANAGER_CMD="$HOME_MANAGER_CMD --flake . switch -b backup"
  emph
  printf 'Home Manager home rebuild: "%s"\n' "$HOME_MANAGER_CMD"
  regular
  $HOME_MANAGER_CMD || return
}

rebase_all() { # Git rebase top-level and submodule flake repositories
  emph
  printf '%s: Rebase flake repository\n' "$SUBFLAKE"
  regular
  git -C $SUBFLAKE rebase -i
  git -C $SUBFLAKE push & # Nix needs the sub flake repository pushed to build
  emph
  printf 'top-level: Rebase flake repository\n'
  regular
  msg=$(git -C $SUBFLAKE log --branches --not --remotes -1 --pretty=format:%s)
  if [ -n "$msg" ] || # If top and sub repos have unpushed commit(s),
    [ -n "$(git log --branches --not --remotes)" ]; then
    # Mirror last submodule’s Git commit message on top-level’s last commit
    git commit --amend --message "$msg"
  fi
  git rebase -i
}

if ! [ -d $SUBFLAKE ]; then # Test if there is a sub flake (Git submodule)
  emph
  printf 'No Git submodules found in %s\n' "$(pwd)"
  regular
fi

update_inputs=false     # Whether to update flake inputs
rebuild_system=false    # Has the user explicitly asked to rebuild the system
rebuild_home=false      # Has the user explicitly asked to rebuild the home
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
    regular
    if [ -d "$2" ]; then
      cd "$2" || exit # cd into sub-directory
    fi
    exec $SHELL # Execute the default shell in the WD of this script
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
  re | rebuild) # Rebuild the Home Manager home
    rebuild_home=true
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
  boot | reboot) # Restart the system at the end of the script
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

commit_type="${commit_msg%%[(:]*}" # Infer the commit type based on its message

strong # Bold text
printf 'Update Nix Flake inputs: %s\n' $update_inputs
printf 'Rebuild NixOS system: %s\n' $rebuild_system
printf 'Rebuild Home Manager home: %s\n' $rebuild_home
printf 'Commit message: "%s"\n' "$commit_msg"
printf 'Commit type: "%s"\n' "$commit_type"
printf 'Push Git repositories: %s\n' $push_repositories
# regular # Standard text
# strong  # Bold text
printf 'Power state change: "%s"\n' $power_state
regular # Standard text

strong # Bold text
printf 'Limit memory usage to %skb for the following commands\n' $MEM_LIMIT
ulimit -v $MEM_LIMIT # Limit memory usage to $MEM_LIMIT kb
regular              # Back to standard text

pull_recurse # Always pull the latest configuration before doing anything
if $update_inputs; then
  update_subflake_inputs
fi
# Always edit and commit if commit message is not empty
if [ -n "$commit_msg" ]; then
  wait # Wait for eventual pull or push to finish
  emph
  printf 'Start default text editor\n'
  regular
  # FIXME Don’t load the environment properly, LSPs don’t reliably work
  $EDITOR .                # Edit the configuration before commiting,
  commit_all "$commit_msg" # then commit public and private flakes
else                       # Defaults to try amending changes
  if [ $update_inputs = false ] && [ $push_repositories = false ]; then
    wait # Wait for eventual pull or push to finish
    emph
    printf 'Start default text editor\n'
    regular
    direnv exec . $EDITOR . # Edit the configuration if not doing other tasks
  fi
  git -C $SUBFLAKE push # Nix needs it pushed
  amend_all             # Amend or commit public and private flakes
fi
if $rebuild_system; then     # Rebuild system if explicitly set
  wait                       # Wait for eventual pull or push to finish
  rebuild_system_cmd || exit # Don’t continue if the build failed
fi
# Previously, home/ rebuilded if
# - It was changed for a new feature or a bugfix
# - Flake inputs were updated FIXME
# if [ $home_changed = true ] &&
#   { [ "$commit_type" = "feat" ] || [ "$commit_type" = "fix" ]; } ||
#   [ $update_inputs = true ]; then
if $rebuild_home; then     # Only rebuild explicitly to encourage CI/CD builds
  wait                     # Wait for eventual pull or push to finish
  rebuild_home_cmd || exit # Don’t continue if the build failed
fi
if $push_repositories; then # Push repositories if explicit argument
  # Rebase interactively before pushing, if not doing any other operations
  if [ $rebuild_system = false ] && [ $home_changed = false ] &&
    [ $update_inputs = false ] &&
    [ -z "$commit_msg" ] && [ -z "$power_state" ]; then
    rebase_all
  fi
  emph
  printf 'top-level: Push flake repository (pushes submodules too)\n'
  regular
  git push &
fi
if [ -n "$power_state" ]; then # Change power state after other operations
  wait                         # Wait for eventual pull or push to finish
  (
    sleep 1
    systemctl $power_state
  ) & # Bypass systemd-inhibit to change power state
fi
