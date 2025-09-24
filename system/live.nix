{ pkgs, ... }: # Live ISO to install NixOS
{
  imports = [
    ./default.nix
    ./module/pc.nix
  ];

  networking.hostName = "LiveNixOS";
  networking.hostId = "acabacab";

  users.extraUsers.root = rec {
    initialHashedPassword = null;
    hashedPassword = null;
    initialPassword = "root";
    password = initialPassword;
    hashedPasswordFile = null;
  };
  users.users.nixos = rec {
    initialHashedPassword = null;
    hashedPassword = null;
    initialPassword = "nixos";
    password = initialPassword;
    hashedPasswordFile = null;
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
    shellAliases.cfg = "cd /etc/flake; configure";
    systemPackages = [
      (pkgs.writeShellScriptBin "configure" ''
        grep '### _1._' -A 31 public/README.md
      '')
      # git clone https://gitlab.com/gfauredev/nixos-config.git
    ];
  };
}
