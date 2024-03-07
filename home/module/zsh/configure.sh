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

cd "$CONFIG_DIR" || exit # Change to the config directory

# Go through each parameters and act accordingly
for param in "$@"; do
  case "$param" in
    "rebuild")
      rebuild=true # Rebuild without modification
      ;;
    "system")
      [ "$rebuild" ] || $EDITOR system/ && git commit -am "System : $2" && rebuild=true 
      [ "$rebuild" ] && system_update || exit
      ;;
    "all")
      [ "$rebuild" ] || $EDITOR . && git commit -am "System & Home : $2" && rebuild=true
      [ "$rebuild" ] && system_update && home_update || exit
      ;;
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
    *)
      [ "$rebuild" ] || $EDITOR home/ && git commit -am "Home : $2" && rebuild=true
      [ "$rebuild" ] && home_update || exit
      ;;
  esac
done

# cd - || exit # Return to the starting directory
