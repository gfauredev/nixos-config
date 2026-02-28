#!/bin/sh
set -eu

# Directories directly under user $HOME
IMPORTANT="$HOME/life $HOME/project $HOME/.graph"
ARCHIVE="$HOME/archive/life $HOME/archive/project"
# BOOTABLE="$HOME/data/operatingSystems.large" # TODO: Integrate when needed

_inhibit() {
  systemd-inhibit --what=shutdown:sleep --who="backup.sh" --why="Backup in progress" "$@"
}

_rsync() {
  _inhibit rsync --verbose --archive --human-readable --partial --progress \
    --exclude-from="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/common" \
    --exclude-from="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/img" "$@"
}

_restic() {
  repo="$1"
  shift
  _inhibit restic --repo "$repo" --verbose backup --exclude-caches \
    --exclude-file="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/common" "$@" \
    --pack-size=128
  
  # Maintenance: Keep a sensible history
  _inhibit restic --repo "$repo" forget --keep-last 10 --keep-daily 7 --keep-monthly 12 --prune
}

case "${1:-}" in
*drive*)
  for dest in "$@"; do
    printf "Starting backup to %s\n" "$dest"
    for dir in $IMPORTANT; do
      dirname=$(basename "$dir")
      rclone sync --progress \
        --exclude-from="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/common" \
        --exclude-from="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/img" \
        --backup-dir "$dest:$USER-trash/$(date +%Y-%m-%d-%H)/$dirname" \
        "$dir" "$dest:$USER-back/$dirname"
    done
    for dir in $ARCHIVE; do
      dirname=$(basename "$dir")
      rclone copy --progress \
        --exclude-from="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/common" \
        --exclude-from="${XDG_CONFIG_HOME:-$HOME/.config}/backup-exclude/img" \
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

    LOCAL_REPO="$1"
    shift

    for drive_dest in "$@"; do
      printf "Syncing restic repo to %s\n" "$drive_dest"
      case "$drive_dest" in
      *proton*: | *pdrive*:)
        rclone sync --progress --protondrive-replace-existing-draft --transfers 1 --retries 5 "$LOCAL_REPO" "$drive_dest$USER-restic" &
        ;;
      *proton* | *pdrive*)
        rclone sync --progress --protondrive-replace-existing-draft --transfers 1 --retries 5 "$LOCAL_REPO" "$drive_dest:$USER-restic" &
        ;;
      *:)
        rclone sync --progress --fast-list --drive-chunk-size 128M "$LOCAL_REPO" "$drive_dest$USER-restic" &
        ;;
      *drive*)
        rclone sync --progress --fast-list --drive-chunk-size 128M "$LOCAL_REPO" "$drive_dest:$USER-restic" &
        ;;
      esac
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
  # Default/Bootable behavior
  printf "Backing up %s to %s\n" "$IMPORTANT" "$1"
  _rsync $IMPORTANT "$1/"
  ;;
esac

wait

printf "\nClean archive directories? (y/N, 5s timeout): "
shouldClean="n"

# Use 'timeout' utility (standard on Linux) to wrap the 'read' command
if command -v timeout >/dev/null 2>&1; then
  # We read from /dev/tty to ensure input is captured correctly
  if timeout 5 sh -c 'read -r response < /dev/tty; case "$response" in [yY]*) exit 0 ;; *) exit 1 ;; esac'; then
    shouldClean="y"
  fi
else
  # Fallback for systems without 'timeout'
  read -r response
  case "$response" in [yY]*) shouldClean="y" ;; esac
fi

if [ "$shouldClean" = "y" ]; then
  printf "Trashing archive contents...\n"
  for dir in $ARCHIVE; do
    [ -d "$dir" ] || continue
    find "$dir/" -maxdepth 1 -mindepth 1 -not -name '.stfolder' \
      -not -name '.stignore' -not -name 'stignore' -not -name 'stignore.light' \
      -exec trash --verbose {} +
  done
fi
