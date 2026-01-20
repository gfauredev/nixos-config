# Unmount or mount Android based on the existance of mount point
if [ -d $HOME/mtp ]; then
  fusermount -u $HOME/mtp
  rmdir $HOME/mtp
else
  mkdir $HOME/mtp
  aft-mtp-mount $HOME/mtp
fi
