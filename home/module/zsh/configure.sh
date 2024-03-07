CONFIG_DIR="$HOME/life.large/configuration.git/" # hardcoded configuration location

DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/flake/"

system() {
  printf "\nMounting /boot before system update\n"
  sudo mount /boot || return # Use fstab

  printf "\nPerforming system update\n"
  sudo nixos-rebuild --flake . switch || return

  printf "\nUnmounting /boot after update\n"
  sudo umount /boot # Unmount for security
}

home() {
  printf "\nRemoving .config/mimeapps.list\n"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it

  printf "\nPerforming profile update\n"
  home-manager --flake ".#${USER}@$(hostname)" switch || return
}

edit() {
  $EDITOR . && git add . && git commit "$@" || return
}

cd "$CONFIG_DIR" || cd "$DEFAULT_CONFIG_DIR" || exit # Go inside the config directory

if [ "$#" -eq 0 ]; then
  cd home || exit
  edit && home ; exit
fi

# Go through each parameters and act accordingly
case "$1" in
  "rebuild")
    if ! [ "$2" ]; then
      home
      exit
    fi
    case "$2" in
      "system")
        system || exit
        ;;
      "all")
        system && home || exit
        ;;
      *)
        home || exit
        ;;
    esac
      shift 2
    ;;
  "system")
      cd system || exit
      edit && system || exit
      shift
    ;;
  "home")
      cd home || exit
      edit && home || exit
      shift
    ;;
  "all")
      edit && system && home || exit
      shift
    ;;
  "push")
    git push || exit
    shift
    ;;
  *) # If parameters are a message, update home with this commit message and exit
    edit -m "$@" && home ; exit
    ;;
esac

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
