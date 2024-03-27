DEFAULT_CONFIG_DIR="$XDG_CONFIG_HOME/flake/"

system() {
  printf "\nMounting /boot before system update\n"
  sudo mount /boot || return # Use fstab

  printf "\nPerforming system update\n"
  if sudo nixos-rebuild --flake . switch; then
    printf "\nUnmounting /boot after update\n"
    sudo umount /boot # Unmount for security
  else
    printf "\nFailed update, unmounting /boot\n"
    sudo umount /boot # Unmount for security
    return 1 # Failed update status
  fi
}

home() {
  printf "\nRemoving .config/mimeapps.list\n"
  rm -f "$XDG_CONFIG_HOME/mimeapps.list" # Some apps replace it

  printf "\nPerforming profile update\n"
  home-manager --flake ".#${USER}@$(hostname)" switch || return
}

cfg-pull() {
  printf "Pulling latest changes\n"
  git pull || printf '\nUnable to pull from %s\n' "$(git remote)"
  echo
}

edit() {
  $EDITOR . && git add . && git commit "$@" || return
}

cd "$CONFIG_DIR" || cd "$DEFAULT_CONFIG_DIR" || exit # Go inside the config directory

if [ "$#" -eq 0 ]; then
  cfg-pull
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
        system ; home || exit
        ;;
      *)
        home || exit
        ;;
    esac
      shift 2
    ;;
  "system")
    cfg-pull
    cd system || exit
    edit && system || exit
    shift
    ;;
  "home")
    cfg-pull
    cd home || exit
    edit && home || exit
    shift
    ;;
  "all")
    cfg-pull
    if edit; then
      system ; home || exit
    else
      exit
    fi
    shift
    ;;
  "update")
    cfg-pull
    nix flake update --commit-lock-file || exit
    shift
    ;;
  "push")
    git rebase -i || exit
    git push || exit
    shift
    ;;
  "log")
    git log --oneline || exit
    echo
    git status || exit
    shift
    ;;
  "cd")
    exec $SHELL
    ;;
  *) # If parameters are a message, update home with this commit message and exit
    cfg-pull
    cd home || exit
    edit -m "$*" && home ; exit
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
    "boot")
      systemctl reboot
      ;;
    "reboot")
      systemctl reboot
      ;;
  esac
done
