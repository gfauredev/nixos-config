if [ "$1" = "os" ] || [ "$1" = "system" ] || [ "$1" = "all" ]; then
  sudo mount /boot # Use fstab
  sudo nixos-rebuild --flake . switch
  sudo umount /boot # Use fstab
fi

if [ "$1" != "os" ] && [ "$1" != "system" ]; then
  home-manager --flake .#${USER}@$(hostname) switch
fi

# git push
