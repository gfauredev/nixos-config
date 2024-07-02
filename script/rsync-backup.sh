if [ -n "$1" ]; then
  readonly SOURCE_DIR="$(realpath "$1")"
else
  readonly SOURCE_DIR="$HOME/data"
fi
echo "Backup $SOURCE_DIR"

if [ -n "$2" ]; then
  readonly BACKUPS_DIR="$(realpath "$2")"
else
  readonly BACKUPS_DIR="$HOME/usb/gf-back/"
fi
echo "Into $BACKUPS_DIR"

readonly DATE="$(date '+%Y-%m-%d_%H:%M:%S')"
readonly THIS_BACKUP_DIR="$BACKUPS_DIR/$DATE"
readonly LATEST_LINK="$BACKUPS_DIR/latest-backup"

echo "Creating new backup at $THIS_BACKUP_DIR"
mkdir -p $THIS_BACKUP_DIR

echo "Beginning transfer"
rsync -vah --progress --delete \
  "$SOURCE_DIR/" \
  --link-dest "$LATEST_LINK" \
  "$THIS_BACKUP_DIR"

echo "Delete previous link & create new"
rm -fr "$LATEST_LINK"
ln -fs "$THIS_BACKUP_DIR" "$LATEST_LINK"
