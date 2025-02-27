if [ -z "$DISPLAY" ]; then
  if [ "$XDG_VTNR" -eq 1 ]; then
    exec "$HOME/.nix-profile/bin/Hyprland"
  elif [ "$XDG_VTNR" -eq 4 ]; then # Leave eGPU available for passthrough
    WLR_DRM_DEVICES="$HOME/.config/hypr/igpu" exec "$HOME/.nix-profile/bin/Hyprland"
  elif [ "$XDG_VTNR" -eq 5 ]; then
    exec "$HOME/.nix-profile/bin/niri" --session
  fi
fi
