#!zsh
# Directories under user $HOME, roughly in order of importance
# 1. life records for important areas that need monitoring or documents that might be recurrently asked
# 2. project, files that might be required to progress towards a final goal or a precise milestone
# 3. graph, linked and non-hierarchical data related to projects, important life areas or anything else
# 4. data, files that might become useful in a life area or in a project, or just be interesting or fun
# 5. archive, definitively complete or discontinued project, expired or no longer useful files

# Files corresponding to *.git/** or *.large should not be synced with lower capacity devices

# TODO: restic backups in more drives, enventually all drives above 500Go

avail=$(\df --output=avail "$1"|tail -n1)
used=$(\du -c $HOME/{data,life,project}|tail -n1|cut -f1)
echo "Available space on destination : ${avail}o"
echo "Used space by important data :   ${used}o"

if [ $avail -gt $used ]; then
  if [[ "$1" == *"back"* ]]; then
    # Backup everything incrementally with restic in backup drives (which label contains "back")
    echo -e "$1 contains back : Backing up archive,data,graph,life,project with restic in it\n"
    restic -r "$1" -v backup $HOME/{archive,data,.graph,life,project} \
      --exclude ".stversions/" --exclude ".stfolder/" \
      --exclude ".venv*/" --exclude ".vagrant/"
  else
    # Store most important directories in drives or sticks (which label don’t contains "back")
    echo -e "$1 don’t contains back : Backing up data,graph,life,project with rsync in it\n"
    rsync --verbose --archive --delete --human-readable --partial --progress \
      --exclude=".stversions/" --exclude=".stfolder/" --exclude="*.large/" \
      --exclude=".venv*/" --exclude=".vagrant/" --exclude=".git/" \
      --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" \
      --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" \
      --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" \
      --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" \
      --exclude="*cache*" --exclude="*thumbnails*" \
      $HOME/{data,.graph,life,project} "$1"
  fi
else
  # Don’t store less important directories in too small drives
  echo -e "$1 seems almost full : Backing up graph,life,project with rsync in it\n"
  rsync --verbose --archive --delete --human-readable --partial --progress \
      --exclude=".stversions/" --exclude=".stfolder/" --exclude="*.large/" \
      --exclude=".venv*/" --exclude=".vagrant/" --exclude=".git/" \
      --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" --exclude="*.bmp" \
      --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" --exclude="*.BMP" \
      --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" \
      --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" \
      --exclude="*cache*" --exclude="*thumbnails*" \
    $HOME/{.graph,life,project} "$1"
fi
