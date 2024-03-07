CONFIG_DIR="$HOME/life.large/configuration.git/" # WARNING hardcoded config directory

system_update() {
  printf "\nMounting /boot before system update\n"
  sudo mount /boot || return # Use fstab

  printf "\nPerforming system update\n"
  sudo nixos-rebuild --flake . switch || return

  printf "\nUnmounting /boot after update\n"
  sudo umount /boot # Unmount for security
}

home_update() {
  printf "\nRemoving .config/mimeapps.list\n"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it

  printf "\nPerforming profile update\n"
  home-manager --flake ".#${USER}@$(hostname)" switch || return
}

pushd "$CONFIG_DIR" || exit # Change to the config directory

# Open what is configured within the default editor, then commit accordingly
case "$1" in
  "system")
    $EDITOR system/ && git commit -am "System : $2" && system_update || exit
    ;;
  "all")
    $EDITOR . && git commit -am "System & Home : $2" && system_update && home_update || exit
    ;;
  *)
    $EDITOR home/ && git commit -am "Home : $2" && home_update || exit
    ;;
esac

case "$3" in
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

case "$4" in
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

popd || exit # Return to the starting directory
