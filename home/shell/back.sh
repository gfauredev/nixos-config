#!zsh
# Directories are, in order of importance (under user home)
# 1. life, important documents of essentials area of life, like health or administrative
# 2. project, files used towards a precise goal, usually with an end date
# 3. data, files that might be interesting in the future
# 4. archive, finished projects, eventually no more used "life" documents
# *.large files are larger files not synced with phone

avail=$(\df --output=avail "$1"|tail -n1)
used=$(\du -c $HOME/{data,life,project}|tail -n1|cut -f1)
echo "Available space on destination : ${avail}o"
echo "Used space by important data :   ${used}o"

if [ $avail -gt $used ]; then
  if [[ "$1" == *"back"* ]]; then
    # Backup everything incrementally with restic in backup drives (which label contains "back")
    echo -e "Backing up everything with restic\n"
    restic -r "$1" -v backup $HOME/{archive,data,life,project} --exclude ".stversions/" \
      --exclude ".stfolder/" --exclude ".venv*/" --exclude ".vagrant/"
  else
    # Store most important directories in drives or sticks (which label don’t contains "back")
    echo -e "Backing up most important directories with rsync\n"
    rsync --verbose --archive --delete --human-readable --partial --progress \
      --exclude=".stversions/" --exclude=".stfolder/" --exclude=".venv*/" \
      --exclude=".vagrant/" --exclude=".git/" --exclude="*.large/" \
      --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" \
      --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" \
      --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" --exclude="*thumbnails*" \
      --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" --exclude="*cache*" \
      $HOME/{data,life,project} "$1"
  fi
else
  # Store less important directories in too small drives
  echo -e "Backing up life/ and project/ directories with rsync\n"
  rsync --verbose --archive --delete --human-readable --partial --progress \
    --exclude=".stversions/" --exclude=".stfolder/" --exclude=".venv/" \
    --exclude=".vagrant/" --exclude=".git/" --exclude="*.large/" \
    --exclude="*.png" --exclude="*.jpg" --exclude="*.jpeg" --exclude="*.webp" --exclude="*.avif" \
    --exclude="*.PNG" --exclude="*.JPG" --exclude="*.JPEG" --exclude="*.WEBP" --exclude="*.AVIF" \
    --exclude="*.mp4" --exclude="*.mkv" --exclude="*.avi" --exclude="*thumbnails*" \
    --exclude="*.MP4" --exclude="*.MKV" --exclude="*.AVI" --exclude="*cache*" \
    $HOME/{life,project} "$1"
fi
