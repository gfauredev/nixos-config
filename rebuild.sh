if [ "$1" = "os" ] || [ "$1" = "system" ] || [ "$1" = "all" ]; then
  sudo nixos-rebuild --flake . switch
fi

if [ "$1" != "os" ] || [ "$1" != "system" ]; then
  home-manager --flake .#${USER}@$(hostname) switch
fi

# git push
