#!/bin/sh

set -eu
IMPORTANT="$HOME/author $HOME/collect"
ARCHIVE="$HOME/shelve"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
EXCLUDE_COMMON="$CONFIG/backup-exclude/common"
EXCLUDE_IMG="$CONFIG/backup-exclude/img"
LAST_RESTIC_REPO=""
ARCHIVE_BACKED_UP="" # Only offer to clean ARCHIVE once it has been saved
BG_PIDS=""           # Background jobs (cloud syncs) to wait for
FAILED=0
STTY_SAVE=""
INHIBIT_PID=""

_usage() {
  cat <<EOF
Usage: $(basename "$0") <destination> [cloud_destinations...]

  *drive* <remote>...        rclone sync IMPORTANT, copy ARCHIVE to each remote
  *back* <repo> [remote]...  restic backup IMPORTANT + ARCHIVE to <repo>,
                             then rclone sync the repo to each remote
  <path>                     rsync IMPORTANT to <path>
EOF
}

_cleanup() {
  [ -n "$STTY_SAVE" ] && stty "$STTY_SAVE" 2>/dev/null
  [ -n "$INHIBIT_PID" ] && kill "$INHIBIT_PID" 2>/dev/null
  return 0
}

# Hold one inhibitor lock for the whole script lifetime
# tail --pid makes it release itself even if this script gets SIGKILLed
_inhibit_start() {
  systemd-inhibit --what="shutdown:sleep:handle-lid-switch" --who="backup.sh" \
    --why="Backup started at $(date +%R) in progress" \
    tail --pid=$$ -f /dev/null &
  INHIBIT_PID=$!
}

_rsync() {
  rsync --verbose --archive --human-readable --partial --progress \
    --exclude-from="$EXCLUDE_COMMON" --exclude-from="$EXCLUDE_IMG" "$@"
}

_restic() {
  repo="$1"
  shift
  LAST_RESTIC_REPO="$repo"
  restic --repo "$repo" --verbose --pack-size=128 backup --exclude-caches \
    --exclude-file="$EXCLUDE_COMMON" "$@"
}

# Ask restic password once, reuse it for backup and check
_restic_password() {
  [ -n "${RESTIC_PASSWORD:-}${RESTIC_PASSWORD_FILE:-}${RESTIC_PASSWORD_COMMAND:-}" ] && return 0
  [ -t 0 ] || return 0 # Let restic handle it
  printf "Restic password for %s: " "$1"
  stty -echo
  IFS= read -r RESTIC_PASSWORD
  stty echo
  echo
  export RESTIC_PASSWORD
}

_prompt() {
  [ -t 0 ] || return 1 # Non-interactive: default to No
  printf "\n%s (y/N, 25s timeout): " "$1"
  stty -icanon min 0 time 250
  res=$(dd bs=1 count=1 2>/dev/null)
  stty "$STTY_SAVE"
  echo
  case "$res" in [yY]*) return 0 ;; *) return 1 ;; esac
}

# Accept both "remote" and "remote:" forms
_remote() {
  case "$1" in
  *:) printf "%s%s" "$1" "$2" ;;
  *) printf "%s:%s" "$1" "$2" ;;
  esac
}

# Nearest existing ancestor, so df works before the destination exists
_existing() {
  p="$1"
  while [ ! -e "$p" ]; do p=$(dirname "$p"); done
  printf "%s" "$p"
}

_bg() {
  "$@" &
  BG_PIDS="$BG_PIDS $!"
}

_wait_bg() {
  for pid in $BG_PIDS; do
    wait "$pid" || FAILED=$((FAILED + 1))
  done
  BG_PIDS=""
}

case "${1:-}" in
"" | -h | --help)
  _usage
  [ -n "${1:-}" ] || exit 1
  exit 0
  ;;
esac

[ -t 0 ] && STTY_SAVE=$(stty -g)
trap _cleanup EXIT
trap 'exit 130' INT TERM HUP
_inhibit_start

case "$1" in
*drive*)
  stamp=$(date +%Y-%m-%d-%H)
  for dest in "$@"; do
    printf "Starting backup to %s\n" "$dest"
    for dir in $IMPORTANT; do
      dirname=$(basename "$dir")
      rclone sync --progress \
        --exclude-from="$EXCLUDE_COMMON" --exclude-from="$EXCLUDE_IMG" \
        --backup-dir "$(_remote "$dest" "$USER-trash/$stamp/$dirname")" \
        "$dir" "$(_remote "$dest" "$USER-back/$dirname")"
    done
    for dir in $ARCHIVE; do
      dirname=$(basename "$dir")
      rclone copy --progress \
        --exclude-from="$EXCLUDE_COMMON" --exclude-from="$EXCLUDE_IMG" \
        "$dir" "$(_remote "$dest" "$USER-back/archive/$dirname")"
    done
    printf "Finished backup to %s\n" "$dest"
  done
  ARCHIVE_BACKED_UP=1
  ;;
*back*)
  local_repo="$1"
  shift
  # Values in KiB; restic deduplicates so this is a pessimistic estimate
  avail=$(df -k --output=avail "$(_existing "$local_repo")" | tail -n1 | tr -d ' ')
  # shellcheck disable=SC2086
  used=$(du -skc $IMPORTANT $ARCHIVE 2>/dev/null | tail -n1 | cut -f1)
  printf "Available: %s MiB, Needed (max): %s MiB\n" \
    "$((avail / 1024))" "$((used / 1024))"

  if [ "$avail" -gt "$used" ]; then
    _restic_password "$local_repo"
    if [ ! -f "$local_repo/config" ]; then
      if _prompt "No restic repo at $local_repo, initialize one?"; then
        restic --repo "$local_repo" init
      else
        printf "Aborting\n"
        exit 1
      fi
    fi
    printf "Backing up incrementally to %s (restic)\n" "$local_repo"
    # shellcheck disable=SC2086
    _restic "$local_repo" $IMPORTANT $ARCHIVE
    ARCHIVE_BACKED_UP=1
    for drive_dest in "$@"; do
      printf "Syncing restic repo to %s\n" "$drive_dest"
      case "$drive_dest" in
      *proton* | *pdrive*) flags="--transfers 1 --checkers 1 --tpslimit 1 --retries 20 --low-level-retries 10 --protondrive-replace-existing-draft" ;;
      *) flags="--fast-list --drive-chunk-size 128M" ;;
      esac
      # shellcheck disable=SC2086
      _bg rclone sync --verbose --stats 30s $flags \
        "$local_repo" "$(_remote "$drive_dest" "$USER-restic")"
    done
    [ -n "$BG_PIDS" ] && printf "Cloud syncs backgrounded.\n"
  else
    printf "Space low on %s. Using rsync fallback (ARCHIVE not included).\n" "$local_repo"
    # shellcheck disable=SC2086
    _rsync --exclude="*.large" $IMPORTANT "$local_repo/"
  fi
  ;;
*)
  printf "Backing up %s to %s\n" "$IMPORTANT" "$1"
  # shellcheck disable=SC2086
  _rsync $IMPORTANT "$1/"
  ;;
esac

# Check runs while cloud syncs are still going (restic check is read-only)
if [ -n "$LAST_RESTIC_REPO" ]; then
  if _prompt "Run restic check to verify integrity?"; then
    restic --repo "$LAST_RESTIC_REPO" check --read-data-subset=2% ||
      FAILED=$((FAILED + 1))
  fi
fi

_wait_bg

if [ "$FAILED" -gt 0 ]; then
  printf "\n%s step(s) failed, archive cleanup disabled\n" "$FAILED" >&2
  exit 1
fi

if [ -z "$ARCHIVE_BACKED_UP" ]; then
  printf "Archive was not backed up, cleanup skipped\n"
elif _prompt "Clean archive directories?"; then
  printf "Trashing archive contents...\n"
  for dir in $ARCHIVE; do
    [ -d "$dir" ] || continue
    find "$dir/" -maxdepth 1 -mindepth 1 \
      ! -name '.stfolder' ! -name '.stignore' \
      ! -name 'stignore' ! -name 'stignore.light' \
      -exec trash --verbose {} +
  done
else
  printf "Cleanup skipped\n"
fi
