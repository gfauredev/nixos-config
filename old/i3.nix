{ pkgs, config, ... }: {
  xsession.windowManager.i3 =
    let
      term = "alacritty"; # Terminal command
      # term-exec = "${term} -e"; # Exec
      term-menu = "${term} --class menu"; # Menu term
      launch = "albert"; # Launcher
      mod = "Mod4"; # Keys used to work with windows
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
          "${mod}+Shift+Return" = "exec ${term-menu}";
          "${mod}+Control+Return" = "exec ${term-menu}";

          # kill focused window
          "${mod}+q" = "kill";
          # Reload the configuration file
          "${mod}+Shift+q" = "reload";
          "${mod}+Control+q" = "reload";
          # Exit i3 (logs out of i3 session, swaymsg compatible with i3)
          "${mod}+Control+Shift+q" = "exec swaymsg exit";
          # Lock & Suspend
          "${mod}+comma" = "exec i3lock -f -i $HOME/.lockscreen";
          "${mod}+Shift+comma" = "exec systemctl suspend";

          # Launch
          "${mod}+space" = "exec sh -c '${launch} toggle'";
          "${mod}+Shift+space" = "exec sh -c '${launch} settings'";
          "${mod}+Shift+m" = "exec ${term-menu} -e eva";
          "${mod}+o" = "exec ${term-menu} -e zsh -ic 'br'";
          "${mod}+Shift+o" = "exec ${term} --class xplr -e xplr";
          # Tools
          "${mod}+d" = "exec import -window root $HOME/img/$(date +'%Y-%m-%d_%H-%M-%S.png')";
          "${mod}+Shift+d" = "exec import $HOME/img/$(date +'%Y-%m-%d_%H-%M-%S.png')";
          "${mod}+m" = "exec ${term-menu} -e pulsemixer";
          "${mod}+Control+p" = "exec wl-color-picker";
          # Browsers
          "${mod}+Control+b" = "exec firefox";
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
          "${mod}+b" = "workspace 1:web; exec pgrep -i $BROWSER || $BROWSER";
          "${mod}+a" = "workspace 2:audio; exec pgrep -i ardour || ardour7";
          "${mod}+eacute" = "workspace 3:chat; exec pgrep -i discord || discord ; exec pgrep -i signal || signal-desktop";
          "${mod}+u" = "workspace 4:term; exec swaymsg -t get_tree | grep -i ${term} || ${term}";
          "${mod}+p" = "workspace 5:play; exec pgrep -i spotify || spotify";
          "${mod}+i" = "workspace 6:info; exec pgrep -i btm || ${term} --class btm -e btm";
          "${mod}+e" = "workspace 7:etc";
          "${mod}+n" = "workspace 8:note; exec swaymsg -t get_tree | grep -i 'class.*note' || exec ${term} --working-directory ~/note/ --class note -e note";
          "${mod}+Control+n" = "workspace 8:note; exec swaymsg -t get_tree | grep -i 'class.*note-tomorrow' || exec ${term} --working-directory ~/note/ --class note-tomorrow -e note tomorrow";
          "${mod}+Shift+Control+n" = "workspace 8:note; exec swaymsg -t get_tree | grep -i 'class.*note-yesterday' || exec ${term} --working-directory ~/note/ --class note-yesterday -e note yesterday";
          "${mod}+l" = "workspace 9:learn; exec pgrep -i anki || anki";
          # Move focused container to workspaces
          "${mod}+Shift+b" = "move container to workspace 1:web";
          "${mod}+Shift+a" = "move container to workspace 2:audio";
          "${mod}+Shift+eacute" = "move container to workspace 3:chat";
          "${mod}+Shift+u" = "move container to workspace 4:term";
          "${mod}+Shift+p" = "move container to workspace 5:play";
          "${mod}+Shift+i" = "move container to workspace 6:info";
          "${mod}+Shift+e" = "move container to workspace 7:etc";
          "${mod}+Shift+n" = "move container to workspace 8:note";
          "${mod}+Shift+l" = "move container to workspace 9:learn";

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
          "XF86KbdBrightnessUp" = "exec light -A 5";
          "XF86KbdBrightnessDown" = "exec light -U 5";
          "Shift+XF86KbdBrightnessUp" = "exec light -A 2";
          "Shift+XF86KbdBrightnessDown" = "exec light -U 2";
          "Control+XF86KbdBrightnessUp" = "exec light -A 1";
          "Control+XF86KbdBrightnessDown" = "exec light -U 1";

          # Music controls
          "XF86AudioPause" = "exec playerctl play-pause";
          "Shift+XF86AudioPause" = "exec playerctl play-pause -p spotify";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "Shift+XF86AudioPlay" = "exec playerctl play-pause -p spotify";
          "XF86AudioNext" = "exec playerctl next";
          "Shift+XF86AudioNext" = "exec playerctl next -p spotify";
          "XF86AudioPrev" = "exec playerctl previous";
          "Shift+XF86AudioPrev" = "exec playerctl previous -p spotify";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "Shift+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -2%";
          "Control+XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -1%";
          "Control+Shift+XF86AudioLowerVolume" = "exec set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "Shift+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +2%";
          "Control+XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +1%";
          "Control+Shift+XF86AudioRaiseVolume" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "Shift+XF86AudioMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "Shift+XF86AudioMicMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        };
        fonts = {
          # names = [ "Fira Code" ];
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
          # { command = "picom"; }
          # { command = "xcompmgr"; }
          # { command = "xbanish"; }
          { command = "autotiling --limit 4"; }
          { command = "gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'"; }
          { command = "feh --bg-fill $HOME/.wallpaper"; }
          { command = "albert"; }
          { command = "xset r rate 250 50"; }
          { command = "${term-menu} -e sh -c up"; }
          # { command = "${term-menu} -e sh -c veramount"; }
        ];
        defaultWorkspace = "workspace 7:etc";
        window = {
          titlebar = false;
        };
        bars = [
          {
            fonts = {
              # names = [ "Fira Code" ];
              names = [ "FiraCode Nerd Font" ];
              style = "Light";
              size = 10.0;
            };
            extraConfig = ''
              status_command ${pkgs.i3status-rust}/bin/i3status-rs $HOME/.config/i3status-rust/config-bottom.toml
              strip_workspace_numbers yes
            '';
          }
        ];
      };
      extraConfig = ''
        for_window [class="menu"] floating enable, resize set width 888 px height 420 px
      '';
    };
}
