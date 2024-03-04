if [ "$1" = "os" ] || [ "$1" = "system" ] || [ "$1" = "all" ]; then
  printf "\nMounting /boot before system update"
  sudo mount /boot # Use fstab
  printf "\nPerforming system update"
  sudo nixos-rebuild --flake . switch
  printf "\nUnmounting /boot after update"
  sudo umount /boot # Unmount for security
fi

if [ "$1" != "os" ] && [ "$1" != "system" ]; then
  printf "\nRemoving .config/mimeapps.list"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Mitigate Mailspring behavior
  printf "\nPerforming profile update"
  home-manager --flake ".#${USER}@$(hostname)" switch
fi

[ "$2" = "push" ] && git push
[ "$2" = "commit" ] && git commit -am "Unnamed update" && git push

[ "$3" = "off" ] && systemctl poweroff
[ "$3" = "poweroff" ] && systemctl poweroff

[ "$3" = "reboot" ] && systemctl reboot
