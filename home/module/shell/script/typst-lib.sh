# Clone my Typst library at the right place
REPO=git@gitlab.com:gfauredev/typst-lib
DEST=$XDG_DATA_HOME/typst/packages/local
git clone $REPO "$DEST"
