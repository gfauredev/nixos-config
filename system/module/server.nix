{ lib, ... }:
{
  services = {
    nfs.server.enable = lib.mkDefault true;
    openssh = {
      enable = lib.mkDefault true; # Do not enable the OpenSSH daemon by default
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        LogLevel = "VERBOSE"; # For fail2ban
        PasswordAuthentication = lib.mkDefault true;
      };
    };
    fail2ban.enable = lib.mkDefault true;
  };
}
