#!/bin/sh

rclone sync "$1" "$2" \
  --filter-from ~/.config/backup-exclude/common \
  --fast-list --update --use-mtime --track-renames --progress \
  --protondrive-replace-existing-draft
