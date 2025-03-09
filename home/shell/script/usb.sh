if [ "$1" ]; then
  devs=$*
else
  lsblk --output TRAN,NAME,SIZE,MOUNTPOINTS || udisksctl status
  printf "Space-separated device(s) to (un)mount, without /dev/ : "
  read -r devs
fi
for dev in $devs; do
  if findmnt "/dev/$dev"; then # If the device is mounted, unmount
    udisksctl unmount -b /dev/"$dev" || return
    case $(findmnt -n -o TARGET /dev/"$dev") in
      *"back"*)
        printf '%s seems to be a backup device, SMART health test\n' "$dev"
        sudo smartctl -x /dev/"$dev"
      ;;
    esac
    udisksctl power-off -b /dev/"$dev"
  else # Else mount it
    udisksctl mount -b "/dev/$dev" || return
  fi
done
if [ -e "/run/media/$USER" ] && ! [ -h "$HOME/usb" ]; then
  ln -s "/run/media/$USER" "$HOME/usb" # Create USB link if needed
elif [ -h "$HOME/usb" ]; then
  rm "$HOME/usb" # Remove USB link if not needed anymore
fi
