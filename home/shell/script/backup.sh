# Directories under user $HOME, roughly in order of importance
# 1. life records for important areas that need monitoring or documents that might be recurrently asked
# 2. project, files that might be required to progress towards a final goal or a precise milestone
# 3. graph, linked and non-hierarchical data related to projects, important life areas or anything else
# 4. data, files that might become useful in a life area or in a project, or just be interesting or fun
# 5. archive, definitively complete or discontinued project, expired or no longer useful files

# Files corresponding to *.git/** or *.large should not be synced with lower capacity devices

# TODO: restic backups in every drive of at least 500Go

important_dirs="$HOME/life $HOME/project $HOME/.graph"
avail=$(\df --output=avail "$1" | tail -n1)
used=$(\du -c $important_dirs | tail -n1 | cut -f1)
echo "Available space on destination : ${avail}o"
echo "Used space by important data :   ${used}o"

if [ "$avail" -gt "$used" ]; then
  case "$1" in
  *back*)
    # Backup everything incrementally with restic in backup drives (which label contains "back")
    printf "%s contains back : Backing up archive,data,graph,life,project with restic in it\n" "$1"
    restic -r "$1" -v backup $important_dirs "$HOME/data" "$HOME/archive" \
      --exclude ".stversions/" --exclude ".stfolder/" \
      --exclude ".venv*/" --exclude ".vagrant/" \
      --exclude "*.local"

    printf "Clean archive directory\n"
    trash --verbose "$HOME"/archive/life/*
    trash --verbose "$HOME"/archive/life.large/*
    trash --verbose "$HOME"/archive/project/*
    trash --verbose "$HOME"/archive/project.large/*
    trash --verbose "$HOME"/archive/memory/*
    trash --verbose "$HOME"/archive/memory.large/*
    ;;
  *)
    # Store most important directories in drives or sticks (which label don’t contains "back")
    printf "%s don’t contains back : Backing up data,graph,life,project with rsync in it\n" "$1"
    rsync --verbose --archive --delete --human-readable --partial --progress \
      --exclude=".stversions/" --exclude=".stfolder/" --exclude="*.large" --exclude="*.local" \
      --exclude=".venv*/" --exclude=".vagrant/" --exclude=".git/" \
      --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" \
      --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" \
      --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" \
      --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" \
      --exclude="*cache*" --exclude="*thumbnails*" \
      $important_dirs "$HOME/data" "$1"
    ;;
  esac
else
  # Don’t store less important directories in too small drives
  printf "%s seems almost full : Backing up graph,life,project with rsync in it\n" "$1"
  rsync --verbose --archive --delete --human-readable --partial --progress \
    --exclude=".stversions/" --exclude=".stfolder/" --exclude="*.large" --exclude="*.local" \
    --exclude=".venv*/" --exclude=".vagrant/" --exclude=".git/" \
    --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" --exclude="*.bmp" \
    --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" --exclude="*.BMP" \
    --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" \
    --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" \
    --exclude="*cache*" --exclude="*thumbnails*" \
    $important_dirs "$1"
fi
