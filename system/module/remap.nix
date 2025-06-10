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
            # TODO BÉPO layout
            motionSelect = {
              # Helix-like motions (adapted to BÉPO keyboard layout)
              h = "left";
              j = "down";
              k = "up";
              l = "right";
              q = "macro(left C-S-left)"; # Select backward until space
              f = "macro(right C-S-right)"; # Select forward until space
              # TODO should select until letter preceded by space instead
              "]" = "macro(right C-S-right)"; # Select forward until space
              d = "left"; # "insert" (deselects)
              a = "right"; # "append" (deselects)
            };
            control = {
              # Other shortcuts
              "," = "oneshot(goto)"; # GO TO mode (g)
              enter = "menu";
              # "/" = "C-f"; # Search
            };
            exit = {
              # Exit this mode
              d = "clear()"; # Return to insert mode (the default)
              capslock = "clear()"; # Leave helix like mode (the default)
              esc = "clear()"; # Leave helix like mode (the default)
            };
          in {
            # global.layer_indicator = 1; # Turn on capslock led when layer
            main = {
              capslock = "overload(control, esc)";
              # "overload(control, timeout(oneshot(capslock), 80, esc))";
              # - press space, < 150ms, release space: type space
              # - press space, > 150ms, release space: noop
              # - press space, press a symbol: use a spacemode binding
              # - press a symbol, < 35ms, press space: type space
              space = "overloadi(space, overloadt2(helixmode, space, 150), 35)";
            };
            # Capslock within 80ms of previous capslock enables Helix mode
            # capslock.capslock = "toggle(helixmode)"; # TODO
            helixmode = motionSelect // control // exit;
            goto = {
              h = "home"; # Go to the line’s beginning
              l = "end"; # Go to the line’s end
              "," = "C-home"; # Go to the document’s beginning (g)
              f = "C-end"; # Go to the document’s end (e)
            } // exit;
          };
          # h = S-home # Selects to the line’s beginning
          # j = pagedown # One screen down
          # k = pageup # One screen up
          # l = S-end  # Selects to the line’s end
          extraConfig = ''
            [spacemode+shift]
            q=S-home
            h=S-left
            j=pagedown
            k=pageup
            l=S-right
            f=S-end
            ]=S-end

            [goto+shift]
            h=S-home
            l=S-end
            ,=C-S-home
            f=C-S-end
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
