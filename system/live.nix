{
  lib,
  user,
  ...
}:
{
  imports = [
    # "${pkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    ./default.nix
  ];

  boot.supportedFilesystems = {
    btrfs = true;
    # bcachefs = true;
    # zfs = true;
  };

  networking.wireless.enable = false;

  programs.git.config.user = {
    email = user.email;
    name = user.fullname;
  };

  # environment.systemPackages = [
  #   (pkgs.writeShellScriptBin "cfg" ''
  #     git clone https://gitlab.com/gfauredev/nixos-config.git
  #   '')
  # ];

  services = {
    openssh = {
      enable = true; # Enable the OpenSSH daemon
      settings.PermitRootLogin = "yes"; # Easily login as root via SSH
      settings.PasswordAuthentication = true;
    };
    nfs.server.enable = lib.mkDefault true;
  };
}
