# Directories under user $HOME, roughly in order of importance
# 1. life records for important areas that need monitoring or documents that might be recurrently asked
# 2. project, files that might be required to progress towards a final goal or a precise milestone
# 3. graph, linked and non-hierarchical data related to projects, important life areas or anything else
# 4. data, files that might become useful in a life area or in a project, or just be interesting or fun
# 5. archive, definitively complete or discontinued project, expired or no longer useful files

# Files corresponding to *.git/** or *.large should not be synced with lower capacity devices

# TODO: restic backups in every drive of at least 500Go

IMPORTANT="$HOME/life $HOME/project $HOME/.graph" # Always backed up
DATA="$HOME/data"
ARCHIVE="$HOME/archive"
avail=$(\df --output=avail "$1" | tail -n1)    # Available destination
used=$(\du -c $IMPORTANT | tail -n1 | cut -f1) # Used by important dirs
echo "Available space on destination : ${avail}o"
echo "Used space by important data :   ${used}o"

# Common rsync config
alias rsync="rsync --verbose --archive --human-readable --partial --progress --exclude-from=$XDG_CONFIG_HOME/backup-exclude/common"

if [ "$avail" -gt "$used" ]; then
  case "$1" in
  *back*)
    # Backup everything incrementally with restic in backup drives
    # (which label contains "back")
    printf "%s contains back : Backing up archive,data,graph,life,project with restic in it\n" "$1"
    restic -r "$1" -v backup $IMPORTANT "$DATA" "$ARCHIVE" \
      --exclude-caches --exclude-file="$XDG_CONFIG_HOME"/backup-exclude/common
    ;;
  *)
    # Store most important directories in large drives or sticks
    # (which label don’t contains "back")
    printf "%s don’t contains back : Backing up data,graph,life,project with rsync in it\n" "$1"
    rsync --exclude="*.large" \
      --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/img \
      $IMPORTANT "$DATA" "$1"
    ;;
  esac
else
  # Don’t store less important directories in too small drives
  printf "%s seems almost full : Backing up graph,life,project with rsync in it\n" "$1"
  rsync --delete --exclude="*.large" --exclude="*.git" \
    --exclude-from="$XDG_CONFIG_HOME"/backup-exclude/img $IMPORTANT "$1"
fi

printf "Don’t forget to clean the ~/archive directory with cleanarchive"
