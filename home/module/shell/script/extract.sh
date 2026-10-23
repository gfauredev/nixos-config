#!/bin/sh

# Detect available trash command
TRASH_CMD=""
if command -v trash >/dev/null 2>&1; then
  TRASH_CMD="trash"
elif command -v trash-put >/dev/null 2>&1; then
  TRASH_CMD="trash-put"
fi

if [ -z "$1" ]; then
  echo "Usage: extract <path/file_name>.<ext>"
  echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] ..."
  exit 1
fi

# Handle unquoted filename with spaces passed as multiple arguments
if [ ! -f "$1" ] && [ -f "$*" ]; then
  set -- "$*"
fi

for n in "$@"; do
  n="${n%,}"

  if [ ! -f "$n" ]; then
    echo "extract: '$n' - file does not exist" >&2
    continue
  fi

  # Resolve absolute path to archive before changing directories
  abs_archive="$(cd "$(dirname "$n")" && pwd)/$(basename "$n")"
  base_name="$(basename "$n")"
  lower_name="$(printf '%s' "$base_name" | tr '[:upper:]' '[:lower:]')"

  # Determine folder name by stripping extension case-insensitively
  case "$lower_name" in
  *.tar.bz2 | *.tar.gz | *.tar.xz | *.tar.zst)
    dest_name="${base_name%.*.*}"
    ;;
  *.*)
    dest_name="${base_name%.*}"
    ;;
  *)
    dest_name="$base_name"
    ;;
  esac

  # Create a temporary extraction directory in the current working directory
  tmp_dir=$(mktemp -d ./.extract_tmp_XXXXXX) || continue

  # Extract into the temporary directory
  (
    cd "$tmp_dir" || exit 1
    case "$lower_name" in
    *.cbt | *.tar.bz2 | *.tar.gz | *.tar.xz | *.tbz2 | *.tgz | *.txz | *.tar)
      tar -xvf "$abs_archive"
      ;;
    *.lzma)
      unlzma -c "$abs_archive" >"$dest_name"
      ;;
    *.bz2)
      bunzip2 -c "$abs_archive" >"$dest_name"
      ;;
    *.cbr | *.rar)
      unrar x "$abs_archive"
      ;;
    *.gz)
      gunzip -c "$abs_archive" >"$dest_name"
      ;;
    *.cbz | *.epub | *.zip)
      unzip "$abs_archive"
      ;;
    *.z)
      uncompress -c "$abs_archive" >"$dest_name"
      ;;
    *.7z | *.arj | *.cab | *.cb7 | *.chm | *.deb | *.dmg | *.iso | *.lzh | *.msi | *.pkg | *.rpm | *.udf | *.wim | *.xar)
      7z x "$abs_archive"
      ;;
    *.xz)
      unxz -c "$abs_archive" >"$dest_name"
      ;;
    *.exe)
      cabextract "$abs_archive"
      ;;
    *.cpio)
      cpio -id <"$abs_archive"
      ;;
    *.cba | *.ace)
      unace x "$abs_archive"
      ;;
    *)
      echo "extract: '$n' - unknown archive method" >&2
      exit 2
      ;;
    esac
  )
  extract_status=$?

  if [ $extract_status -ne 0 ]; then
    rm -rf "$tmp_dir"
    continue
  fi

  # Count items extracted into the root of the temp folder (including hidden files)
  count=0
  single_item=""
  for item in "$tmp_dir"/* "$tmp_dir"/.[!.]* "$tmp_dir"/..?*; do
    if [ -e "$item" ] || [ -L "$item" ]; then
      count=$((count + 1))
      single_item="$item"
    fi
  done

  # Smart placement logic
  if [ "$count" -gt 1 ]; then
    # Multiple root items: move everything into a folder named after the archive
    if [ -d "$dest_name" ]; then
      for item in "$tmp_dir"/* "$tmp_dir"/.[!.]* "$tmp_dir"/..?*; do
        [ -e "$item" ] || [ -L "$item" ] || continue
        mv "$item" "$dest_name/"
      done
      rm -rf "$tmp_dir"
    else
      mv "$tmp_dir" "$dest_name"
    fi
  elif [ "$count" -eq 1 ]; then
    # Single root item: move directly to the current directory
    mv "$single_item" ./
    rm -rf "$tmp_dir"
  else
    rm -rf "$tmp_dir"
  fi

  # Trash the archive if a supported trash tool is found
  if [ -n "$TRASH_CMD" ]; then
    "$TRASH_CMD" "$abs_archive"
  fi
done
