{ pkgs, lib, ... }: # Live ISO to install NixOS
{
  imports = [
    ./default.nix
    ./module/pc.nix
  ];

  networking.hostName = "LiveNixOS";
  networking.hostId = "acabacab";

  users.extraUsers.root = rec {
    initialHashedPassword = lib.mkForce null;
    hashedPassword = initialHashedPassword;
    initialPassword = "root";
    password = initialPassword;
    # hashedPasswordFile = null;
  };
  users.users.nixos = rec {
    initialHashedPassword = lib.mkForce null;
    hashedPassword = initialHashedPassword;
    initialPassword = "nixos";
    password = initialPassword;
    # hashedPasswordFile = null;
  };

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  networking.wireless.enable = false; # Prefer NetworkManager

  services = {
    openssh.enable = true; # Enable the OpenSSH daemon
    nfs.server.enable = true; # Share files across network
    qemuGuest.enable = true; # To use inside VMs
    openssh = {
      settings.PermitRootLogin = "yes"; # Easily login as root via SSH
      settings.PasswordAuthentication = true;
    };
  };

  environment = {
    # TODO parametric, global Flake location (/etc/flake)
    # TODO configure.sh able to install NixOS from live ISO, autodect situation
    shellAliases.nixos = "cd /etc/flake; nixos-install-helper";
    systemPackages = [
      (pkgs.writeShellScriptBin "nixos-install-helper" ''
        grep '### _1._' -A 42 public/README.md
      '')
      # git clone https://gitlab.com/gfauredev/nixos-config.git
    ];
  };
}
