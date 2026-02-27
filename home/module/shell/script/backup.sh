# Directories directly under user $HOME, as described in module/organization.nix
IMPORTANT="$HOME/life $HOME/project $HOME/.graph" # Always backed up
# BOOTABLE="$HOME/data/operatingSystems.large" # To copy on bootable drives TODO
ARCHIVE="$HOME/archive/life $HOME/archive/project"

_rsync() { # Custom rsync command
  systemd-inhibit --what=shutdown:sleep --who="$0" --why=Backuping \
  rsync --verbose --archive --human-readable --partial --progress \
    --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/common \
    --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/img "$@"
}

_restic() { # Custom restic command
  REPO="$1"
  shift
  systemd-inhibit --what=shutdown:sleep --who="$0" --why=Backuping \
  restic --repo "$REPO" --verbose backup --exclude-caches \
  --exclude-file="$XDG_CONFIG_HOME"/backup-exclude/common "$@" \
  --pack-size=128 # Less chunks for drives # TODO Nix deriv
}

case "$1" in
*drive*)
  # Backup everything in remote drive with rclone, putting deleted aside
  for dest in "$@"; do
    printf "Starting backup to %s" "$dest"
    for dir in $IMPORTANT; do
      dirname=$(basename "$dir")
      rclone sync --progress \
      --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/common \
      --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/img \
      --backup-dir "$dest:$USER-trash/$(date +%Y-%m-%d-%H)/$dirname" \
      "$dir" "$dest:$USER-back/$dirname"
    done
    for dir in $ARCHIVE; do
      dirname=$(basename "$dir")
      rclone copy --progress \
      --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/common \
      --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/img \
      "$dir" "$dest:$USER-back/archive/$dirname"
    done
    printf "Finished backup to %s" "$dest"
  done
  ;;
*back*)
  avail=$(\df -k --output=avail "$1" | tail -n1)    # Available destination
  used=$(\du -skc $IMPORTANT | tail -n1 | cut -f1) # Used by important dirs
  printf "Available space on destination : %sB" "$avail"
  printf "Used space by important data : %sB" "$used"

  if [ "$avail" -gt "$used" ]; then
    # Backup everything incrementally with restic in backup drives
    printf "%s contains back: " "$1"
    printf "Backing up [%s %s] incrementally (restic)\n" "$IMPORTANT" "$ARCHIVE"
    _restic "$1" $IMPORTANT $ARCHIVE

    LOCAL_REPO="$1"
    shift # Consume local repo path from arguments

    for drive_dest in "$@"; do
      case "$drive_dest" in
      *:) # Sync rclone configured dir to cloud provider
        printf "Syncing restic repo from %s to %s" "$LOCAL_REPO" "$drive_dest"
        rclone sync --progress --fast-list --drive-chunk-size 128M "$LOCAL_REPO" "$drive_dest$USER-restic" &
        ;;
      *drive*) # Sync restic dir to cloud provider
        printf "Syncing restic repo from %s to %s" "$LOCAL_REPO" "$drive_dest"
        rclone sync --progress --fast-list --drive-chunk-size 128M "$LOCAL_REPO" "$drive_dest:$USER-restic" &
        ;;
      esac
    done
    printf "Cloud syncs started in background, will outlive terminal\n"
  else
    # Don’t store large dirs/files in too small drives
    printf "%s doesn’t have enough available space: " "$1"
    printf "Backing up [%s] in encrypted archive\n" "$IMPORTANT"
    printf "\nTODO with a crossplatform encrypted archiver (7zip, Veracrypt…)\n"
    _rsync --exclude="*.large" $IMPORTANT "$1" # Sync important dirs
  fi
  ;;
*boot*)
  # Store most important directories and OSes in large drives or sticks
  # (which label don’t contains "back" but contains "boot")
  printf "%s contains boot: " "$1"
  printf "Backing up [%s] encrypted, as well as [%s]\n" "$IMPORTANT" "$BOOTABLE"
  printf "\nTODO with a crossplatform encrypted archiver (7zip, Veracrypt…)\n"
  # _rsync --delete $BOOTABLE/ "$1" # Sync bootable files at root of the drive
  _rsync $IMPORTANT "$1" # Sync important dirs at the root of the drive
  ;;
*)
  # Store only most important directories in large drives or sticks
  # (which label don’t contains "back" nor "boot")
  printf "%s don’t contains back: " "$1"
  printf "Backing up [%s] in encrypted archive\n" "$IMPORTANT"
  printf "\nTODO with a crossplatform encrypted archiver (7zip, Veracrypt…)\n"
  _rsync $IMPORTANT "$1" # Sync important dirs at the root of the drive
  ;;
esac

echo -n "Clean archive directories content? (y/N, auto-cancels in 5s): "
read -r shouldClean # -t 5

if [ "$shouldClean" = "y" ] || [ "$shouldClean" = "Y" ]; then
  printf "Trashing archive directories content\n"
  for dir in $ARCHIVE; do
    find "$dir"/ -maxdepth 1 -mindepth 1 -not -name '.stfolder' \
      -not -name '.stignore' -not -name 'stignore' -not -name 'stignore.light' \
      -exec trash --verbose {} +
  done
fi
