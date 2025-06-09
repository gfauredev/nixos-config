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
          settings = let
            binds = {
              # Helix-like motions (adatpted to BÉPO keyboard layout)
              h = "left";
              j = "down";
              k = "up";
              l = "right";
              b = "C-S-left"; # Selects backwards until a whitespace
              e = "C-S-right"; # Selects forwards until a whitespace
              w = "C-S-right"; # Should select until letter preceded by space
              # Other shortcuts
              g = "oneshot(goto)"; # GO TO mode
              enter = "menu";
              # "/" = "C-f"; # Search
            };
          in {
            # global.layer_indicator = 1; # Turn on capslock led when layer
            main = {
              capslock = "overload(control, esc)";
              # "overload(control, timeout(oneshot(capslock), 80, esc))";
              # - press space, < 500ms, release space: type space
              # - press space, > 500ms, release space: noop
              # - press space, press a symbol: use a spacemode binding
              # - press a symbol, < 30ms, press space: type space
              space = "overloadi(space, overloadt2(spacemode, space, 500), 30)";
            };
            # Capslock within 80ms of previous capslock enables Helix mode
            # capslock.capslock = "toggle(helixmode)"; # TODO
            spacemode = binds; # Maintain space
            helixmode = binds // {
              # Exit this mode
              i = "clear()"; # Return to insert mode (the default)
              capslock = "clear()"; # Leave helix like mode (the default)
              esc = "clear()"; # Leave helix like mode (the default)
            };
            goto = {
              c = "home"; # Go to the line’s beginning
              r = "end"; # Go to the line’s end
              g = "C-home"; # Go to the document’s beginning
              e = "C-end"; # Go to the document’s end
            };
          };
          # c = S-home # Selects to the line’s beginning
          # t = pagedown # One screen down
          # s = pageup # One screen up
          # r = S-end  # Selects to the line’s end
          extraConfig = ''
            [spacemode+shift]
            c = S-home
            t = pagedown
            s = pageup
            r = S-end
          '';
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
