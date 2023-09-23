{ inputs, lib, config, pkgs, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    # plugins = [ ];
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = [
        "eDP-1,2256x1504,0x0,1.4"
        "DP-1,3440x1440,0x0,1.25"
        ",preferred,auto,auto"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords
      exec-once = [
        "hyprpaper"
        "hyprctl setcursor Nordzy-cursors 24"
        "waybar"
        "cerebro" # General purpose launcher
        # "wezterm-mux-server" # TEST relevance
      ];
      env = [
        "XCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1" # Enable wayland support for some apps
        "WLR_NO_HARDWARE_CURSORS,1" # FIX for invisible cursor
        "SDL_VIDEODRIVEVER,wayland" # Force some apps to use Wayland SDL
        # "SDL_VIDEODRIVEVER,x11" # Apply it to specific programs instead
      ];

      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      workspace = [
        "name:cli,monitor:eDP-1,default:true"
        "name:etc,monitor:DP-1,default:true"
        # "name:etc,monitor:DP-2,default:true"
        # "name:etc,monitor:HDMI-A-1,default:true"
        # "name:etc,monitor:HDMI-A-2,default:true"
      ];

      # See https://wiki.hyprland.org/Configuring/Variables
      input = {
        kb_layout = "fr,us,fr";
        kb_variant = "bepo_afnor,,";
        kb_options = "grp:ctrls_toggle";
        repeat_delay = "250";
        repeat_rate = "50";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };

      # See https://wiki.hyprland.org/Configuring/Dwindle-Layout
      dwindle = {
        pseudotile = true; # master switch for pseudotiling TEST
        preserve_split = true; # you probably want this
      };
      # See https://wiki.hyprland.org/Configuring/Master-Layout
      master = {
        new_is_master = false; # TEST
      };

      # See https://wiki.hyprland.org/Configuring/Window-Rules
      # examplerule = float,class:^(term)$,title:^(term)$

      # See https://wiki.hyprland.org/Configuring/Keywords
      "$mod" = "SUPER";
      bind = [
        # Move focus
        "$mod, c, movefocus, l" # Move left
        "$mod, t, movefocus, d" # Move down
        "$mod, s, movefocus, u" # Move up
        "$mod, r, movefocus, r" # Move right
        # Move window
        "$mod SHIFT, c, movewindow, l" # Move left
        "$mod SHIFT, t, movewindow, d" # Move down
        "$mod SHIFT, s, movewindow, u" # Move up
        "$mod SHIFT, r, movewindow, r" # Move right
        # Workspaces (Left)
        "$mod, b, workspace, name:web" # Browsing workspace
        "$mod, b, exec, hyprctl clients | grep -i 'class: brave-browser' || brave" # Auto open browser if not running
        # /!\ Cannot move to Browsing worspace
        "$mod, a, workspace, name:aud" # Audio workspace
        "$mod SHIFT, a, movetoworkspace, name:aud" # Audio workspace
        "$mod, i, workspace, name:top" # Informations / monItorIng
        "$mod, i, exec, hyprctl clients | grep -i 'class: monitoring' || wezterm start --class monitoring btm" # Auto open bottom if not running
        # /!\ Cannot move to Monitoring worspace
        "$mod, e, workspace, name:etc" # Etc / Extra workspace
        "$mod SHIFT, e, movetoworkspace, name:etc" # Etc / Extra
        # Workspaces (Right)
        "$mod, l, workspace, name:cli" # cLi / terminaL workspace
        "$mod, l, exec, hyprctl clients | grep -i 'title: zsh' || wezterm start" # Auto open CLI if not running
        "$mod SHIFT, l, movetoworkspace, name:cli" # cLi / terminaL
        "$mod, n, workspace, name:not" # Notetaking workspace
        "$mod, n, exec, hyprctl clients | grep -i 'class: note' || wezterm start --cwd ~/note --class note $EDITOR" # Auto open text editor
        "$mod SHIFT, n, movetoworkspace, name:not" # Notetaking
        "$mod, m, workspace, name:msg" # Messaging workspace
        # "$mod, m, exec, hyprctl clients | grep -i 'title: element' || element-desktop" # Auto open messaging
        "$mod, m, exec, hyprctl clients | grep -i 'title: discord' || discord" # Auto open main messaging
        "$mod SHIFT, m, movetoworkspace, name:msg" # Messaging
        # Workspaces (Special)
        ", XF86AudioMedia, workspace, name:med" # Media ws
        ", XF86AudioMedia, exec, hyprctl clients | grep -i 'title: spotify' || spotify" # Auto open main media player
        "SHIFT, XF86AudioMedia, workspace, name:med" # Media ws
        "SHIFT, XF86AudioMedia, exec, hyprctl clients | grep -i 'title: Easy Effects' || easyeffects" # Auto open audio tweaker
        "CONTROL, XF86AudioMedia, workspace, name:med" # Media ws
        "CONTROL, XF86AudioMedia, exec, hyprctl clients | grep -i 'class: org.pipewire.Helvum' || helvum" # Auto open audio router
        ", XF86Tools, workspace, name:med" # Media ws
        ", XF86Tools, exec, hyprctl clients | grep -i 'title: spotify' || spotify" # Auto open main media player
        "SHIFT, XF86Tools, workspace, name:med" # Media ws
        "SHIFT, XF86Tools, exec, hyprctl clients | grep -i 'title: Easy Effects' || easyeffects" # Auto open audio tweaker
        "CONTROL, XF86Tools, workspace, name:med" # Media ws
        "CONTROL, XF86Tools, exec, hyprctl clients | grep -i 'class: org.pipewire.Helvum' || helvum" # Auto open audio router
        # /!\ Cannot move to Media worspace
        # Terminal # TODO test multiplexing, features of wezterm
        "$mod, RETURN, exec, ${pkgs.wezterm}/bin/wezterm start"
        # Launch
        "$mod, SPACE, exec, rofi -show-icons -show combi -combi-modes window,file-browser-extended,drun,emoji"
        "$mod CONTROL, SPACE, exec, rofi -show calc"
        "$mod SHIFT, SPACE, exec, rofi -show-icons -show combi -combi-modes top,ssh,run"
        # Manage windows
        "$mod, f, togglefloating," # Float window
        "$mod, w, fullscreen," # Fullscreen window
        "$mod, q, killactive," # Close window
        # System control
        "$mod CONTROL SHIFT, q, exit," # Close wayland session
        "$mod, comma, exec, swaylock -f -i $HOME/.wallpapers/desert.jpg"
        "$mod SHIFT, comma, exec, systemctl suspend"
        # Web
        "$mod CONTROL, b, exec, nyxt" # Firefox
        "$mod SHIFT, b, exec, firefox" # Nyxt
        "$mod CONTROL SHIFT, b, exec, chromium" # Chromium
        # Audio
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "SHIFT, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "SHIFT, XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        # Media
        ", XF86AudioPlay, exec, playerctl play-pause"
        "SHIFT, XF86AudioPlay, exec, playerctl play-pause -p spotify"
        ", XF86AudioPause, exec, playerctl play-pause"
        "SHIFT, XF86AudioPause, exec, playerctl play-pause -p spotify"

        ", XF86AudioNext, exec, playerctl next"
        "SHIFT, XF86AudioNext, exec, playerctl next -p spotify"
        ", XF86AudioPrev, exec, playerctl previous"
        "SHIFT, XF86AudioPrev, exec, playerctl previous -p spotify"
        # Misc
        ", Print, exec, grim -g \"$(slurp)\" $HOME/img/$(date +'%Y-%m-%d_%Hh%Mm%Ss.png')"
        "SHIFT, Print, exec, grim $HOME/img/$(date +'%Y-%m-%d_%Hh%Mm%Ss.png')"
        "$mod, p, exec, hyprpicker --autocopy"
        ", XF86RFKill, exec, rfkill toggle 0 1"
      ];
      bindle = [
        # Resize windows
        "$mod CONTROL, c, resizeactive, -10 0" # Move left
        "$mod CONTROL, t, resizeactive, 0 10" # Move down
        "$mod CONTROL, s, resizeactive, 0 -10" # Move up
        "$mod CONTROL, r, resizeactive, 10 0" # Move right
        # Brightness
        ",XF86MonBrightnessUp, exec, light -A 5"
        ",XF86MonBrightnessDown, exec, light -U 5"
        "SHIFT, XF86MonBrightnessUp, exec, light -A 2"
        "SHIFT, XF86MonBrightnessDown, exec, light -U 2"
        "CONTROL, XF86MonBrightnessUp, exec, light -A 1"
        "CONTROL, XF86MonBrightnessDown, exec, light -U 1"
        # Audio
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "CONTROL, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+"
        "CONTROL SHIFT, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+"

        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "CONTROL, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
        "SHIFT, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"
        "CONTROL SHIFT, XF86AudioLowerVolume, exec, set-volume @DEFAULT_AUDIO_SINK@ 1%-"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
      ];

      # See https://wiki.hyprland.org/Configuring/Variables
      general = {
        gaps_in = 2;
        gaps_out = 3;
        border_size = 2;
        layout = "dwindle";
        cursor_inactive_timeout = 1;
        "col.active_border" = "rgba(ffddccee) rgba(997766ee) 45deg";
        "col.inactive_border" = "rgba(000000ee)";
      };

      # See https://wiki.hyprland.org/Configuring/Variables
      gestures = {
        workspace_swipe = true;
      };

      decoration = {
        rounding = 5;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      # See https://wiki.hyprland.org/Configuring/Animations
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        # disable_hypr_chan = true;
      };
    };
    systemdIntegration = true; # TEST relevance
    xwayland.enable = true;
  };

  xdg.configFile = {
    hyprpaper = {
      target = "hypr/hyprpaper.conf";
      source = ../script+data/hyprpaper.conf;
    };
  };
}
