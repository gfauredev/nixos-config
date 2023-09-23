# Minimal i3 config to work with legacy programs
{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # i3lock # Screen locker
    # autotiling # Simulate dwindle layout on sway and i3
  ];

  xsession.windowManager.i3 =
    let
      term = "alacritty"; # Terminal command
      mod = "Mod4";
      left = "c";
      down = "t";
      up = "s";
      right = "r";
    in
    {
      enable = true;
      package = pkgs.i3-gaps;
      config = {
        keybindings = {
          # Start a terminal
          "${mod}+Return" = "exec ${term}";
          # Launch
          "${mod}+space" = "exec \"rofi -show-icons -show combi -combi-modes window,file-browser-extended,drun,emoji\"";
          "${mod}+Control+space" = "exec rofi -show calc";
          "${mod}+Shift+space" = "exec \"rofi -show-icons -show combi -combi-modes top,ssh,run\"";
          # kill focused window
          "${mod}+q" = "kill";
          # Exit i3
          "${mod}+Control+Shift+q" = "exec i3-msg exit";
          # Reload the configuration file
          "${mod}+Shift+q" = "reload";
          "${mod}+Control+q" = "reload";
          # Suspend
          "${mod}+Shift+comma" = "exec systemctl suspend";
          # Tools
          "${mod}+d" = "exec import -window root $HOME/img/$(date +'%Y-%m-%d_%H-%M-%S.png')";
          "${mod}+Shift+d" = "exec import $HOME/img/$(date +'%Y-%m-%d_%H-%M-%S.png')";
          # Browsers
          "${mod}+b" = "exec brave";
          "${mod}+Control+b" = "exec firefox";
          "${mod}+Shift+b" = "exec chromium";
          # Move focus around
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";
          # Move focused window inside workspace
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";
          # Resize focused window
          "${mod}+Control+${up}" = "resize grow height 10px";
          "${mod}+Control+${down}" = "resize shrink height 10px";
          "${mod}+Control+${right}" = "resize grow width 10px";
          "${mod}+Control+${left}" = "resize shrink width 10px";
          # Switch to workspace
          "${mod}+a" = "workspace 1:a";
          "${mod}+u" = "workspace 2:u";
          "${mod}+i" = "workspace 3:i";
          "${mod}+e" = "workspace 4:e";
          # Move focused container to workspaces
          "${mod}+Shift+a" = "move container to workspace 1:a";
          "${mod}+Shift+u" = "move container to workspace 2:u";
          "${mod}+Shift+i" = "move container to workspace 3:i";
          "${mod}+Shift+e" = "move container to workspace 4:e";
          # Layout
          "${mod}+h" = "layout toggle stacking tabbed"; # Stacking/Tabbed
          "${mod}+g" = "layout toggle splith splitv"; # Vert/Hor
          # Toggle between tiling and floating
          "${mod}+f" = "floating toggle";
          "${mod}+dead_circumflex" = "focus mode_toggle";
          # Move inside windows tree
          "${mod}+z" = "focus parent";
          "${mod}+j" = "focus child";
          # Make the current focus fullscreen
          "${mod}+w" = "fullscreen toggle";

          # Brightness controls
          "XF86MonBrightnessUp" = "exec light -A 5";
          "XF86MonBrightnessDown" = "exec light -U 5";
          "Shift+XF86MonBrightnessUp" = "exec light -A 2";
          "Shift+XF86MonBrightnessDown" = "exec light -U 2";
          "Control+XF86MonBrightnessUp" = "exec light -A 1";
          "Control+XF86MonBrightnessDown" = "exec light -U 1";
          # Music controls
          "XF86AudioPlay" = "exec playerctl play-pause";
          "Shift+XF86AudioPlay" = "exec playerctl play-pause -p spotify";
          "XF86AudioPause" = "exec playerctl play-pause";
          "Shift+XF86AudioPause" = "exec playerctl play-pause -p spotify";
          "XF86AudioNext" = "exec playerctl next";
          "Shift+XF86AudioNext" = "exec playerctl next -p spotify";
          "XF86AudioPrev" = "exec playerctl previous";
          "Shift+XF86AudioPrev" = "exec playerctl previous -p spotify";
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "Control+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
          "Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          "Control+Shift+XF86AudioRaiseVolume" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "Control+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          "Shift+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          "Control+Shift+XF86AudioLowerVolume" = "exec set-mute @DEFAULT_AUDIO_SOURCE@ 1%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "Shift+XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "Shift+XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        fonts = {
          names = [ "FiraCode Nerd Font" ];
          style = "Light";
          size = 10.0;
        };
        gaps = {
          inner = 3;
          smartBorders = "on";
          smartGaps = false;
        };
        floating.modifier = mod;
        startup = [
          # { command = "autotiling --limit 4"; }
          { command = "xset r rate 250 50"; }
        ];
        defaultWorkspace = "workspace 1:a";
        window.titlebar = false;
      };
    };
}
