if [ -z "${WAYLAND_DISPLAY:-}" ] && [ -z "${DISPLAY:-}" ]; then
  case "${XDG_VTNR:-}" in
  1 | 2)
    if command -v start-hyprland >/dev/null 2>&1; then
      exec start-hyprland
    fi
    ;;
  3)
    if command -v niri >/dev/null 2>&1; then
      exec niri --session
    fi
    ;;
  esac
fi
