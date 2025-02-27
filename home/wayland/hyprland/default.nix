{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    jq # Interpret `hyprctl -j` JSON in keybindings
    hyprutils # Hypr ecosystem utilities
    hyprpolkitagent # Hypr Polkit auth agent
    hyprcursor # Modern cursor engine
    # hyprland-protocols # Wayland extensions
    # xcur2png # Convert X cursor to PNG, needed for hyprcursor
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = lib.mkDefault ", preferred, auto, 1"; # Auto

      # See https://wiki.hyprland.org/Configuring/Keywords
      exec-once = [
        "waybar" # Status bar
        # "wezterm-mux-server" # Terminal multiplexer TEST relevance
        "albert" # General quick launcher
        "systemctl --user start hyprpolkitagent" # Polkit authentication agent
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
        "center, class:menu" # Center of screen
        "size 888 420, class:menu" # Small rectangle
        # Thunderbird Reminders
        "noinitialfocus, initialClass:thunderbird, initialTitle:.* Reminders?" # Don’t auto focus reminders
        "float, initialClass:thunderbird, initialTitle:.* Reminders?" # Don’t tile reminders
        "move 100%-557 100%-360, initialClass:thunderbird, initialTitle:.* Reminders?" # Right bottom
        "size 555 333, initialClass:thunderbird, initialTitle:.* Reminders?" # Small rectangle
        "opacity 0.7, initialClass:thunderbird, initialTitle:.* Reminders?" # Transparent
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords
      "$mod" = "SUPER";
      bindd = let
        # TODO this cleaner, factorize (duplicate of ../../shell/default.nix)
        term = {
          name = "wezterm"; # Name of the terminal (for matching)
          cmd = "wezterm start"; # Launch terminal
          # cmd = "wezterm start --always-new-process"; # FIX when too much terms crash
          exec = ""; # Option to execute a command in place of shell
          cd = "--cwd"; # Option to launch terminal in a directory
          # Classed terminals (executes a command)
          monitoring = "wezterm start --class monitoring"; # Monitoring
          note = "wezterm start --class note"; # Note
          menu =
            "wezterm --config window_background_opacity=0.7 start --class menu"; # Menu
        };
        # TODO cleaner
        term-alt = {
          name = "alacritty"; # Name of the terminal (for matching)
          cmd = "alacritty"; # Launch terminal
          exec = "--command"; # Option to execute a command in place of shell
          cd = "--working-directory"; # Option to launch terminal in a directory
          # Classed terminals (executes a command)
          monitoring =
            "alacritty --class monitoring --command"; # Monitoring terminal
          note = "alacritty --class note --command"; # Monitoring terminal
          menu =
            "alacritty --option window.opacity=0.7 --class menu --command"; # Menu terminal
        };
        launch = {
          # all = "pgrep albert || albert; albert toggle"; # Lazy start
          all = "albert toggle";
          alt = "rofi -show combi -combi-modes";
          app = ''albert show "app "'';
          # app = "rofi -show drun";
          category = "rofi -show drun -drun-categories";
          pass = ''albert show "pass "'';
          # pass = "rofi-pass";
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
        screenshot = let
          timestamp = "$(date +'%Y-%m-%d_%Hh%Mm%S')";
          workspace = ''$(hyprctl activeworkspace -j | jq -r '.["name"]')'';
          window = ''
            $(hyprctl activewindow -j | jq -r '.["title"]' | tr '/|\\ ' '\n' | tail -n1)'';
          ftype = "png";
          location = "$HOME/screenshot";
        in {
          fullscreen = "grim";
          region = ''grim -g "$(slurp)"'';
          dest-ws = "${location}/${timestamp}_${workspace}.${ftype}";
          dest-zone = "${location}/${timestamp}_${window}.${ftype}";
        };
        media = {
          cmd = "spotify";
          name = "Spotify";
        };
        open = "br"; # Global oppener
        mixer = "pulsemixer"; # Audio mixer
        pim = "thunderbird"; # PIM app
        monitor = "${term.monitoring} btm --battery --enable_gpu"; # Monitoring
      in [
        # System control
        "$mod CONTROL SHIFT, q, Exit Hyprland (user session), exit,"
        "$mod, comma, Lock session and obfuscates display, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "$mod CONTROL, comma, Lock session with loginctl, exec, loginctl lock-session"
        "$mod SHIFT, comma, Suspend computer to sleep, exec, systemctl suspend"
        "SUPER, j, Mirror output or region, exec, ${mirror.default}" # (F9 on Framework Laptop)
        "SUPER SHIFT, j, Freeze mirrored image, exec, ${mirror.freeze}"
        "SUPER SHIFT, j, Change mirrored output or region, exec, ${mirror.region}"
        # Launch
        "$mod, Super_L, Default launcher, exec, ${launch.all}"
        "$mod, SPACE, alternative/fallback launcher, exec, ${launch.alt}"
        "$mod CONTROL, SPACE, Quick calculator, exec, ${launch.calc}"
        "$mod SHIFT, SPACE, Quick password manager, exec, ${launch.pass}"
        # Launch with special media keys
        ", Menu, Open menu with media key, exec, ${launch.all}"
        ", XF86MenuKB, Open menu with media key, exec, ${launch.all}"
        ", XF86HomePage, Open home/menu with media key, exec, ${launch.all}"
        ", XF86Calculator, Quick calculator with media key, exec, ${launch.calc}"
        ", XF86Search, Quick search with media key, exec, ${launch.all}"
        # Terminal
        "$mod, RETURN, Open a default terminal, exec, ${term.cmd}"
        "$mod SHIFT, RETURN, Open a floating default terminal, exec, ${term.menu} $SHELL"
        "$mod CONTROL, RETURN, Open an alternative/fallback terminal, exec, ${term-alt.cmd}"
        "$mod CONTROL SHIFT, Open floating alt terminal, RETURN, exec, ${term-alt.menu} $SHELL"
        # Manage windows
        "$mod, f, Toggle window floating, togglefloating,"
        "$mod, w, Toggle window fullscreen, fullscreen,"
        "$mod, q, Close current window, killactive,"
        "$mod CONTROL, q, Close another window by clicking it, exec, hyprctl kill,"
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
        # Grouping
        "$mod, g, Toggle group or focus next window in group if there’s one, exec, hyprctl -j activewindow | jq -e '.grouped[0,1]' && hyprctl dispatch changegroupactive f || hyprctl dispatch togglegroup"
        "$mod CONTROL, g, Toggle grouping, togglegroup,"
        "$mod SHIFT, g, Focus next window in group, changegroupactive, f"
        "$mod CONTROL SHIFT, g, Focus previous window in group, changegroupactive, b"
        # Web
        "$mod CONTROL, b, Open alternative/fallback browser 1, exec, ${browser.alt1}"
        "$mod CONTROL SHIFT, b, Open alternative/fallback browser 2, exec, ${browser.alt2}"
        # Misc
        ", Print, Take a zoned screenshot, exec, ${screenshot.region} ${screenshot.dest-zone}"
        "CONTROL, Print, Copy screen zone to clipboard, exec, ${screenshot.region} - | wl-copy"
        "SHIFT, Print, Full screenshot, exec, ${screenshot.fullscreen} ${screenshot.dest-ws}"
        "$mod, k, Pick a color anywhere on the screen, exec, hyprpicker --autocopy"
        # Workspaces (Left hand) may auto launch associated app
        "$mod, b, Web browsing workspace, workspace, name:web"
        "$mod, b, Open browser in web workspace, exec, hyprctl clients | grep -i 'class: .*browser.*' || ${browser.default}"
        "$mod SHIFT, b, Move window to web workspace, movetoworkspace, name:web"
        "$mod ALT, b, Move web workspace to monitor, focusworkspaceoncurrentmonitor, name:web"
        "$mod, a, Audio workspace, workspace, name:art"
        ''
          $mod, a, Launch Audio/Video app, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "art")' || ${launch.category} AudioVideo''
        "$mod SHIFT, a, Move window to audio workspace, movetoworkspace, name:art"
        "$mod, p, Go to Personal Information Management workspace, workspace, name:pim"
        ''
          $mod, p, Open Personal Information Management software, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "pim")' || ${pim}''
        ", XF86Mail, Go to Personal Information Management workspace, workspace, name:pim"
        ''
          , XF86Mail, Open Personal Information Management software, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "pim")' || ${pim}''
        "$mod SHIFT, p, Move window to PIM workspace, movetoworkspace, name:pim"
        "$mod, o, Open any file on dedicated workspace, workspace, name:opn"
        "$mod, o, Open any file on dedicated workspace, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == \"opn\")' || ${term.cmd} ${term.exec} zsh -ic '${open};zsh'"
        "$mod, i, Informations / monItorIng workspace, workspace, name:inf"
        "$mod, i, Open monitoring software, exec, hyprctl clients | grep -i 'class: monitoring' || ${monitor}"
        # Additional workspaces (Left hand) may auto launch associated app
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
        # Workspaces (Right hand) may auto launch associated app
        "$mod, l, cLi / terminaL workspace, workspace, name:cli"
        ''
          $mod, l, Open a terminal on cli workspace, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "cli" and (.class | test("${term.name}";"i")))' || ${term.cmd}''
        "$mod SHIFT, l, Move window to cli workspace, movetoworkspace, name:cli"
        "$mod, n, Go to notetaking workspace, workspace, name:not"
        "$mod, n, Open any document in main user folders, exec, hyprctl clients | grep -i 'class: note' || ${term.note} zsh -ic '${open};zsh'"
        "$mod SHIFT, n, Move window to notetaking workspace, movetoworkspace, name:not"
        "$mod, m, Go to messaging workspace, workspace, name:msg"
        ''
          $mod, m, Launch a messaging app, exec, hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "msg")' || ${launch.app}''
        # Additional monitor workspaces (Right hand) may auto launch associated app
        "$mod, d, Go to DisplayPort workspace, workspace, name:dpp" # FIXME right port
        "$mod SHIFT, d, Move window to DisplayPort workspace, movetoworkspace, name:dpp"
        "$mod, h, Go to HDMI workspace, workspace, name:hdm" # FIXME right port
        "$mod SHIFT, h, Move window to HDMI workspace, movetoworkspace, name:hdm"
        # Media workspace (Media keys) may auto launch associated app
        ", XF86AudioMedia, Go to media workspace, workspace, name:media"
        ", XF86Tools, Go to media workspace, workspace, name:media"
        ''
          , XF86AudioMedia, Launch default media player, exec, hyprctl clients -j | jq -e 'any(.[]; .title == "${media.name}")' || ${media.cmd}''
        ''
          , XF86Tools, Launch default media player, exec, hyprctl clients -j | jq -e 'any(.[]; .title == "${media.name}")' || ${media.cmd}''
        "SHIFT, XF86AudioMedia, Open quick mixer, exec, ${term.menu} ${mixer}"
        "SHIFT, XF86Tools, Open quick mixer, exec, ${term.menu} ${mixer}"
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
        ", XF86RFKill, exec, rfkill toggle all; sleep 1"
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
        "${pkgs.playerctl}/bin/playerctl pause; ${pkgs.hyprlock}/bin/hyprlock";
      # "${pkgs.playerctl}/bin/playerctl pause; ${pkgs.systemd}/bin/loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };
  };
}
