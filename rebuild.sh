if [ "$1" = "os" ] || [ "$1" = "system" ] || [ "$1" = "all" ]; then
  sudo mount /boot # Use fstab
  sudo nixos-rebuild --flake . switch
  sudo umount /boot # Unmount for security
fi

if [ "$1" != "os" ] && [ "$1" != "system" ]; then
  rm -f $XDG_CONFIG_HOME/mimeapps.list # Mitigate Mailspring behavior
  home-manager --flake .#${USER}@$(hostname) switch
fi

# git push
