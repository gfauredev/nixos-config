{ lib, pkgs, term, term-alt, ... }: {
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
      bindd = let
        launch = {
          all = "pgrep albert || albert; albert toggle";
          alt = "rofi -show combi -combi-modes";
          app = "rofi -show drun";
          category = "rofi -show drun -drun-categories";
          pass = "rofi-pass";
          calc = "${term.menu} kalker";
        };
        browser = {
          default = "brave";
          alt1 = "firefox";
          alt2 = "nyxt";
        };
        mirror = {
          default = "wl-present mirror"; # Mirror an output or region
          region = "wl-present set-region"; # Change mirrored output or region
          freeze = "wl-present toggle-freeze"; # Freeze mirrored image
        };
        screenshot = {
          fullscreen = "grim";
          region = ''grim -g "$(slurp)"'';
          dest-ws = let
            timestamp = "$(date +'%Y-%m-%d_%H:%M:%S')";
            target = ''$(hyprctl activeworkspace -j | jq -r '.["name"]')'';
            filetype = "png";
          in "$HOME/data/screenshot/${timestamp}_${target}.${filetype}";
          dest-zone = let
            timestamp = "$(date +'%Y-%m-%d_%H:%M:%S')";
            target = ''$(hyprctl activeworkspace -j | jq -r '.["title"]')'';
            filetype = "png";
          in "$HOME/data/screenshot/${timestamp}_${target}.${filetype}";
        };
        media = {
          cmd = "spotify";
          name = "Spotify";
        };
        mixer = "pulsemixer";
        pim = "thunderbird";
        monitor = "${term.monitoring} btm";
      in [
        # Move focus
        "$mod, c, Focus the window on the left, movefocus, l"
        "$mod, t, Focus the window below, movefocus, d"
        "$mod, s, Focus the window above, movefocus, u"
        "$mod, r, Focus the window on the right, movefocus, r"
        # Move window
        "$mod SHIFT, c, Move focused window to the left, movewindoworgroup, l"
        "$mod SHIFT, t, Move focused window below, movewindoworgroup, d"
        "$mod SHIFT, s, Move focused window above, movewindoworgroup, u"
        "$mod SHIFT, r, Move focused window to the right, movewindoworgroup, r"
        "$mod CONTROL SHIFT, c, Move focused window to the left, swapwindow, l"
        "$mod CONTROL SHIFT, t, Move focused window below, swapwindow, d"
        "$mod CONTROL SHIFT, s, Move focused window to the right, swapwindow, u"
        "$mod CONTROL SHIFT, r, Move focused window to the right, swapwindow, r"
        "$mod, g, Toggle group or focus next window in group, exec, hyprctl -j activewindow | jq -e '.grouped[0,1]' && hyprctl dispatch changegroupactive f || hyprctl dispatch togglegroup"
        "$mod CONTROL, g, Toggle group, togglegroup,"
        "$mod SHIFT, g, Focus next window in group, changegroupactive, f"
        "$mod CONTROL SHIFT, g, Focus previous window in group, changegroupactive, b"
        # Workspaces (Left hand)
        "$mod, b, Web browsing workspace, workspace, name:web"
        "$mod, b, Open browser in web workspace, exec, hyprctl clients | grep -i 'class: .*browser.*' || ${browser.default}"
        "$mod SHIFT, b, Move window to web workspace, movetoworkspace, name:web"
        "$mod ALT, b, Move web workspace to monitor, focusworkspaceoncurrentmonitor, name:web"
        "$mod, a, Audio workspace, workspace, name:art"
        ''
          $mod, a, exec, Launch Audio/Video app, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "art")' || ${launch.category} AudioVideo''
        "$mod SHIFT, a, Move window to audio workspace, movetoworkspace, name:art"
        "$mod, p, Go to Personal Information Management workspace, workspace, name:pim"
        ''
          $mod, p, Open Personal Information Management software, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "pim")' || ${pim}''
        ", XF86Mail, Go to Personal Information Management workspace, workspace, name:pim"
        ''
          , XF86Mail, exec, Open Personal Information Management software, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "pim")' || ${pim}''
        "$mod SHIFT, p, Move window to PIM workspace, movetoworkspace, name:pim"
        "$mod, o, Open any file on dedicated workspace, workspace, name:opn"
        "$mod, o, Open any file on dedicated workspace, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == \"opn\")' || ${term.cmd} ${term.exec} zsh -ic 'br;zsh'"
        "$mod, i, Informations / monItorIng workspace, workspace, name:top"
        "$mod, i, Open monitoring software, exec, hyprctl clients | grep -i 'class: monitoring' || ${monitor}"
        # Additional workspaces (Left hand)
        "$mod, u, SUp / SUpplementary workspace, workspace, name:sup"
        "$mod SHIFT, u, SUp / SUpplementary workspace, movetoworkspace, name:sup"
        "$mod, e, Etc (et cetera) workspace, workspace, name:etc"
        ''
          $mod, e, Launch an app on etc workspace, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "etc")' || ${launch.app}''
        "$mod SHIFT, e, Move window to etc workspace, movetoworkspace, name:etc"
        "$mod, x, eXt / eXtra workspace, workspace, name:ext"
        ''
          $mod, x, Launch an app on ext workspace, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "ext")' || ${launch.app}''
        "$mod SHIFT, x, Move window to ext workspace, movetoworkspace, name:ext"
        # Workspaces (Right hand)
        "$mod, l, cLi / terminaL workspace, workspace, name:cli"
        ''
          $mod, l, Open a terminal on cli workspace, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "cli" and (.class | test("${term.name}";"i")))' || ${term.cmd}''
        "$mod SHIFT, l, Move window to cli workspace, movetoworkspace, name:cli"
        "$mod, n, Go to notetaking workspace, workspace, name:note"
        "$mod, n, exec, hyprctl clients | grep -i 'class: note' || ${term.note} zsh -ic 'br;zsh'" # Start a term with explorer
        "$mod SHIFT, n, Move window to notetaking workspace, movetoworkspace, name:note"
        "$mod, m, Go to messaging workspace, workspace, name:msg"
        ''
          $mod, m, Launch a messaging app, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "msg")' || ${launch.all}''
        # Additional monitor workspaces (Right hand)
        "$mod, d, Go to DisplayPort workspace, workspace, name:dpp" # FIXME right port
        "$mod SHIFT, d, Move window to DisplayPort workspace, movetoworkspace, name:dpp"
        "$mod, h, Go to HDMI workspace, workspace, name:hdm" # FIXME right port
        "$mod SHIFT, h, Move window to HDMI workspace, movetoworkspace, name:hdm"
        # Media workspace (Media keys)
        ", XF86AudioMedia, Go to media workspace, workspace, name:media"
        ", XF86Tools, Go to media workspace, workspace, name:media"
        ''
          , XF86AudioMedia, exec, Launch default media player, hyprctl clients -j | jq -e 'any(.[]; .title == "${media.name}")' || ${media.cmd}''
        ''
          , XF86Tools, exec, Launch default media player, hyprctl clients -j | jq -e 'any(.[]; .title == "${media.name}")' || ${media.cmd}''
        "SHIFT, XF86AudioMedia, Open quick mixer, exec, ${term.menu} ${mixer}"
        "SHIFT, XF86Tools, Open quick mixer, exec, ${term.menu} ${mixer}"
        # System control
        "$mod CONTROL SHIFT, q, Exit Hyprland (user session), exit,"
        "$mod, comma, Lock session and obfuscates display, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "$mod CONTROL, Lock session with default lock, comma, exec, loginctl lock-session"
        "$mod SHIFT, comma, Suspend computer to sleep, exec, systemctl suspend"
        "SUPER, j, Mirror output or region, exec, ${mirror.default}" # (F9 on Framework Laptop)
        "SUPER SHIFT, j, Freeze mirrored image, exec, ${mirror.freeze}"
        "SUPER SHIFT, j, Change mirrored output or region, exec, ${mirror.region}"
        # Launch
        "$mod, Super_L, Default launcher, exec, ${launch.all}"
        "$mod, SPACE, alternative/fallback launcher, exec, ${launch.alt}"
        "$mod CONTROL, Quick calculator, SPACE, exec, ${launch.calc}"
        "$mod SHIFT, SPACE, Quick password manager, exec, ${launch.pass}"
        # Launch with special media keys
        ", Menu, exec, Open menu with media key, ${launch.all}"
        ", XF86MenuKB, Open menu with media key, exec, ${launch.all}"
        ", XF86HomePage, Open home/menu with media key, exec, ${launch.all}"
        ", XF86Calculator, Quick calculator with media key, exec, ${launch.calc}"
        ", XF86Search, exec, Quick search with media key, ${launch.all}"
        # Manage windows
        "$mod, f, Toggle window floating, togglefloating,"
        "$mod, w, Toggle window fullscreen, fullscreen,"
        "$mod, q, Close current window, killactive,"
        "$mod CONTROL, q, Close another window by clicking it, exec, hyprctl kill,"
        # Web
        "$mod CONTROL, b, Open alternative/fallback browser 1, exec, ${browser.alt1}"
        "$mod CONTROL SHIFT, b, Open alternative/fallback browser 2, exec, ${browser.alt2}"
        # Terminal
        "$mod, RETURN, Open a default terminal, exec, ${term.cmd}"
        "$mod SHIFT, RETURN, Open a floating default terminal, exec, ${term.menu} $SHELL"
        "$mod CONTROL, RETURN, Open an alternative/fallback terminal, exec, ${term-alt.cmd}"
        "$mod CONTROL SHIFT, Open floating alt terminal, RETURN, exec, ${term-alt.menu} $SHELL"
        # Misc
        ", Print, exec, ${screenshot.region} ${screenshot.dest-zone}"
        "CONTROL, Print, exec, ${screenshot.region} - | wl-copy"
        "SHIFT, Print, exec, ${screenshot.fullscreen} ${screenshot.dest-ws}"
        "$mod, k, exec, hyprpicker --autocopy"
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
      bindl = [
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
        ", XF86RFKill, exec, rfkill toggle all"
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
      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];

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
      before_sleep_cmd =
        "${pkgs.playerctl}/bin/playerctl pause;${pkgs.systemd}/bin/loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };
  };

  # xdg.configFile = {
  #   hyprpaper = {
  #     target = "hypr/hyprpaper.conf";
  #     source = ./hyprpaper.conf;
  #   };
  # };
}
