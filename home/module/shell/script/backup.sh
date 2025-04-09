# Directories under user $HOME, roughly in order of importance
# 1. life records for important areas that need monitoring or documents that might be recurrently asked
# 2. project, files that might be required to progress towards a final goal or a precise milestone
# 3. graph, linked and non-hierarchical data related to projects, important life areas or anything else
# 4. data, files that might become useful in a life area or in a project, or just be interesting or fun
# 5. archive, definitively complete or discontinued project, expired or no longer useful files

# Files corresponding to *.git/** or *.large should not be synced with lower capacity devices

# Always backed up
IMPORTANT="$HOME/life $HOME/project $HOME/.graph $XDG_CONFIG_HOME/Bitwarden"
DATA="$HOME/data"
OS="$HOME/data/operatingSystems.large"
ARCHIVE="$HOME/archive"
avail=$(\df --output=avail "$1" | tail -n1)    # Available destination
used=$(\du -c $IMPORTANT | tail -n1 | cut -f1) # Used by important dirs
echo "Available space on destination : ${avail}o"
echo "Used space by important data :   ${used}o"

rs() { # Custom rsync command
  rsync --verbose --archive --human-readable --partial --progress \
    --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/common \
    --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/img --exclude="*.large"
}

if [ "$avail" -gt "$used" ]; then
  case "$1" in
  *back*)
    # Backup everything incrementally with restic in backup drives
    # (which label contains "back")
    printf "%s contains back: " "$1"
    printf "Backing up life, project, data, archive incrementally with restic\n"
    restic -r "$1" -v backup $IMPORTANT "$DATA" "$ARCHIVE" \
      --exclude-caches --exclude-file="$XDG_CONFIG_HOME"/backup-exclude/common
    ;;
  *boot*)
    # Store most important directories in large drives or sticks
    # (which label don’t contains "back" but contains "boot")
    printf "%s contains boot: " "$1"
    printf "Backing up current life and project as well as bootables OSes\n"
    # TODO encrypted archive of $IMPORTANT dirs, excluing common and img
    printf "TODO with a crossplatform encrypted archiver like 7zip\n"
    rs --delete "$OS"/linux+bsd "$1"
    rs --delete "$OS"/windows "$1"
    ;;
  *)
    # Store most important directories in large drives or sticks
    # (which label don’t contains "back" nor "boot")
    printf "%s don’t contains back: " "$1"
    printf "Backing up life, project, data in encrypted archive\n"
    # TODO encrypted archive of $IMPORTANT + $DATA dirs, excluing common and img
    printf "TODO with a crossplatform encrypted archiver like 7zip"
    ;;
  esac
else
  # Don’t store less important directories in too small drives
  printf "%s seems almost full: " "$1"
  printf "Backing up life and project in encrypted archive\n"
  # TODO $IMPORTANT dirs encrypted archive, excluing common, img, *.large, *.git
  printf "TODO with a crossplatform encrypted archiver like 7zip\n"
fi

printf "Don’t forget to clean the ~/archive directory with cleanarchive\n"
