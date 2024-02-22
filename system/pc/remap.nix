{ pkgs, ... }: {
  # environment.systemPackages = with pkgs; [
  #   keymapper # Context-aware key remapper
  #   autokey # Desktop automation utility for Linux and X11
  # ];

  services = {
    interception-tools = {
      enable = true;
      plugins = with pkgs; [
        interception-tools-plugins.caps2esc
      ];
      udevmonConfig = ''
        - JOB: ${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
        #SHELL: [zsh, -c]
        #---
        #- CMD: ${pkgs.interception-tools}/bin/mux -c ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc
        #- JOB: ${pkgs.interception-tools}/bin/mux -i ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | uinput -c /etc/nixos/keyboard.yaml
        #- JOB: intercept -g $DEVNODE | ${pkgs.interception-tools}/bin/mux -o caps2esc
        #  DEVICE:
        #    LINK: /dev/input/by-path/platform-i8042-serio-0-event-kbd
        #- JOB: intercept $DEVNODE | ${pkgs.interception-tools}/bin/mux -o caps2esc
        #  DEVICE:
        #    LINK: /dev/input/by-path/platform-i8042-serio-1-event-mouse
      '';
    };
    input-remapper = {
      enable = true; # Easy tool to change mapping of input device buttons
    };
    keyd = {
      enable = false; # A key remapping daemon for linux
    };
    evdevremapkeys = {
      enable = false; # Daemon to remap events on linux input devices
    };
  };
}
