if [ -z "$DISPLAY" ]; then
  if [ "$XDG_VTNR" -eq 1 ]; then
    exec "$HOME/.nix-profile/bin/Hyprland"
  elif [ "$XDG_VTNR" -eq 4 ]; then # Force use of eGPU
    WLR_DRM_DEVICES=$HOME/.config/hypr/egpu exec "$HOME/.nix-profile/bin/Hyprland"
  elif [ "$XDG_VTNR" -eq 5 ]; then
    exec "$HOME/.nix-profile/bin/niri" --session
  fi
fi
