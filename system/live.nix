{
  pkgs,
  user,
  ...
}: # Live ISO to install NixOS
{
  imports = [ ./default.nix ];

  networking.hostname = "LiveNixOS";

  boot.supportedFilesystems = [
    "btrfs"
    "bcachefs"
    "zfs"
  ];

  # networking.wireless.enable = false;

  systemd = {
    services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
    targets = {
      sleep.enable = false;
      suspend.enable = false;
      hibernate.enable = false;
      hybrid-sleep.enable = false;
    };
  };

  services = {
    openssh.enable = true; # Enable the OpenSSH daemon
    nfs.server.enable = true; # Share files across network
    qemuGuest.enable = true; # To use inside VMs
    openssh = {
      settings.PermitRootLogin = "yes"; # Easily login as root via SSH
      settings.PasswordAuthentication = true;
    };
  };

  programs.git.config."user" = {
    email = user.email;
    name = user.fullname;
  };

  # environment.systemPackages = [
  #   (pkgs.writeShellScriptBin "cfg" ''
  #     git clone https://gitlab.com/gfauredev/nixos-config.git
  #   '')
  # ];
}
