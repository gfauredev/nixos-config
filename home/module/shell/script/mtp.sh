# Unmount or mount Android based on the existance of mount point TODO cleaner
if [ -d $HOME/mtp ]; then
  fusermount -u $HOME/mtp
  rmdir $HOME/mtp
else
  mkdir $HOME/mtp
  jmtpfs $HOME/mtp
fi
