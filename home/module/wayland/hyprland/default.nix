{
  lib,
  pkgs,
  config,
  ...
}:
let
  mod = "SUPER"; # Main modifier, SUPER
  active_win = ''$(hyprctl activewindow -j | jq -r '.["title"]' | tr '/|\\ ' '\n' | tail -n1)'';
  active_ws = ''$(hyprctl activeworkspace -j | jq -r '.["name"]')'';
  # TODO pass custom keybinding for apps that support tabs natively instead of grouping
  tabbedApp = [
    {
      name = "alacritty";
      bind = "ctrl+TODO";
    }
    {
      name = "brave";
      bind = "ctrl+t";
    }
    {
      name = "chromium";
      bind = "ctrl+t";
    }
    {
      name = "firefox";
      bind = "ctrl+t";
    }
    {
      name = "foot";
      bind = "ctrl+TODO";
    }
    {
      name = "ghostty";
      bind = "ctrl+t";
    }
    {
      name = "wezterm";
      bind = "ctrl+TODO";
    }
  ];
  cycleOrToggleGroup = "hyprctl -j activewindow | jq -e '.grouped[0,1]' && hyprctl dispatch changegroupactive f || hyprctl dispatch togglegroup";
  pick = "hyprpicker --autocopy"; # Color picker
  plane-mode = "rfkill toggle all; sleep 1"; # Disable every wireless
  timestamp = "$(date +'%Y-%m-%d-%Hh%Mm%S')"; # Current date as string
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
    play.toggle = "playerctl play-pause";
    play.pause = "playerctl pause";
    play.next = "playerctl next";
    play.previous = "playerctl previous";
    # media.toggle = "playerctl play-pause -p ${config.media}";
    # media.next = "playerctl next -p ${config.media}";
    # media.previous = "playerctl previous -p ${config.media}";
  }; # TODO generate Hyprland 'bindl' binds from audio definitions
  brightness = {
    raise = "brightnessctl set 1%+"; # "light -A 1";
    RAISE = "brightnessctl set 5%+"; # "light -A 5";
    lower = "brightnessctl set 1%-"; # "light -U 1";
    LOWER = "brightnessctl set 5%-"; # "light -U 5";
  }; # TODO generate Hyprland 'bindle' binds from brithness definitions
  mirror = {
    default = "wl-present mirror"; # Mirror an output or region
    region = "wl-present set-region"; # Change mirrored output or region
    freeze = "wl-present toggle-freeze"; # Freeze mirrored image
  };
  screenshot = {
    fullscreen = "grim";
    region = ''grim -g "$(slurp)"'';
    dest-ws = "${config.home.sessionVariables.XDG_PICTURES_DIR}/screenshot/${active_ws}${timestamp}.png";
    dest-zone = "${config.home.sessionVariables.XDG_PICTURES_DIR}/screenshot/${active_win}${timestamp}.png";
  };
in
{
  home.packages = with pkgs; [
    jq # Interpret `hyprctl -j` JSON in keybindings
    hyprutils # Hypr ecosystem utilities
    hyprpolkitagent # Hypr Polkit auth agent
    hyprcursor # Modern cursor engine
    hyprshell # Window switcher & application launcher TODO configure
  ];

  wayland.windowManager.hyprland = {
    enable = true; # See https://wiki.hyprland.org/Configuring
    systemd.enable = true;
    xwayland.enable = true; # Backwards compatibility
    settings =
      let
        _base07 = config.stylix.base16Scheme.base07;
        base07 = "rgb(${builtins.substring 1 (builtins.stringLength _base07) _base07})";
        black = "rgb(000000)"; # Pitch black background for OLED
      in
      {
        monitor = lib.mkDefault ", preferred, auto, 1"; # Auto
        debug.disable_logs = false; # Enable logs
        xwayland.force_zero_scaling = true;
        exec-once = [
          "waybar" # Status bar
          "albert" # General quick launcher
          "systemctl --user start hyprpolkitagent" # Polkit authentication agent
        ];
        input = {
          kb_layout = "fr,us";
          kb_variant = "bepo_afnor,";
          kb_options = "grp:alt_altgr_toggle"; # ctrls_toggle alt_shift_toggle shifts_toggle alts_toggle
          repeat_delay = "190";
          repeat_rate = "50";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false; # Going up goes up
          tablet.output = "current";
        };
        dwindle = {
          pseudotile = true; # master switch for pseudotiling TEST
          preserve_split = true; # you probably want this
        };
        windowrule = [
          "noborder, floating:0, onworkspace:w[t1]" # No border for single tiled
          "idleinhibit fullscreen, workspace:name:dpp" # Inhibit while presenting
          "idleinhibit fullscreen, workspace:name:hdm" # Inhibit while presenting
          "idleinhibit fullscreen, workspace:name:int" # Inhibit while presenting
          # "noinitialfocus, initialClass:thunderbird, initialTitle:.* Reminders?" # Don’t auto focus reminders
          # "float, initialClass:thunderbird, initialTitle:.* Reminders?" # Don’t tile reminders
          # "move 100%-557 100%-360, initialClass:thunderbird, initialTitle:.* Reminders?" # Right bottom
          # "size 555 333, initialClass:thunderbird, initialTitle:.* Reminders?" # Small rectangle
          # "opacity 0.7, initialClass:thunderbird, initialTitle:.* Reminders?" # Transparent
          # "float, class:com.github.com.woxlauncer.wox, title:Wox"
          # "size 1337 800, class:com.github.com.woxlauncer.wox, title:Wox"
        ];
        bind = import ./workspaces.nix;
        bindd = [
          "${mod} CONTROL SHIFT, q, Exit Hyprland (user session), exit,"
          "${mod}, comma, Lock session and obfuscates display, exec, ${config.wayland.lock}"
          "${mod} CONTROL, comma, Lock session with loginctl, exec, ${config.wayland.lock-session}"
          "${mod} SHIFT, comma, Suspend computer to sleep, exec, ${config.wayland.suspend}"
          "SUPER, j, Mirror output or region, exec, ${mirror.default}" # (F9 on Framework Laptop)
          "SUPER SHIFT, j, Freeze mirrored image, exec, ${mirror.freeze}"
          "SUPER CONTROL, j, Change mirrored output or region, exec, ${mirror.region}"
          "${mod}, Super_L, Default launcher, exec, ${config.launch.all}"
          "${mod} SHIFT, Super_L, alternative/fallback launcher, exec, ${config.launch.alt2}"
          "${mod}, SPACE, alternative/fallback launcher, exec, ${config.launch.alt}"
          "${mod} CONTROL, SPACE, Quick calculator, exec, ${config.launch.calc}"
          "${mod} SHIFT, SPACE, Quick password manager, exec, ${config.launch.pass}"
          ", Menu, Open launcher with media key, exec, ${config.launch.all}"
          ", XF86MenuKB, Open launcher with media key, exec, ${config.launch.all}"
          ", XF86HomePage, Open launcher with media key, exec, ${config.launch.all}"
          ", XF86Calculator, Quick calculator with media key, exec, ${config.launch.calc}"
          ", XF86Search, Quick search with media key, exec, ${config.launch.all}"
          "${mod}, RETURN, Open a default terminal, exec, ${config.term.cmd}"
          "${mod} SHIFT, RETURN, Open a floating default terminal, exec, [float; center; size 888 420] ${config.term.cmd} ${config.term.exec} ${config.home.sessionVariables.SHELL}" # FIX Bare ghostty command refuses to be launched tiled
          "${mod} CONTROL, RETURN, Open an alternative/fallback terminal, exec, ${config.term.alt.cmd}"
          "${mod} CONTROL SHIFT, Open floating alt terminal, RETURN, exec, [float; center; size 888 420] ${config.term.alt.cmd} ${config.term.exec} ${config.home.sessionVariables.SHELL}" # FIX Bare ghostty command refuses to be launched tiled
          "${mod}, f, Toggle window floating, togglefloating,"
          "${mod}, w, Toggle window fullscreen, fullscreen,"
          "${mod}, q, Close current window, killactive,"
          "${mod}, BackSpace, Close current window, killactive,"
          "${mod}, Delete, Close current window, killactive,"
          "${mod} CONTROL, q, Close another window by clicking it, exec, hyprctl kill," # FIXME
          "${mod}, c, Focus the window on the left, movefocus, l"
          "${mod}, t, Focus the window below, movefocus, d"
          "${mod}, s, Focus the window above, movefocus, u"
          "${mod}, r, Focus the window on the right, movefocus, r"
          "${mod} SHIFT, c, Move focused window to the left, movewindoworgroup, l"
          "${mod} SHIFT, t, Move focused window below, movewindoworgroup, d"
          "${mod} SHIFT, s, Move focused window above, movewindoworgroup, u"
          "${mod} SHIFT, r, Move focused window to the right, movewindoworgroup, r"
          "${mod} CONTROL SHIFT, c, Move focused window to the left, swapwindow, l"
          "${mod} CONTROL SHIFT, t, Move focused window below, swapwindow, d"
          "${mod} CONTROL SHIFT, s, Move focused window to the right, swapwindow, u"
          "${mod} CONTROL SHIFT, r, Move focused window to the right, swapwindow, r"
          "${mod}, g, Toggle group or focus next window in group if there’s one, exec, ${cycleOrToggleGroup}"
          "${mod} CONTROL, g, Toggle grouping, togglegroup,"
          "${mod} SHIFT, g, Focus next window in group, changegroupactive, f"
          "${mod} CONTROL SHIFT, g, Focus previous window in group, changegroupactive, b"
          ", Print, Take a zoned screenshot, exec, ${screenshot.region} ${screenshot.dest-zone}"
          "CONTROL, Print, Copy screen zone to clipboard, exec, ${screenshot.region} - | wl-copy"
          "SHIFT, Print, Full screenshot, exec, ${screenshot.fullscreen} ${screenshot.dest-ws}"
          "${mod}, k, Pick a color anywhere on the screen, exec, ${pick}"
          ", XF86AudioMedia, Open audio mixer, exec, [float; center; size 888 420] ${config.launch.mix}"
          ", XF86Tools, Open audio mixer, exec, [float; center; size 888 420] ${config.launch.mix}"
          "SHIFT, XF86AudioMedia, Open bluetooth manager, exec, [float; center; size 888 420] ${config.term.cmd} ${config.term.exec} bluetoothctl"
          "SHIFT, XF86Tools, Open bluetooth manager, exec, [float; center; size 888 420]  ${config.term.cmd} ${config.term.exec} bluetoothctl"
          "CONTROL, XF86AudioMedia, Open bluetooth manager, exec, [float; center; size 888 420] ${config.term.cmd} ${config.term.exec} bluetoothctl"
          "CONTROL, XF86Tools, Open bluetooth manager, exec, [float; center; size 888 420]  ${config.term.cmd} ${config.term.exec} bluetoothctl"
        ];
        binde = [
          "${mod} SHIFT, c, moveactive, -10 0" # Move left
          "${mod} SHIFT, t, moveactive, 0 10" # Move down
          "${mod} SHIFT, s, moveactive, 0 -10" # Move up
          "${mod} SHIFT, r, moveactive, 10 0" # Move right
          "${mod} CONTROL, c, resizeactive, -10 0" # Resize to the left
          "${mod} CONTROL, t, resizeactive, 0 10" # Resize to the bottom
          "${mod} CONTROL, s, resizeactive, 0 -10" # Resize to the top
          "${mod} CONTROL, r, resizeactive, 10 0" # Resize to the right
        ];
        bindl = [
          ", XF86AudioMute, exec, ${audio.speaker.toggle}"
          "SHIFT, XF86AudioMute, exec, ${audio.mic.toggle}"
          "CONTROL, XF86AudioMute, exec, ${audio.mic.toggle}"
          ", XF86AudioMicMute, exec, ${audio.mic.toggle}"
          "SHIFT, XF86AudioMicMute, exec, ${audio.speaker.toggle}"
          "CONTROL, XF86AudioMicMute, exec, ${audio.speaker.toggle}"
          ", XF86AudioPlay, exec, ${audio.play.toggle}"
          # "SHIFT, XF86AudioPlay, exec, ${audio.media.toggle}"
          ", XF86AudioPause, exec, ${audio.play.toggle}"
          # "SHIFT, XF86AudioPause, exec, ${audio.media.toggle}"
          ", XF86AudioNext, exec, ${audio.play.next}"
          # "SHIFT, XF86AudioNext, exec, ${audio.media.next}"
          ", XF86AudioPrev, exec, ${audio.play.previous}"
          # "SHIFT, XF86AudioPrev, exec, ${audio.media.previous}"
          ", XF86RFKill, exec, ${plane-mode}"
        ];
        bindle = [
          ",XF86MonBrightnessUp, exec, ${brightness.RAISE}"
          ",XF86MonBrightnessDown, exec, ${brightness.LOWER}"
          "SHIFT, XF86MonBrightnessUp, exec, ${brightness.raise}"
          "SHIFT, XF86MonBrightnessDown, exec, ${brightness.lower}"
          "CONTROL, XF86MonBrightnessUp, exec, ${brightness.raise}"
          "CONTROL, XF86MonBrightnessDown, exec, ${brightness.lower}"
          ", XF86AudioRaiseVolume, exec, ${audio.speaker.RAISE}"
          "CONTROL, XF86AudioRaiseVolume, exec, ${audio.speaker.raise}"
          "SHIFT, XF86AudioRaiseVolume, exec, ${audio.mic.RAISE}"
          "CONTROL SHIFT, XF86AudioRaiseVolume, exec, ${audio.mic.raise}"
          ", XF86AudioLowerVolume, exec, ${audio.speaker.LOWER}"
          "CONTROL, XF86AudioLowerVolume, exec, ${audio.speaker.lower}"
          "SHIFT, XF86AudioLowerVolume, exec, ${audio.mic.LOWER}"
          "CONTROL SHIFT, XF86AudioLowerVolume, exec, ${audio.mic.lower}"
        ];
        bindm = [
          "${mod}, mouse:272, movewindow"
          "${mod}, mouse:273, resizewindow"
        ];
        general = {
          gaps_in = 0; # Keep only borders, spare screen surface
          gaps_out = 0; # Keep only borders, spare screen surface
          border_size = 2; # Keep only borders, spare screen surface
          layout = "dwindle"; # Default new window placement algorithm
          "col.inactive_border" = lib.mkForce black; # Low-cost gaps
        };
        cursor = {
          no_hardware_cursors = false;
          inactive_timeout = 1;
          enable_hyprcursor = true;
          hide_on_key_press = true;
          hide_on_touch = true;
        };
        group.groupbar.enabled = false; # Don’t eat my screen space
        group = {
          "col.border_active" = lib.mkForce base07; # Stylix
          "col.border_inactive" = lib.mkForce black; # Low-cost gaps
        };
        decoration = {
          rounding = 6;
          blur.enabled = lib.mkDefault false; # Save power
          shadow.enabled = false; # Save power
        };
        animations = {
          enabled = lib.mkDefault false; # Save power
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
          vfr = true; # Save power, less tearing
          background_color = lib.mkForce "0x000000"; # Stylix
        };
        env = [
          "NIXOS_OZONE_WL,1" # Force Wayland support for some apps (Chromium)
          "GTK_IM_MODULE,simple" # Simple GTK input method (use builtin deadkeys)
        ]
        ++ lib.mapAttrsToList (var: val: "${var},${toString val}") config.home.sessionVariables;
      };
  };

  services.hypridle = {
    enable = true;
    settings.general = {
      lock_cmd = "${config.wayland.lock}";
      unlock_cmd = "pkill -USR1 hyprlock";
      before_sleep_cmd = "${audio.play.pause}; ${config.wayland.lock}";
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      ignore_systemd_inhibit = false;
    };
  };
}
