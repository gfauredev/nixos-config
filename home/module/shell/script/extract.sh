#!/bin/sh

# Detect available trash command
TRASH_CMD=""
if command -v trash >/dev/null 2>&1; then
  TRASH_CMD="trash"
elif command -v trash-put >/dev/null 2>&1; then
  TRASH_CMD="trash-put"
fi

# Helper: check for binary existence and report error if missing
require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "extract: '$1' is required to extract '$2' but is not installed" >&2
    return 1
  fi
  return 0
}

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

  abs_archive="$(cd "$(dirname "$n")" && pwd)/$(basename "$n")"
  base_name="$(basename "$n")"
  lower_name="$(printf '%s' "$base_name" | tr '[:upper:]' '[:lower:]')"

  # Derive extraction destination name
  case "$lower_name" in
  *.tar.bz2 | *.tar.gz | *.tar.xz | *.tar.zst | *.tar.lzma | *.tar.lz4 | *.tar.lzo | *.tar.br)
    dest_name="${base_name%.*.*}"
    ;;
  *.*)
    dest_name="${base_name%.*}"
    ;;
  *)
    dest_name="$base_name.extracted"
    ;;
  esac

  # Create an isolated temporary folder in current directory
  tmp_dir=$(mktemp -d ./.extract_tmp_XXXXXX) || continue
  trap 'rm -rf "$tmp_dir" 2>/dev/null; exit 130' INT TERM

  extract_status=0

  case "$lower_name" in
  # ==========================================
  # Formats handled natively by bsdtar
  # ==========================================
  *.cbt | *.tar.bz2 | *.tar.gz | *.tar.xz | *.tar.zst | *.tar.lzma | *.tar.lz4 | *.tar.lzo | *.tar.br | \
    *.tbz | *.tbz2 | *.tgz | *.txz | *.tzst | *.tlz | *.tar | \
    *.zip | *.cbz | *.epub | *.jar | *.war | *.apk | *.whl | *.xpi | \
    *.7z | *.cb7 | \
    *.iso | *.udf | \
    *.cpio | \
    *.cab | \
    *.deb | *.ar | *.a | \
    *.rpm | \
    *.xar | *.pkg | \
    *.lha | *.lzh)
    require_cmd bsdtar "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    (cd "$tmp_dir" && bsdtar -xvf "$abs_archive")
    extract_status=$?
    ;;

  # ==========================================
  # Non-bsdtar container / package formats
  # ==========================================
  *.cbr | *.rar)
    if command -v unrar >/dev/null 2>&1; then
      (cd "$tmp_dir" && unrar x "$abs_archive")
      extract_status=$?
    elif command -v 7z >/dev/null 2>&1; then
      (cd "$tmp_dir" && 7z x "$abs_archive")
      extract_status=$?
    else
      echo "extract: 'unrar' or '7z' is required to extract '$n' (bsdtar has limited RAR5 support)" >&2
      rm -rf "$tmp_dir"
      continue
    fi
    ;;
  *.cba | *.ace)
    require_cmd unace "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    (cd "$tmp_dir" && unace x "$abs_archive")
    extract_status=$?
    ;;
  *.arj)
    if command -v 7z >/dev/null 2>&1; then
      (cd "$tmp_dir" && 7z x "$abs_archive")
      extract_status=$?
    else
      require_cmd arj "$n" || {
        rm -rf "$tmp_dir"
        continue
      }
      (cd "$tmp_dir" && arj x -y "$abs_archive")
      extract_status=$?
    fi
    ;;
  *.chm | *.dmg | *.exe | *.msi | *.wim)
    require_cmd 7z "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    (cd "$tmp_dir" && 7z x "$abs_archive")
    extract_status=$?
    ;;
  *.squashfs | *.sfs)
    require_cmd unsquashfs "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    (cd "$tmp_dir" && unsquashfs -d . "$abs_archive")
    extract_status=$?
    ;;
  *.zpaq)
    require_cmd zpaq "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    (cd "$tmp_dir" && zpaq x "$abs_archive")
    extract_status=$?
    ;;

  # ==========================================
  # Raw single compressed streams (no archive container)
  # ==========================================
  *.gz)
    require_cmd gzip "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    gzip -dc "$abs_archive" >"$tmp_dir/$dest_name"
    extract_status=$?
    ;;
  *.bz2)
    require_cmd bzip2 "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    bzip2 -dc "$abs_archive" >"$tmp_dir/$dest_name"
    extract_status=$?
    ;;
  *.xz)
    require_cmd xz "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    xz -dc "$abs_archive" >"$tmp_dir/$dest_name"
    extract_status=$?
    ;;
  *.lzma)
    if command -v unlzma >/dev/null 2>&1; then
      unlzma -c "$abs_archive" >"$tmp_dir/$dest_name"
      extract_status=$?
    else
      require_cmd xz "$n" || {
        rm -rf "$tmp_dir"
        continue
      }
      xz --format=lzma -dc "$abs_archive" >"$tmp_dir/$dest_name"
      extract_status=$?
    fi
    ;;
  *.zst | *.zstd)
    require_cmd zstd "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    zstd -dc "$abs_archive" >"$tmp_dir/$dest_name"
    extract_status=$?
    ;;
  *.lz4)
    require_cmd lz4 "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    lz4 -dc "$abs_archive" >"$tmp_dir/$dest_name"
    extract_status=$?
    ;;
  *.br)
    require_cmd brotli "$n" || {
      rm -rf "$tmp_dir"
      continue
    }
    brotli -dc "$abs_archive" >"$tmp_dir/$dest_name"
    extract_status=$?
    ;;
  *.z)
    if command -v uncompress >/dev/null 2>&1; then
      uncompress -c "$abs_archive" >"$tmp_dir/$dest_name"
      extract_status=$?
    else
      require_cmd gzip "$n" || {
        rm -rf "$tmp_dir"
        continue
      }
      gzip -dc "$abs_archive" >"$tmp_dir/$dest_name"
      extract_status=$?
    fi
    ;;
  *)
    echo "extract: '$n' - unknown archive method" >&2
    rm -rf "$tmp_dir"
    continue
    ;;
  esac

  if [ $extract_status -ne 0 ]; then
    echo "extract: extraction failed for '$n'" >&2
    rm -rf "$tmp_dir"
    continue
  fi

  # Inspect extracted root items
  count=0
  single_item=""
  for item in "$tmp_dir"/* "$tmp_dir"/.[!.]* "$tmp_dir"/..?*; do
    if [ -e "$item" ] || [ -L "$item" ]; then
      count=$((count + 1))
      single_item="$item"
    fi
  done

  # Collision checking & directory management
  if [ "$count" -gt 1 ]; then
    if [ -e "$dest_name" ] || [ -L "$dest_name" ]; then
      echo "extract: collision error: target directory '$dest_name' already exists" >&2
      rm -rf "$tmp_dir"
      continue
    fi
    mv "$tmp_dir" "$dest_name"
  elif [ "$count" -eq 1 ]; then
    item_name="$(basename "$single_item")"
    if [ -e "$item_name" ] || [ -L "$item_name" ]; then
      echo "extract: collision error: target '$item_name' already exists" >&2
      rm -rf "$tmp_dir"
      continue
    fi
    mv "$single_item" ./
    rm -rf "$tmp_dir"
  else
    rm -rf "$tmp_dir"
  fi

  # Trash the archive if supported
  if [ -n "$TRASH_CMD" ]; then
    "$TRASH_CMD" "$abs_archive"
  fi
done
