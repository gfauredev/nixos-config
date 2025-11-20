if [ -z "$1" ]; then
    TARGET_PATH=$(pwd) # No arg provided: Target is the current directory
else
    # Arg provided: Target is the specific file/folder
    TARGET_PATH=$(realpath "$1")
fi
if [ ! -e "$TARGET_PATH" ]; then # Ensure file exists
    echo "Error: '$TARGET_PATH' does not exist"
    exit 1
fi
if [[ "$TARGET_PATH" != "$HOME"* ]]; then # Ensure file is inside HOME
    echo "Error: Target must be under your home directory ($HOME)"
    exit 1
fi
REL_PATH_FROM_HOME="${TARGET_PATH#"$HOME"/}"
HOME_DIRECT_CHILD="${REL_PATH_FROM_HOME%%/*}"
if [ "$REL_PATH_FROM_HOME" == "$HOME_DIRECT_CHILD" ]; then
    echo "Error: Cannot archive direct child of Home, must be in a subdirectory"
    exit 1 # Prevent archiving root items
fi
INNER_PATH="${REL_PATH_FROM_HOME#"$HOME_DIRECT_CHILD"/}"
ARCHIVE_ROOT="$HOME/archive-$HOME_DIRECT_CHILD"
DEST_PATH="$ARCHIVE_ROOT/$INNER_PATH"
DEST_DIR=$(dirname "$DEST_PATH")
echo "Archiving: $TARGET_PATH -> $DEST_PATH"
mkdir --parents --verbose "$DEST_DIR" # Create directory structure
if [ "$TARGET_PATH" = "$(pwd)" ]; then
    cd .. # Step back if we are archiving the current directory
fi
mv --verbose "$TARGET_PATH" "$DEST_PATH" # Archive the file/folder (move it)
if [ $? -eq 0 ]; then
    echo "✓ Success"
    if [ "$IS_CWD" = true ]; then # Remind the user if inside the moved folder
        echo "NOTE: You are currently in a deleted directory,"
        echo "      type 'cd ..' or 'cd -' to return to a valid path"
    fi
else
    echo "✗ Failed to move file"
    exit 1
fi
