{ pkgs, ... }:
{
  services = {
    keyd.enable = true; # A key remapping daemon for Linux, see man keyd(1)
    kanata.enable = false; # Modern advanced keyboard remapping, see https://github.com/jtroo/kanata/tree/main/docs TEST
    input-remapper.enable = false; # Easy remap input device buttons (Python)
    evdevremapkeys.enable = false; # Daemon remap events input devices (Python)
    keyd = {
      keyboards = {
        default = {
          ids = [ "*" ];
          settings =
            let
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
              };
              control = {
                # Control shortcuts
                "," = "oneshot(goto)"; # GO TO mode (g)
                enter = "menu";
                "/" = "C-f"; # Search
                d = "left"; # "insert" (deselects)
                a = "right"; # "append" (deselects)
              };
              exit = {
                # Exit this mode
                d = "macro(left clear())"; # "insert" (deselects)
                a = "macro(right clear())"; # "append" (deselects)
                capslock = "clear()"; # Leave helix like mode (the default)
                esc = "clear()"; # Leave helix like mode (the default)
                space = "clear()"; # Leave helix like mode (the default)
              };
              plane-mode = "rfkill toggle all"; # Disable every wireless
              brightness = {
                raise = "${pkgs.brightnessctl}/bin/brightnessctl set 1%+"; # "light -A 1";
                RAISE = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+"; # "light -A 5";
                lower = "${pkgs.brightnessctl}/bin/brightnessctl set 1%-"; # "light -U 1";
                LOWER = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-"; # "light -U 5";
              };
              audio = {
                speaker.toggle = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; # Wireplumber
                speaker.raise = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"; # Wireplumber
                speaker.RAISE = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"; # Wireplumber
                speaker.lower = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"; # Wireplumber
                speaker.LOWER = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"; # Wireplumber
                mic.toggle = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; # Wireplumber
                mic.raise = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"; # Wireplumber
                mic.RAISE = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+"; # Wireplumber
                mic.lower = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-"; # Wireplumber
                mic.LOWER = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"; # Wireplumber
                play.toggle = "playerctl play-pause"; # -p ${config.media}";
                play.next = "playerctl next"; # -p ${config.media}";
                play.previous = "playerctl previous";
              };
            in
            {
              # global.layer_indicator = 1; # Turn on capslock led when layer
              main = {
                capslock = "overload(control, esc)";
                # TODO double tap toggle
                # "overload(control, timeout(oneshot(capslock), 80, esc))";
                # - press space, < 150ms, release space: type space
                # - press space, > 150ms, release space: noop
                # - press space, press a symbol: use a helixmode binding
                # - press a symbol, < 35ms, press space: type space
                space = "overloadi(space, overloadt2(helixmode, space, 150), 35)";
                mute = "command(${audio.speaker.toggle})";
                micmute = "command(${audio.mic.toggle})";
                playpause = "command(${audio.play.toggle})";
                play = "command(${audio.play.toggle})";
                pause = "command(${audio.play.toggle})";
                nextsong = "command(${audio.play.next})";
                previoussong = "command(${audio.play.previous})";
                rfkill = "command(${plane-mode})";
                brightnessup = "command(${brightness.RAISE})";
                brightnessdown = "command(${brightness.LOWER})";
                volumeup = "command(${audio.speaker.RAISE})";
                volumedown = "command(${audio.speaker.LOWER})";
              };
              shift = {
                mute = "command(${audio.mic.toggle})";
                micmute = "command(${audio.speaker.toggle})";
                brightnessup = "command(${brightness.raise})";
                brightnessdown = "command(${brightness.lower})";
                volumeup = "command(${audio.mic.RAISE})";
                volumedown = "command(${audio.mic.LOWER})";
              };
              control = {
                mute = "command(${audio.mic.toggle})";
                micmute = "command(${audio.speaker.toggle})";
                brightnessup = "command(${brightness.raise})";
                brightnessdown = "command(${brightness.lower})";
                volumeup = "command(${audio.speaker.raise})";
                volumedown = "command(${audio.speaker.lower})";
              };
              "control+shift" = {
                volumeup = "command(${audio.mic.raise})";
                volumedown = "command(${audio.mic.lower})";
              };
              # Capslock within 80ms of previous capslock enables Helix mode
              # capslock.capslock = "toggle(helixmode)"; # TODO
              helixmode = motionSelect // control;
              goto = {
                h = "home"; # Go to the line’s beginning
                l = "end"; # Go to the line’s end
                "," = "C-home"; # Go to the document’s beginning (g)
                f = "C-end"; # Go to the document’s end (e)
              }
              // exit;
            };
          # h = S-home # Selects to the line’s beginning
          # j = pagedown # One screen down
          # k = pageup # One screen up
          # l = S-end  # Selects to the line’s end
          extraConfig = ''
            [helixmode+shift]
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
  };
}
