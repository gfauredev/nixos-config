{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      keyd # Package to access commands and man pages
      # kanata-with-cmd # Package to access commands and man pages
      # hyprkan # Not packaged yet, see https://github.com/mdSlash/hyprkan
    ];

  services = {
    keyd = {
      # See man keyd(1)
      enable = true; # A key remapping daemon for linux (C)
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            # global.layer_indicator = 1; # Turn on capslock led when layer
            main = {
              capslock = "overload(control, esc)";
              space = "lettermod(spacemode, space, 150, 200)";
            };
            "spacemode:C" = {
              # BÉPO Vim-like (Helix-like) motions
              h = "left";
              j = "down";
              k = "up";
              l = "right";
              b = "C-left";
              w = "C-right"; # TODO improve
              e = "C-right"; # TODO improve
              enter = "menu";
              # m = "pagedown";
              # i = "pageup";
              # "0" = "home";
              # "4" = "end";
              # shift = "oneshot(shift)";
            };
            "spacemode+shift" = { # Big movements
              c = "home";
              t = "pagedown";
              s = "pageup";
              r = "end";
            };
          };
        };
      };
    };
    kanata = {
      enable = false; # Modern advanced keyboard remapping TEST me
      # See https://github.com/jtroo/kanata/tree/main/docs
      # keyboards.all = {
      #   config = "";
      #   extraDefCfg = "";
      #   extraArgs = "";
      #   port = null; # u16
      # };
    };
    input-remapper.enable = false; # Easy remap input device buttons (Python)
    evdevremapkeys.enable = false; # Daemon remap events input devices (Python)
  };
}
