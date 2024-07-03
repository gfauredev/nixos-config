#!zsh
# Directories are, in order of importance (under user home)
# 1. life
# 2. project
# 3. life.large
# 4. project.large
# 5. data
# 6. data.large
# 7. archive

avail=$(\df --output=avail "$1"|tail -n1)
used=$(\du -c $HOME/{data,life{,.large},project{,.large}}|tail -n1|cut -f1)
echo "Available space on destination : $avail"
echo "Used space by important data :   $used"

if [[ "$1" == *"back"* ]]; then
  # Backup everything incrementally with restic in backup drives (which label contains "back")
  echo "Backing up everything with restic\n"
  restic -r "$1" -v backup $HOME/{archive,data{,.large},life{,.large},project{,.large}}
elif [ $avail -gt $used ]; then
  # Store most important directories in drives or sticks (which label don’t contains "back")
  echo "Backing up most important directories with rsync\n"
  rsync --verbose --archive --delete --human-readable --partial --progress \
    --exclude=".stversions/" --exclude=".stfolder/" --exclude=".venv*/" --exclude=".vagrant/" \
    --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" \
    --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" \
    --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" --exclude="*thumbnails*" \
    --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" --exclude="*cache*" \
    $HOME/{data,life{,.large},project{,.large}} "$1"
else
  # Store less important directories in too small drives
  echo "Backing up life/ and project/ directories with rsync\n"
  rsync --verbose --archive --delete --human-readable --partial --progress \
    --exclude=".stversions/" --exclude=".stfolder/" --exclude=".venv/" --exclude=".vagrant/" \
    --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" --exclude="*.webp" --exclude="*.avif" \
    --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" --exclude="*.WEBP" --exclude="*.AVIF" \
    --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" --exclude="*thumbnails*" \
    --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" --exclude="*cache*" \
    $HOME/{life,project} "$1"
fi
