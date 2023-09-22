{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    element-desktop # Matrix messaging
    signal-desktop # Secure messaging
    # element-web # Matrix messaging
    mailspring # Email client
    discord # PROPRIETARY messaging and general communication
    # discord-canary # PROPRIETARY messaging and general communication
    # teams-for-linux # PROPRIETARY services messaging and work
    # zoom         # PROPRIETARY messaging and work
  ];
}
