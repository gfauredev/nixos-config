if [ "$1" ]; then
  devs=$*
else
  lsblk --output TRAN,NAME,SIZE,MOUNTPOINTS || udisksctl status
  printf "Space-separated device(s) to unmount, without /dev/ : "
  read -r devs
fi
cd ~ || return
for dev in $devs; do
  udisksctl unmount -b /dev/"$dev" || return
  udisksctl power-off -b /dev/"$dev"
done
\rm "$HOME"/usb
