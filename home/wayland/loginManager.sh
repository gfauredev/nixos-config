if [ -z "$DISPLAY" ]; then
  if [ "$XDG_VTNR" -eq 1 ]; then
    exec "$HOME/.nix-profile/bin/Hyprland"
  elif [ "$XDG_VTNR" -eq 5 ]; then # Force use of eGPU
    exec "WLR_DRM_DEVICES=$HOME/.config/hypr/egpu" "$HOME/.nix-profile/bin/Hyprland"
  elif [ "$XDG_VTNR" -eq 6 ]; then
    exec "$HOME/.nix-profile/bin/niri" --session
  fi
fi
