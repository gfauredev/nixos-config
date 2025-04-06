if [ -z "$DISPLAY" ]; then
  if [ "$XDG_VTNR" -eq 1 ]; then           # Leave eGPU passthrough available
    exec "$HOME/.nix-profile/bin/hyprland" # TODO consider using UWSM
    # AQ_DRM_DEVICES="$HOME/.config/hypr/igpu" exec "$HOME/.nix-profile/bin/hyprland"
  elif [ "$XDG_VTNR" -eq 2 ]; then # Force boot on eGPU
    exec "$HOME/.nix-profile/bin/hyprland"
    # AQ_DRM_DEVICES="$HOME/.config/hypr/egpu" exec "$HOME/.nix-profile/bin/hyprland"
  elif [ "$XDG_VTNR" -eq 3 ]; then
    exec "$HOME/.nix-profile/bin/niri" --session
  fi
fi
