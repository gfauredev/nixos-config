{ self, pkgs, ... }: # Live ISO to install NixOS
{
  imports = [ ./default.nix ];

  networking.hostName = "LiveNixOS";
  networking.hostId = "acabacab";

  users.extraUsers.root.password = "root";
  users.users.nixos.password = "nixos";

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
    etc.flake.source = self; # Put the actual Flake repo inside the ISO
    systemPackages = [
      (pkgs.writeShellScriptBin "cfg" ''
        cd /etc/flake
      '')
      # git clone https://gitlab.com/gfauredev/nixos-config.git
    ];
  };
}
