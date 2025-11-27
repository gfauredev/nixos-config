# Directories directly under user $HOME, as described in module/organization.nix
IMPORTANT="$HOME/life $HOME/project $HOME/.graph" # Always backed up
# BOOTABLE="$HOME/data/operatingSystems.large" # To copy on bootable drives TODO
ARCHIVE="$HOME/archive/life $HOME/archive/project"
avail=$(\df --output=avail "$1" | tail -n1)    # Available destination
used=$(\du -c $IMPORTANT | tail -n1 | cut -f1) # Used by important dirs
echo "Available space on destination : ${avail}o"
echo "Used space by important data :   ${used}o"

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
  --exclude-file="$XDG_CONFIG_HOME"/backup-exclude/common "$@" # TODO Nix deriv
}

if [ "$avail" -gt "$used" ]; then
  case "$1" in
  *back*)
    # Backup everything incrementally with restic in backup drives
    # (which label contains "back")
    printf "%s contains back: " "$1"
    printf "Backing up [%s %s] incrementally (restic)\n" "$IMPORTANT" "$ARCHIVE"
    _restic "$1" $IMPORTANT $ARCHIVE
      
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
else
  # Don’t store large dirs/files in too small drives
  printf "%s doesn’t have enough available space: " "$1"
  printf "Backing up [%s] in encrypted archive\n" "$IMPORTANT"
  printf "\nTODO with a crossplatform encrypted archiver (7zip, Veracrypt…)\n"
  _rsync --exclude="*.large" $IMPORTANT "$1" # Sync important dirs
fi

echo -n "Clean archive directories content ? (y to accept): "
read -r shouldClean # TODO Timeout after 5s in POSIX shell

if [ "$shouldClean" = "y" ] || [ "$shouldClean" = "Y" ]; then
  printf "Trashing archive directories content\n"
  for dir in $ARCHIVE; do
    find "$dir"/ -maxdepth 1 -mindepth 1 -not -name '.stfolder' \
      -not -name '.stignore' -not -name 'stignore' -not -name 'stignore.light' \
      -exec trash --verbose {} +
  done
fi
