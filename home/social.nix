{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    thunderbird # Popular desktop email and calendar client
    # evolution # Popular desktop email and calendar client
    himalaya # CLI mail client # Configure via home manager module
    # element-desktop # Matrix messaging
    signal-desktop # Secure messaging
    # element-web # Matrix messaging
    # mailspring # Email client WARNING security issue
    # UNFREE #
    discord # PROPRIETARY messaging and general communication
    whatsapp-for-linux # PROPRIETARY messaging and general communication
    # discord-canary # PROPRIETARY messaging and general communication
    # teams-for-linux # PROPRIETARY services messaging and work
    # zoom         # PROPRIETARY messaging and work
  ];

  # TODO configure this
  # accounts = {
  #   calendar = { };
  #   email.accounts = {
  #     pro = {
  #       primary = true;
  #       himalaya = {
  #         enable = true;
  #         settings = {
  #           email = lib.readFile /run/agenix/pro-email;
  #         };
  #       };
  #     };
  #   };
  # };


  # services = {
  #   himalaya-notify = {
  #     environment = {
  #       "PASSWORD_STORE_DIR" = "~/.password-store";
  #     };
  #     settings = {
  #       account = "pro";
  #     };
  #   };
  #   himalaya-watch = {
  #     enable = true;
  #     environment = {
  #       "PASSWORD_STORE_DIR" = "~/.password-store";
  #     };
  #     settings = {
  #       account = "pro";
  #     };
  #   };
  # };

  programs = {
    # himalaya = {
    #   enable = true; # CLI Mail client # TODO config with sops secrets
    #   settings = {
    #     signature = "Guilhem Fauré";
    #     downloads-dir = "";
    #   };
    # };
    # thunderbird = { # TODO config with sops secrets
    #   enable = true;
    # };
  };
}
