{ config, pkgs, ... }:

{
  services = {
    httpd = {
      enable = true;
      adminAddr = "pro@gfaure.eu";
      enablePHP = true;
      user = "wwwrun";
      group = "users";
      extraConfig = ''
        LogLevel alert rewrite:trace6
      '';

      virtualHosts = {
        # "admin.localhost" = {
        #   documentRoot = "/srv/admin.localhost";
        #   forceSSL = false;
        #   locations = {
        #     "/" = {
        #       index = "index.php";
        #     };
        #   };
        #   listen = [
        #     {
        #       port = 80;
        #     }
        #   ];
        # };
        "localhost" = {
          documentRoot = "/srv/localhost";
          serverAliases = [
            "*.localhost"
          ];
          listen = [
            {
              port = 80;
            }
          ];
          extraConfig = ''
            <Directory "/srv/localhost">
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
      phpPackage = pkgs.php.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          # xdebug
        ]));
        extraConfig = ''
          xdebug.mode = develop,coverage,debug,trace
          xdebug.start_with_request = yes
          session.cookie_samesite="Strict"
        '';
      };
    };
    # surrealdb = {
    #   enable = true;
    #   userNamePath = private/username;
    #   passwordPath = private/password;
    # };
    # nginx = {
    #   enable = true;
    # };
    mysql = {
      enable = true;
      package = pkgs.mariadb;
      settings = {
        mysqld = {
          lc-time-names = "fr_FR";
        };
      };
    };
    # mongodb = {
    #   enable = true;
    # };
    # elasticsearch = {
    #   enable = true;
    #   package = pkgs.elasticsearch7;
    #   cluster_name = "cluster";
    #   listenAddress = "localhost";
    #   extraConf = ''
    #     xpack.security.enabled: false
    #   '';
    # };
    # kibana = {
    #   enable = true;
    #   listenAddress = "localhost";
    #   elasticsearch.hosts = [
    #     "http://localhost:9200"
    #   ];
    # };
  };

  environment = {
    systemPackages = with pkgs; [
      php
      php81Extensions.pdo_mysql
      php81Extensions.mysqli
      # elasticsearch
    ];
  };
}
