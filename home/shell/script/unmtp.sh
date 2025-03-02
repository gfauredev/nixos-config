# Unmount Android
# cd $HOME/ || return # TODO per shell function that does this
fusermount -u $HOME/mtp
rmdir $HOME/mtp
