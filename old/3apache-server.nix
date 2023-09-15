{ config, pkgs, ... }:
let
  domain = "domain.tld";
in
{
  imports = [
    ./common.nix # Common settings between hosts
  ];

  system.stateVersion = "22.11";

  networking = {
    hostName = "gfHttpServer"; # hostname
    defaultGateway = "192.168.1.1";
    interfaces.ens18 = {
      # wakeOnLan.enable = true;
      ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_hardened;
    # kernelPackages = pkgs.linuxPackages_custom_tinyconfig_kernel;
    initrd.checkJournalingFS = false;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "pro@gfaure.eu";
  };

  services = {
    httpd = {
      enable = true;
      adminAddr = "pro@gfaure.eu";
      enablePHP = true;
      user = "wwwrun";
      extraConfig = ''
        LogLevel alert rewrite:trace6
      '';

      virtualHosts = {
        "admin.${domain}" = {
          documentRoot = "/srv/admin";
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              index = "index.php";
            };
          };
        };
        "${domain}" = {
          documentRoot = "/srv/sites";
          serverAliases = [
            "*.${domain}"
          ];
          forceSSL = true;
          enableACME = true;
          # listen = [
          #   {
          #     ssl = true;
          #     port = 443;
          #     ip = "*";
          #   }
          #   {
          #     ssl = false;
          #     port = 80;
          #     ip = "*";
          #   }
          # ];
          extraConfig = ''
            <Directory "/srv/sites">
              AllowOverride All
            </Directory>
          '';
          locations = {
            "/" = {
              index = "index.php index.html";
            };
          };
        };
      };
    };
  };

  users.users.root = {
    # Change this for real purposes 
    hashedPassword = "$y$j9T$atvxhqCe0PyyjJyBkyk/a0$nIg6rpjE8zt9Pj4uFY0/qwQF/ihwT.F12He.B/pn2PA";
  };

  # users.users.admin = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  #   hashedPassword = "$y$j9T$atvxhqCe0PyyjJyBkyk/a0$nIg6rpjE8zt9Pj4uFY0/qwQF/ihwT.F12He.B/pn2PA";
  # };

  environment = {
    systemPackages = with pkgs; [
      php
      php81Extensions.pdo_mysql
    ];
  };
}
