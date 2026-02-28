#!/bin/sh
set -eu
IMPORTANT="$HOME/life $HOME/project $HOME/.graph"
ARCHIVE="$HOME/archive/life $HOME/archive/project"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
EXCLUDE_COMMON="$CONFIG/backup-exclude/common"
EXCLUDE_IMG="$CONFIG/backup-exclude/img"
LAST_RESTIC_REPO=""

_inhibit() {
  systemd-inhibit --what=shutdown:sleep --who="backup.sh" --why="Backup in progress" "$@"
}

_rsync() {
  _inhibit rsync --verbose --archive --human-readable --partial --progress \
    --exclude-from="$EXCLUDE_COMMON" --exclude-from="$EXCLUDE_IMG" "$@"
}

_restic() {
  repo="$1"
  shift
  LAST_RESTIC_REPO="$repo"
  _inhibit restic --repo "$repo" --verbose backup --exclude-caches \
    --exclude-file="$EXCLUDE_COMMON" "$@" --pack-size=128
  # Maintenance: Keep a sensible history
  _inhibit restic --repo "$repo" forget --keep-last 10 --keep-daily 7 --keep-monthly 12 --prune
}

_prompt() {
  printf "\n%s (y/N, 5s timeout): " "$1"
  stty_save=$(stty -g)
  stty -icanon min 0 time 50
  res=$(dd bs=1 count=1 2>/dev/null)
  stty "$stty_save"
  echo
  case "$res" in [yY]*) return 0 ;; *) return 1 ;; esac
}

case "${1:-}" in
*drive*)
  for dest in "$@"; do
    printf "Starting backup to %s\n" "$dest"
    for dir in $IMPORTANT; do
      dirname=$(basename "$dir")
      rclone sync --progress \
        --exclude-from="$EXCLUDE_COMMON" --exclude-from="$EXCLUDE_IMG" \
        --backup-dir "$dest:$USER-trash/$(date +%Y-%m-%d-%H)/$dirname" \
        "$dir" "$dest:$USER-back/$dirname"
    done
    for dir in $ARCHIVE; do
      dirname=$(basename "$dir")
      rclone copy --progress \
        --exclude-from="$EXCLUDE_COMMON" --exclude-from="$EXCLUDE_IMG" \
        "$dir" "$dest:$USER-back/archive/$dirname"
    done
    printf "Finished backup to %s\n" "$dest"
  done
  ;;
*back*)
  avail=$(df -k --output=avail "$1" | tail -n1)
  used=$(du -skc $IMPORTANT | tail -n1 | cut -f1)
  printf "Available: %sB, Used: %sB\n" "$avail" "$used"

  if [ "$avail" -gt "$used" ]; then
    printf "Backing up incrementally to %s (restic)\n" "$1"
    _restic "$1" $IMPORTANT $ARCHIVE
    local_repo="$1"
    shift
    for drive_dest in "$@"; do
      printf "Syncing restic repo to %s\n" "$drive_dest"
      case "$drive_dest" in
      *proton* | *pdrive*) flags="--protondrive-replace-existing-draft --transfers 1 --retries 5" ;;
      *) flags="--fast-list --drive-chunk-size 128M" ;;
      esac
      case "$drive_dest" in
      *:) rclone_dest="$drive_dest$USER-restic" ;;
      *) rclone_dest="$drive_dest:$USER-restic" ;;
      esac
      rclone sync --progress $flags "$local_repo" "$rclone_dest" &
    done
    printf "Cloud syncs backgrounded.\n"
  else
    printf "Space low on %s. Using rsync fallback.\n" "$1"
    _rsync --exclude="*.large" $IMPORTANT "$1/"
  fi
  ;;
*)
  if [ -z "${1:-}" ]; then
    printf "Usage: %s <destination_path> [cloud_destinations...]\n" "$0"
    exit 1
  fi
  printf "Backing up %s to %s\n" "$IMPORTANT" "$1"
  _rsync $IMPORTANT "$1/"
  ;;
esac

wait
if [ -n "$LAST_RESTIC_REPO" ]; then
  if _prompt "Run restic check to verify integrity?"; then
    _inhibit restic --repo "$LAST_RESTIC_REPO" check --read-data-subset=2%
  fi
fi

if _prompt "Clean archive directories?"; then
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
