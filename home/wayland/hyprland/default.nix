{ lib, pkgs, term, ... }: {
  home.packages = with pkgs; [
    wl-mirror # Mirror wayland output
    hyprcursor # Modern cursor engine
    # xcur2png # Convert X cursor to PNG, needed for hyprcursor
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Force wayland support for some apps
    GDK_SCALE = "1.25"; # Scaling on Xwayland
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # plugins = [ ];
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = lib.mkDefault ", preferred, auto, 1"; # Auto

      # See https://wiki.hyprland.org/Configuring/Keywords
      exec-once = [
        "waybar"
        # "Cerebro" # General purpose launcher
        # "wezterm-mux-server" # TEST relevance
      ];

      xwayland.force_zero_scaling = true;

      # See https://wiki.hyprland.org/Configuring/Variables
      input = {
        kb_layout = "fr,us";
        kb_variant = "bepo_afnor,";
        # kb_options = "grp:ctrls_toggle"; # Not working
        # kb_options = "grp:alt_shift_toggle"; # Annoying
        # kb_options = "grp:shifts_toggle"; # Not working
        # kb_options = "grp:alts_toggle"; # Breaks AltGr
        kb_options = "grp:alt_altgr_toggle";
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
        # no_gaps_when_only = 1; # Disable gaps & borders for lone window
      };
      # See https://wiki.hyprland.org/Configuring/Master-Layout
      # master = {
      #   new_is_master = false; # TEST
      # };

      # See https://wiki.hyprland.org/Configuring/Window-Rules
      windowrulev2 = [
        # Menu windows (like mixer)
        "float, class:menu" # Float (not tiled)
        "size 888 420, class:menu" # Small rectangle
        "center, class:menu" # Center
        # Thunderbird
        "float, title:Reminders" # Reminder right bottom
        "size 555 333, title:Reminders" # Small rectangle
        "move 100%-557 100%-360, title:Reminders" # Right bottom
        "opacity 0.7, title:Reminders" # Transparent
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords
      "$mod" = "SUPER";
      bind = let
        launch = "rofi -show drun";
        launch-alt = "fuzzel";
        launch-full = "rofi -show combi -combi-modes";
        launch-calc = "rofi -show calc";
        browser-1 = "brave";
        browser-2 = "nyxt";
        browser-3 = "firefox";
        pim = "thunderbird";
        monitor = "btm";
        mirror = "wl-present mirror";
        mirror-output = "wl-present set-output";
        mirror-region = "wl-present set-region";
      in [
        # Move focus
        "$mod, c, movefocus, l" # Move left
        "$mod, t, movefocus, d" # Move down
        "$mod, s, movefocus, u" # Move up
        "$mod, r, movefocus, r" # Move right
        # Move window
        "$mod SHIFT, c, movewindoworgroup, l" # Move left
        "$mod SHIFT, t, movewindoworgroup, d" # Move down
        "$mod SHIFT, s, movewindoworgroup, u" # Move up
        "$mod SHIFT, r, movewindoworgroup, r" # Move right
        "$mod CONTROL SHIFT, c, swapwindow, l" # Move left
        "$mod CONTROL SHIFT, t, swapwindow, d" # Move down
        "$mod CONTROL SHIFT, s, swapwindow, u" # Move up
        "$mod CONTROL SHIFT, r, swapwindow, r" # Move right
        "$mod, g, exec, hyprctl -j activewindow | jq -e '.grouped[0,1]' && hyprctl dispatch changegroupactive f || hyprctl dispatch togglegroup" # Smart group control
        "$mod CONTROL, g, togglegroup," # Toggle group
        "$mod SHIFT, g, changegroupactive, f" # Toggle focus in group
        "$mod CONTROL SHIFT, g, changegroupactive, b" # Toggle focus in group
        # Workspaces (Left)
        "$mod, b, workspace, name:web" # Browsing workspace
        "$mod, b, exec, hyprctl clients | grep -i 'class: .*browser.*' || ${browser-1}" # Auto open browser if not running
        "$mod SHIFT, b, movetoworkspace, name:web" # Web browser
        "$mod, a, workspace, name:aud" # Audio workspace
        ''
          $mod, a, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "aud")' || ${launch}'' # Auto open laucher
        "$mod SHIFT, a, movetoworkspace, name:aud" # Audio workspace
        "$mod, p, workspace, name:pim" # Personal information management workspace
        ''
          $mod, p, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "pim")' || ${pim}'' # Auto open personal information management apps
        "$mod SHIFT, p, movetoworkspace, name:pim" # Personal information management workspace
        "$mod, o, workspace, name:opn" # Open (a file)
        "$mod, o, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == \"opn\")' || ${term.cmd} ${term.exec} zsh -ic 'br;zsh'" # Start a term with explorer
        "$mod, i, workspace, name:top" # Informations / monItorIng
        "$mod, i, exec, hyprctl clients | grep -i 'class: monitoring' || ${term.monitoring} ${monitor}" # Auto open bottom if not running
        # /!\ Cannot move to Monitoring worspace
        # Additional workspaces (Left)
        "$mod, u, workspace, name:sup" # Sup / Supplementary workspace
        "$mod SHIFT, u, movetoworkspace, name:sup" # Sup / Supplementary
        "$mod, e, workspace, name:etc" # Etc (et cetera) workspace
        ''
          $mod, e, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "etc")' || ${launch}'' # Auto open laucher
        "$mod SHIFT, e, movetoworkspace, name:etc" # Etc (et cetera)
        "$mod, x, workspace, name:ext" # Ext / Extra workspace
        ''
          $mod, x, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "ext")' || ${launch}'' # Auto open laucher
        "$mod SHIFT, x, movetoworkspace, name:ext" # Ext / Extra
        # Workspaces (Right)
        "$mod, l, workspace, name:cli" # cLi / terminaL workspace
        ''
          $mod, l, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "cli" and (.class | test("${term.name}";"i")))' || ${term.cmd}'' # Auto open CLI if not running
        "$mod SHIFT, l, movetoworkspace, name:cli" # cLi / terminaL
        "$mod, n, workspace, name:not" # Notetaking workspace
        "$mod, n, exec, hyprctl clients | grep -i 'class: note' || ${term.note} zsh -ic 'br;zsh'" # Start a term with explorer
        # "$mod, n, exec, hyprctl clients | grep -i 'class: note' || ${term.note} $EDITOR" # Auto open text editor
        "$mod SHIFT, n, movetoworkspace, name:not" # Notetaking
        "$mod, m, workspace, name:msg" # Messaging workspace
        ''
          $mod, m, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "msg")' || ${launch}'' # Auto open laucher
        "$mod SHIFT, m, movetoworkspace, name:msg" # Messaging
        "$mod CONTROL, m, exec, zsh -ic 'mirror'" # Messaging
        # Additional monitor workspaces (Right)
        "$mod, d, workspace, name:dpp" # DisplayPort workspace
        "$mod SHIFT, d, movetoworkspace, name:dpp" # DisplayPort
        "$mod, h, workspace, name:hdm" # HDMI workspace
        "$mod SHIFT, h, movetoworkspace, name:hdm" # HDMI
        # Workspaces (Special)
        ", XF86AudioMedia, workspace, name:med" # Media ws
        ''
          , XF86AudioMedia, exec, hyprctl clients -j | jq -e 'any(.[]; .title == "Spotify")' || spotify'' # Auto open main media player
        "SHIFT, XF86AudioMedia, exec, ${term.menu} pulsemixer" # Open audio mixer
        "CONTROL, XF86AudioMedia, workspace, name:med" # Media ws
        "CONTROL, XF86AudioMedia, exec, hyprctl clients | grep -i 'class: org.pipewire.Helvum' || helvum" # Auto open audio router
        "CONTROL SHIFT, XF86AudioMedia, workspace, name:med" # Media ws
        # "CONTROL SHIFT, XF86AudioMedia, exec, hyprctl clients | grep -i 'title: Easy Effects' || easyeffects" # Auto open audio tweaker
        ", XF86Tools, workspace, name:med" # Media ws
        ''
          , XF86Tools, exec, hyprctl clients -j | jq -e 'any(.[]; .title == "Spotify")' || spotify'' # Auto open main media player
        "SHIFT, XF86Tools, exec, ${term.menu} pulsemixer" # Open audio mixer
        "CONTROL, XF86Tools, workspace, name:med" # Media ws
        "CONTROL, XF86Tools, exec, hyprctl clients | grep -i 'class: org.pipewire.Helvum' || helvum" # Auto open audio router
        "CONTROL SHIFT, XF86Tools, workspace, name:med" # Media ws
        # "CONTROL SHIFT, XF86Tools, exec, hyprctl clients | grep -i 'title: Easy Effects' || easyeffects" # Auto open audio tweaker
        # /!\ Cannot move to Media worspace
        # Terminal # TODO test multiplexing, features of wezterm
        "$mod, RETURN, exec, ${term.cmd}"
        # Launch
        "$mod, SPACE, exec, ${launch-full}" # Launcher with additional modes
        "$mod CONTROL, SPACE, exec, ${launch-calc}" # Calculator
        "$mod SHIFT, SPACE, exec, ${launch-alt}" # Alternative launcher
        # Launch with special media keys
        ", Menu, exec, ${launch-full}" # Menu special key
        ", XF86MenuKB, exec, ${launch-full}" # Menu special key
        ", XF86Mail, exec, ${launch-full}" # Mail media key
        ", XF86HomePage, exec, ${launch-full}" # Home media key
        ", XF86Calculator, exec, ${launch-calc}" # Calculator media key
        ", XF86Search, exec, ${launch-full}" # Search media key
        # Manage windows
        "$mod, f, togglefloating," # Float window
        "$mod, w, fullscreen," # Fullscreen window
        "$mod, q, killactive," # Close window
        # System control
        "$mod CONTROL SHIFT, q, exit," # Close wayland session
        "$mod, comma, exec, loginctl lock-session" # Lock session (should dim and blur screen)
        "$mod SHIFT, comma, exec, systemctl suspend" # Suspend
        "SUPER, j, exec, ${mirror}" # Mirror output (F9 on Framework Laptop)
        "SUPER CONTROL, j, exec, ${mirror-output}" # Change mirrored output
        "SUPER SHIFT, j, exec, ${mirror-region}" # Change mirrored region
        # Web
        "$mod CONTROL, b, exec, ${browser-2}" # Alternative browser
        "$mod CONTROL SHIFT, b, exec, ${browser-3}" # Alternative browser
        # Audio
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "SHIFT, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "CONTROL, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
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
        ''
          , Print, exec, grim -g "$(slurp)" $HOME/data/unsorted/screenshot/$(date +'%Y-%m-%d_%Hh%Mm%Ss.png')''
        ''CONTROL, Print, exec, grim -g "$(slurp)" - | wl-copy''
        "SHIFT, Print, exec, grim $HOME/data/unsorted/screenshot/$(date +'%Y-%m-%d_%Hh%Mm%Ss.png')"
        "$mod, k, exec, hyprpicker --autocopy"
        ", XF86RFKill, exec, rfkill toggle all"
      ];
      binde = [
        # Move windows
        "$mod SHIFT, c, moveactive, -10 0" # Move floating left
        "$mod SHIFT, t, moveactive, 0 10" # Move floating down
        "$mod SHIFT, s, moveactive, 0 -10" # Move floating up
        "$mod SHIFT, r, moveactive, 10 0" # Move floating right
        # Resize windows
        "$mod CONTROL, c, resizeactive, -10 0" # Move left
        "$mod CONTROL, t, resizeactive, 0 10" # Move down
        "$mod CONTROL, s, resizeactive, 0 -10" # Move up
        "$mod CONTROL, r, resizeactive, 10 0" # Move right
      ];
      bindle = [
        # Brightness (light)
        # ",XF86MonBrightnessUp, exec, light -A 5"
        # ",XF86MonBrightnessDown, exec, light -U 5"
        # "SHIFT, XF86MonBrightnessUp, exec, light -A 2"
        # "SHIFT, XF86MonBrightnessDown, exec, light -U 2"
        # "CONTROL, XF86MonBrightnessUp, exec, light -A 1"
        # "CONTROL, XF86MonBrightnessDown, exec, light -U 1"
        # Brightness (brightnessctl)
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "SHIFT, XF86MonBrightnessUp, exec, brightnessctl set 2%+"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl set 2%-"
        "CONTROL, XF86MonBrightnessUp, exec, brightnessctl set 1%+"
        "CONTROL, XF86MonBrightnessDown, exec, brightnessctl set 1%-"
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
      bindm = [ "$mod, mouse:272, movewindow" ];

      # See https://wiki.hyprland.org/Configuring/Variables
      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 2;
        layout = "dwindle";
        "col.active_border" = "rgb(b6a482)";
        "col.inactive_border" = "rgb(000000)";
        # cursor_inactive_timeout = 1;
      };

      cursor = {
        no_hardware_cursors = false;
        inactive_timeout = 1;
        enable_hyprcursor = true;
        hide_on_key_press = true;
        hide_on_touch = true;
      };

      group = {
        "col.border_active" = "rgb(e6d4c2)";
        "col.border_inactive" = "rgb(000000)";
        groupbar = {
          enabled = false; # Don’t eat my screen space
        };
      };

      # See https://wiki.hyprland.org/Configuring/Variables
      gestures.workspace_swipe = false;

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
        # blur_new_optimizations = true; # Save some power
        drop_shadow = false; # Save some power
        # shadow_range = 4;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(1f1d1ccc)";
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
        background_color = "0x000000";
        disable_splash_rendering = true;
        vfr = true; # Save power
        # enable_hyprcursor = true;
        # hide_cursor_on_key_press = true;
      };
    };
    systemd.enable = true; # TEST relevance
    xwayland.enable = true;
  };

  services.hypridle = {
    enable = true;
    settings.general = {
      lock_cmd = "${pkgs.hyprlock}/bin/hyprlock";
      unlock_cmd = "pkill -USR1 hyprlock";
      before_sleep_cmd = "${pkgs.playerctl}/bin/playerctl pause";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };
  };

  # services.swayidle = {
  #   enable = false;
  #   systemdTarget = "hyprland-session.target";
  # };

  # xdg.configFile = {
  #   hyprpaper = {
  #     target = "hypr/hyprpaper.conf";
  #     source = ./hyprpaper.conf;
  #   };
  # };
}
