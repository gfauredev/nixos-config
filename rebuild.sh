if [ "$1" = "system" ] | [ "$1" = "all" ]; then
  sudo nixos-rebuild --flake . switch
fi

home-manager --flake .#$USER@$HOST switch
