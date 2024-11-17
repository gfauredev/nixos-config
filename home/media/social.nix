{ pkgs, ... }: {
  # pkgs.config.allowUnfreePredicate = pkg:
  #   builtins.elem (lib.getName pkg) [ "discord" ];

  home.packages = with pkgs; [
    # Email
    thunderbird # Popular desktop email and calendar client TODO configure it
    # evolution # Desktop email and calendar client
    # himalaya # CLI mail client # Configure via home manager module
    # mailspring # Email client WARNING security issue
    # Messaging, Calls, Video
    signal-desktop # Secure messaging
    # signal-cli # Secure messaging
    element-desktop # Secure group messaging and calls
    # element-web # Secure messaging and calls
    olvid # French secure messaging
    discord # PROPRIETARY messaging and general communication
  ];

  # TODO setup secret Nix storage like sops or agenix
  # TODO configure Thunderbird with Nix
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

  # services = { # TODO enable without annoying prompt at login
  #   keybase.enable = true; # Identity and public key cryptography
  #   kbfs = {
  #     enable = true; # Keybase Filesystem
  #     mountPoint = "data.local/keybase";
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
