lsblk -o PATH,SIZE,TYPE,LABEL
read -p "Device to decrypt (auto mount all) /dev/" device

if [ -n "$device" ]; then
  # Decrypt the single device the user requested
  veracrypt -t --filesystem=none "/dev/$device"
else
  # Decrypt all veracrypt devices
  veracrypt -t --auto-mount=devices --filesystem=none
fi

defaultDecrypt="veracrypt1"
defaultPoint=".data"

lsblk -o PATH,SIZE,TYPE,LABEL
# Ask the user for a decrypted device to mount, defaults to loop0
read -p "Decrypted device to mount ($defaultDecrypt) /dev/mapper/" decrypt
# read -p "Mount point (leave not mounted) : " point
read -p "Mount point (.data) : " point

# Mount a device for the user
if [ "$decrypt" == "" ]; then
  decrypt="$defaultDecrypt"
fi

if [ -n "$point" ]; then
    sudo mount -o uid=$(id -u),gid=$(id -g),umask=027 /dev/mapper/$decrypt $point
  else
    sudo mount -o uid=$(id -u),gid=$(id -g),umask=027 /dev/mapper/$decrypt $defaultPoint
fi
