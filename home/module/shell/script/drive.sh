#!/bin/sh

rclone sync "$1" "$2" \
  --exclude-from ~/.config/backup-exclude/common \
  --fast-list --update --track-renames --progress \
  --protondrive-replace-existing-draft
