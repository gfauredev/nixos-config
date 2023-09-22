{ inputs, lib, config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  # hardware.enableAllFirmware = true;

  networking.wireless.enable = false;

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          email = "pro@gfaure.eu";
          name = "Guilhem Fauré";
        };
      };
    };
  };

  environment = {
    shellAliases = {
      clone = "git clone https://gitlab.com/gfauredev/nixos-config.git"; # Easilly clone this repo
      clone-ssh = "git clone git@gitlab.com:gfauredev/nixos-config.git"; # Easilly clone this repo with SSH
    };
  };

  # users.users.nixos = {
  #   password = "password"; # Directly able to login via SSH
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  # };

  # services = {
  #   openssh = {
  #     enable = true; # Enable the OpenSSH daemon
  #     settings = {
  #       PermitRootLogin = "yes"; # We want to easily configure headlessly
  #       PasswordAuthentication = true;
  #     };
  #   };
  #   nfs.server.enable = lib.mkDefault true;
  # };
}
