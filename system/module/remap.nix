{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      keyd # Access commands and man pages
      # keymapper # Context-aware key remapper
      # autokey # Desktop automation utility for Linux and X11
    ];

  services = {
    keyd = {
      enable = true; # A key remapping daemon for linux (C)
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              space = "overloadt(spacemode, space, 200)";
            };
            "spacemode:C" = {
              h = "left";
              j = "down";
              m = "pagedown";
              k = "up";
              i = "pageup";
              l = "right";
              b = "C-left";
              w = "C-right";
              "0" = "home";
              "4" = "end";
              enter = "menu";
              shift = "oneshot(shift)";
            };
          };
        };
      };
    };
    input-remapper.enable = false; # Easy remap input device buttons (Python)
    evdevremapkeys.enable = false; # Daemon remap events input devices (Python)
    # interception-tools = {
    #   enable = false;
    #   plugins = with pkgs; [ interception-tools-plugins.caps2esc ];
    #   udevmonConfig = ''
    #     - JOB: ${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE
    #       DEVICE:
    #         EVENTS:
    #           EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    #     #SHELL: [zsh, -c]
    #     #---
    #     #- CMD: ${pkgs.interception-tools}/bin/mux -c ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc
    #     #- JOB: ${pkgs.interception-tools}/bin/mux -i ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | uinput -c /etc/nixos/keyboard.yaml
    #     #- JOB: intercept -g $DEVNODE | ${pkgs.interception-tools}/bin/mux -o caps2esc
    #     #  DEVICE:
    #     #    LINK: /dev/input/by-path/platform-i8042-serio-0-event-kbd
    #     #- JOB: intercept $DEVNODE | ${pkgs.interception-tools}/bin/mux -o caps2esc
    #     #  DEVICE:
    #     #    LINK: /dev/input/by-path/platform-i8042-serio-1-event-mouse
    #   '';
    # };
  };
}
