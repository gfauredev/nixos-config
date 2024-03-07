# WARNING hardcoded config directory
# CONFIG_DIR="$HOME/.configuration.flake/"
CONFIG_DIR="$HOME/life.large/configuration.git/"

system_rebuild() {
  printf "\nMounting /boot before system update\n"
  sudo mount /boot || return # Use fstab

  printf "\nPerforming system update\n"
  sudo nixos-rebuild --flake . switch || return

  printf "\nUnmounting /boot after update\n"
  sudo umount /boot # Unmount for security
}

system() {
  $EDITOR system && git commit system
  system_rebuild || return
}

home_rebuild() {
  printf "\nRemoving .config/mimeapps.list\n"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it

  printf "\nPerforming profile update\n"
  home-manager --flake ".#${USER}@$(hostname)" switch || return
}

home() {
  $EDITOR home && git commit home "$@"
  home_rebuild || return
}

cd "$CONFIG_DIR" || exit # Change to the config directory

# Go through each parameters and act accordingly
case "$1" in
  "rebuild")
    case "$2" in
      "system")
        system_rebuild
        ;;
      "all")
        system_rebuild && home_rebuild
        ;;
      "*")
        home_rebuild
        ;;
    esac
      exit
    ;;
  "system")
      system || exit
    ;;
  "home")
      home || exit
    ;;
  "all")
      system && home || exit
    ;;
  "*") # If parameters are a message, update home with this commit message and exit
    home -m "$@"
    exit
    ;;
esac

if [ "$#" -eq 0 ]; then
  home
  exit
fi

shift
for param in "$@"; do
  case $param in
    "push")
      git push
      ;;
    "off")
      systemctl poweroff
      ;;
    "poweroff")
      systemctl poweroff
      ;;
    "reboot")
      systemctl reboot
      ;;
  esac
done
