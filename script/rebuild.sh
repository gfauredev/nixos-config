if [ "$1" = "os" ] || [ "$1" = "system" ] || [ "$1" = "all" ]; then
  echo "\nMounting /boot before system update"
  sudo mount /boot # Use fstab
  echo "\nPerforming system update"
  sudo nixos-rebuild --flake . switch
  echo "\nUnmounting /boot after update"
  sudo umount /boot # Unmount for security
fi

if [ "$1" != "os" ] && [ "$1" != "system" ]; then
  echo "\nRemoving .config/mimeapps.list"
  rm -f $XDG_CONFIG_HOME/mimeapps.list # Mitigate Mailspring behavior
  echo "\nPerforming profile update"
  home-manager --flake .#${USER}@$(hostname) switch
fi

[ "$2" = "push" ] && git push
[ "$2" = "commit" ] && git commit -am "Unnamed update" && git push

[ "$3" = "off" ] && systemctl poweroff
[ "$3" = "poweroff" ] && systemctl poweroff

[ "$3" = "reboot" ] && systemctl reboot
