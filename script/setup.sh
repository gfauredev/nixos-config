#!/bin/sh

# Get last needed nix channels
echo "Add and update needed nix channels"
sudo -i nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo -i nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo -i nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
sudo -i nix-channel --add https://github.com/musnix/musnix/archive/master.tar.gz musnix
sudo -i nix-channel --update

# Link the proper config to default config location
if [ $(hostname) != "nixos" ]; then
  echo "Symlinking $(realpath "$1") to /etc/nixos/configuration.nix"
  sudo ln -fs "$(realpath "$1")" /etc/nixos/configuration.nix
else
  # In case of first install (usage by install media)
  read -p "Before continuing, ensure that the root partition is mounted in /mnt"
  read -p "Have you really read ?"
  # Link the proper config to default config location
  echo "Cleaning /mnt/etc"
  rm -rf /mnt/etc
  mkdir -p /mnt/etc/nixos
  echo "Symlinking $(realpath "$1") to /mnt/etc/nixos/configuration.nix"
  sudo ln -fs "$(realpath "$1")" /mnt/etc/nixos/configuration.nix
  # Generate the hardware specific configuration
  echo "Generate hardware configuration for /mnt"
  nixos-generate-config --root /mnt --dir /etc/nixos
  read -p "Before continuing, ensure that configuration in /mnt/etc/nixos/ is fine"
  read -p "Also ensure that eventual config submodules are present"
  # Install and configure the system
  echo "Install a new NixOS system on /mnt"
  nixos-install -v --root /mnt
  CONFIG_USER="" # Define configurer user of newly installed system
  read -p "User responsible of the installed configuration ? " CONFIG_USER
fi

# Perform specific config if main user responsible of configuration
if [ $CONFIG_USER != "" ]; then
  echo "Clone config in /home/$CONFIG_USER/.bare git repository"
  git clone --bare https://gitlab.com/gfauredev/nixos-configuration.git /mnt/home/$CONFIG_USER/.bare
  echo "Do not show untracked files in /home/$CONFIG_USER/.bare git status"
  git --git-dir=/mnt/home/$CONFIG_USER/.bare/ --work-tree=/mnt/home/$CONFIG_USER/ config status.showUntrackedFiles no
  echo "Checkout config of /home/$CONFIG_USER/.bare git repository"
  git --git-dir=/mnt/home/$CONFIG_USER/.bare/ --work-tree=/mnt/home/$CONFIG_USER/ checkout main
  echo "Symlinking /mnt/$CONFIG_USER/.config/nix/$(basename "$1") to /mnt/etc/nixos/configuration.nix"
  sudo ln -fs /mnt/$CONFIG_USER/.config/nix/$(basename "$1") /mnt/etc/nixos/configuration.nix
fi
