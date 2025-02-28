if [ "$1" ]; then
  devs=$*
else
  lsblk --output TRAN,NAME,SIZE,MOUNTPOINTS || udisksctl status
  printf "Space-separated device(s) to mount, without /dev/ : "
  read -r devs
fi
[ -h "$HOME/usb" ] || ln -s "/run/media/$USER" "$HOME/usb" # Create USB link if needed
for dev in $devs; do
  udisksctl mount -b /dev/"$dev" || return
done
cd ~/usb/ || return
