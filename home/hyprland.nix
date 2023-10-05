{ inputs, lib, config, pkgs, defaultMonitor ? "DP-1", ... }: {
  # { inputs, lib, config, pkgs, defaultMonitor, ... }: { FIXME
  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    # plugins = [ ];
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      # ninja or knight (laptop or desktop)
      monitor =
        if defaultMonitor == "eDP-1" then [
          "eDP-1,2256x1504,0x0,1.4" # Ninja internal monitor
          ",preferred,auto,1" # Externals monitor
          # ",preferred,auto,1,mirror,eDP-1" # Mirrored external monitors
        ] else [
          "DP-1,3440x1440,0x0,1.25" # Knight main monitor
          ",preferred,auto,1" # Others monitors
        ];

      # See https://wiki.hyprland.org/Configuring/Keywords
      exec-once = [
        "hyprpaper"
        "hyprctl setcursor Nordzy-cursors 24"
        "waybar"
        # "Cerebro" # General purpose launcher
        # "wezterm-mux-server" # TEST relevance
      ];
      env = [
        "NIXOS_OZONE_WL,1" # Enable wayland support for some apps
        "WLR_NO_HARDWARE_CURSORS,1" # FIX for invisible cursor
        "XCURSOR_SIZE,24"
        "SDL_VIDEODRIVEVER,wayland" # Force apps to use Wayland SDL
        # "SDL_VIDEODRIVEVER,x11" # Apply it to specific programs instead
        "GDK_SCALE,1.25" # Scaling on Xwayland
      ];

      # See https://wiki.hyprland.org/Configuring/Workspace-Rules
      # ninja or knight (laptop or desktop)
      workspace =
        if defaultMonitor == "eDP-1" then [
          "name:web,monitor:eDP-1,default:true"
          "name:dpp,monitor:DP-1,default:true"
          "name:hdm,monitor:HDMI-A-1,default:true"
          "name:ext,monitor:DP-2,default:true"
        ] else [
          "name:web,monitor:DP-1,default:true"
          "name:hdm,monitor:HDMI-A-1,default:true"
          "name:dpp,monitor:DP-2,default:true"
          "name:ext,monitor:HDMI-A-2,default:true"
        ];

      xwayland.force_zero_scaling = true;

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
        "$mod SHIFT, c, moveactive, -10 0" # Move floating left
        "$mod SHIFT, t, movewindow, d" # Move down
        "$mod SHIFT, t, moveactive, 0 10" # Move floating down
        "$mod SHIFT, s, movewindow, u" # Move up
        "$mod SHIFT, s, moveactive, 0 -10" # Move floating up
        "$mod SHIFT, r, movewindow, r" # Move right
        "$mod SHIFT, r, moveactive, 10 0" # Move floating right
        # "$mod SHIFT, c, movewindoworgroup, l" # Move left
        # "$mod SHIFT, t, movewindoworgroup, d" # Move down
        # "$mod SHIFT, s, movewindoworgroup, u" # Move up
        # "$mod SHIFT, r, movewindoworgroup, r" # Move right
        "$mod CONTROL SHIFT, c, moveintogroup, l" # Move left
        "$mod CONTROL SHIFT, t, moveintogroup, d" # Move down
        "$mod CONTROL SHIFT, s, moveintogroup, u" # Move up
        "$mod CONTROL SHIFT, r, moveintogroup, r" # Move right
        # "$mod CONTROL SHIFT, c, swapwindow, l" # Move left
        # "$mod CONTROL SHIFT, t, swapwindow, d" # Move down
        # "$mod CONTROL SHIFT, s, swapwindow, u" # Move up
        # "$mod CONTROL SHIFT, r, swapwindow, r" # Move right
        "$mod, g, togglegroup," # Toggle group
        "$mod CONTROL, g, changegroupactive, f" # Toggle group
        "$mod SHIFT, g, changegroupactive, b" # Toggle group
        # Workspaces (Left)
        "$mod, b, workspace, name:web" # Browsing workspace
        "$mod, b, exec, hyprctl clients | grep -i 'class: brave-browser' || brave" # Auto open browser if not running
        # /!\ Cannot move to Browsing worspace
        "$mod, a, workspace, name:aud" # Audio workspace
        "$mod SHIFT, a, movetoworkspace, name:aud" # Audio workspace
        "$mod, o, workspace, name:opn" # Open (a file)
        "$mod, o, exec, hyprctl clients -j | jq '.[]|.workspace.name == \"opn\"' | grep true || wezterm start broot" # Start a term with explorer
        "$mod, i, workspace, name:top" # Informations / monItorIng
        "$mod, i, exec, hyprctl clients | grep -i 'class: monitoring' || wezterm start --class monitoring btm" # Auto open bottom if not running
        # /!\ Cannot move to Monitoring worspace
        # Additional workspaces (Left)
        "$mod, u, workspace, name:sup" # Sup / Supplementary workspace
        "$mod SHIFT, u, movetoworkspace, name:sup" # Sup / Supplementary
        "$mod, e, workspace, name:etc" # Etc (et cetera) workspace
        "$mod, e, exec, hyprctl clients -j | jq '.[]|.workspace.name == \"etc\"' | grep true || rofi -show-icons -show combi -combi-modes window,drun" # Auto open laucher
        "$mod SHIFT, e, movetoworkspace, name:etc" # Etc (et cetera)
        "$mod, x, workspace, name:ext" # Ext / Extra workspace
        "$mod, x, exec, hyprctl clients -j | jq '.[]|.workspace.name == \"ext\"' | grep true || rofi -show-icons -show combi -combi-modes window,drun" # Auto open laucher
        "$mod SHIFT, x, movetoworkspace, name:ext" # Ext / Extra
        # Workspaces (Right)
        "$mod, l, workspace, name:cli" # cLi / terminaL workspace
        "$mod, l, exec, hyprctl clients -j | jq '.[]|([.class,.workspace.name] == [\"org.wezfurlong.wezterm\",\"cli\"])' | grep true || wezterm start" # Auto open CLI if not running
        "$mod SHIFT, l, movetoworkspace, name:cli" # cLi / terminaL
        "$mod, n, workspace, name:not" # Notetaking workspace
        "$mod, n, exec, hyprctl clients | grep -i 'class: note' || wezterm start --cwd ~/note --class note $EDITOR" # Auto open text editor
        "$mod SHIFT, n, movetoworkspace, name:not" # Notetaking
        "$mod, m, workspace, name:msg" # Messaging workspace
        # "$mod, m, exec, hyprctl clients | grep -i 'title: element' || element-desktop" # Auto open messaging
        "$mod, m, exec, hyprctl clients | grep -i 'title: discord' || discord" # Auto open main messaging
        "$mod SHIFT, m, movetoworkspace, name:msg" # Messaging
        # Additional monitor workspaces (Right)
        "$mod, d, workspace, name:dpp" # DisplayPort workspace
        "$mod SHIFT, d, movetoworkspace, name:dpp" # DisplayPort
        "$mod, h, workspace, name:hdm" # HDMI workspace
        "$mod SHIFT, h, movetoworkspace, name:hdm" # HDMI
        # Workspaces (Special)
        ", XF86AudioMedia, workspace, name:med" # Media ws
        ", XF86AudioMedia, exec, hyprctl clients | grep -i 'title: spotify' || spotify" # Auto open main media player
        "SHIFT, XF86AudioMedia, exec, menu ~ pulsemixer" # Open audio mixer
        "CONTROL, XF86AudioMedia, workspace, name:med" # Media ws
        "CONTROL, XF86AudioMedia, exec, hyprctl clients | grep -i 'class: org.pipewire.Helvum' || helvum" # Auto open audio router
        "CONTROL SHIFT, XF86AudioMedia, workspace, name:med" # Media ws
        "CONTROL SHIFT, XF86AudioMedia, exec, hyprctl clients | grep -i 'title: Easy Effects' || easyeffects" # Auto open audio tweaker
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
        # Leave $mod + SPACE for Cerebro TODO
        "$mod, SPACE, exec, rofi -show-icons -show combi -combi-modes window,drun,run,ssh,emoji"
        "$mod SHIFT, SPACE, exec, rofi -show calc"
        "$mod CONTROL, SPACE, exec, rofi -show-icons -show combi -combi-modes top"
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
        gaps_in = 1;
        gaps_out = 2;
        border_size = 2;
        layout = "dwindle";
        cursor_inactive_timeout = 1;
        "col.active_border" = "rgba(ffddccc5)";
        "col.inactive_border" = "rgba(00000000)";
        "col.group_border_active" = "rgba(ffddccc5)";
        "col.group_border" = "rgba(00000000)";
      };

      # See https://wiki.hyprland.org/Configuring/Variables
      gestures = {
        workspace_swipe = true;
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          # enabled = false; # Save some power
          size = 3;
          passes = 1;
        };
        # blur_new_optimizations = true; # Save some power
        drop_shadow = false; # Save some power
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1f1d1ccc)";
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
        vfr = true; # Save power
        render_titles_in_groupbar = false; # No titles in group bars
      };
    };
    systemdIntegration = true; # TEST relevance
    xwayland.enable = true;
  };

  services.swayidle = {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.playerctl}/bin/playerctl pause"; }
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -i $HOME/.wallpapers/desertWithPlants.jpg"; }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
      {
        timeout = 330;
        command = "swaylock -f -i $HOME/.wallpapers/desertWithPlants.jpg";
      }
      { timeout = 600; command = "systemctl suspend"; }
    ];
    systemdTarget = "hyprland-session.target";
  };

  xdg.configFile = {
    hyprpaper = {
      target = "hypr/hyprpaper.conf";
      source = script+data/hyprpaper.conf;
    };
  };
}
