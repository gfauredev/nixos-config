{ lib, pkgs, config, ... }:
let
  # Aliases and utility functions
  active_win = ''
    $(hyprctl activewindow -j | jq -r '.["title"]' | tr '/|\\ ' '\n' | tail -n1)'';
  active_ws = ''$(hyprctl activeworkspace -j | jq -r '.["name"]')'';
  cycleOrToggleGroup =
    "hyprctl -j activewindow | jq -e '.grouped[0,1]' && hyprctl dispatch changegroupactive f || hyprctl dispatch togglegroup";
  ifWorkspaceEmpty = { ws }:
    ''hyprctl clients -j | jq -e 'any(.[]; .workspace.name == "${ws}")' ||'';
  # Tools definitions
  mixer = "${config.term.cmd} ${config.term.exec} pulsemixer"; # Audio mixer
  monitor = # Monitoring
    "${config.term.cmd} ${config.term.exec} btm --battery --enable_gpu";
  open = # Global opener command # FIXME cd for broot (br)
    "${config.term.cmd} ${config.term.exec} ${config.home.sessionVariables.SHELL} -c broot";
  picker = "hyprpicker --autocopy"; # Color picker
  plane-mode = "rfkill toggle all; sleep 1"; # Disable every wireless
  timestamp = "$(date +'%Y-%m-%d_%Hh%Mm%S')"; # Current date as string
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
    media.toggle = "playerctl play-pause -p ${config.media.favorite}";
    media.next = "playerctl next -p ${config.media.favorite}";
    media.previous = "playerctl previous -p ${config.media.favorite}";
  };
  brightness = {
    RAISE = "brightnessctl set 5%+";
    # RAISE = "light -A 5";
    raise = "brightnessctl set 1%+";
    # raise = "light -A 1";
    LOWER = "brightnessctl set 5%-";
    # LOWER = "light -U 5";
    lower = "brightnessctl set 1%-";
    # lower = "light -U 1";
  };
  mirror = {
    default = "wl-present mirror"; # Mirror an output or region
    region = "wl-present set-region"; # Change mirrored output or region
    freeze = "wl-present toggle-freeze"; # Freeze mirrored image
  };
  screenshot = let location = "$HOME/screenshot";
  in {
    fullscreen = "grim";
    region = ''grim -g "$(slurp)"'';
    dest-ws = "${location}/${timestamp}_${active_ws}.png";
    dest-zone = "${location}/${timestamp}_${active_win}.png";
  };
  # Hyprland definitions
  workspaces = [
    {
      key = "b"; # $mod+key: focus workspace, $mod+shift+key: move window to it
      name = "web"; # Name of the workspace, better if replaced with an icon
      # Command to execute if moved to the workspace and it’s empty
      empty = config.home.sessionVariables.BROWSER;
      # Command to execute if already focusing the workspace but $mod+key
      already = config.home.sessionVariables.BROWSER_ALT;
    }
    {
      key = "a"; # $mod+key: focus workspace, $mod+shift+key: move window to it
      name = "art"; # Name of the workspace, better if replaced with an icon
      # Command to execute if moved to the workspace and it’s empty
      empty = "${config.launch.category} AudioVideo";
      # Command to execute if already focusing the workspace but $mod+key
      already = mixer;
    }
    # TODO other workspaces definitions …
    # TODO build Hyprland config from these definitions with Nix functions
  ];
in {
  home.packages = with pkgs; [
    jq # Interpret `hyprctl -j` JSON in keybindings
    hyprutils # Hypr ecosystem utilities
    hyprpolkitagent # Hypr Polkit auth agent
    hyprcursor # Modern cursor engine
    # xcur2png # Convert X cursor to PNG, needed for hyprcursor
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true; # Backwards compatibility
    settings = let
      _base07 = config.stylix.base16Scheme.base07;
      base07 = # Remove the leading hash
        "rgb(${builtins.substring 1 (builtins.stringLength _base07) _base07})";
      black = "rgb(000000)"; # Pitch black background for OLED
    in {
      # See https://wiki.hyprland.org/Configuring/
      monitor = lib.mkDefault ", preferred, auto, 1"; # Auto
      debug.disable_logs = false; # Enable logs
      xwayland.force_zero_scaling = true;
      "$mod" = "SUPER";
      gestures.workspace_swipe = false;
      exec-once = [
        "waybar" # Status bar
        "albert" # General quick launcher
        "systemctl --user start hyprpolkitagent" # Polkit authentication agent
      ];
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
      dwindle = {
        pseudotile = true; # master switch for pseudotiling TEST
        preserve_split = true; # you probably want this
      };
      windowrulev2 = [
        # Thunderbird Reminders
        "noinitialfocus, initialClass:thunderbird, initialTitle:.* Reminders?" # Don’t auto focus reminders
        "float, initialClass:thunderbird, initialTitle:.* Reminders?" # Don’t tile reminders
        "move 100%-557 100%-360, initialClass:thunderbird, initialTitle:.* Reminders?" # Right bottom
        "size 555 333, initialClass:thunderbird, initialTitle:.* Reminders?" # Small rectangle
        "opacity 0.7, initialClass:thunderbird, initialTitle:.* Reminders?" # Transparent
        # No border for windows that are the only tiled window of the workspace
        "noborder, floating:0, workspace:w[t1]"
        "norounding, floating:0, workspace:w[t1]"
      ];
      bindd = [
        "$mod CONTROL SHIFT, q, Exit Hyprland (user session), exit,"
        "$mod, comma, Lock session and obfuscates display, exec, ${config.wayland.lock}"
        "$mod CONTROL, comma, Lock session with loginctl, exec, ${config.wayland.lock-session}"
        "$mod SHIFT, comma, Suspend computer to sleep, exec, ${config.wayland.suspend}"
        "SUPER, j, Mirror output or region, exec, ${mirror.default}" # (F9 on Framework Laptop)
        "SUPER SHIFT, j, Freeze mirrored image, exec, ${mirror.freeze}"
        "SUPER SHIFT, j, Change mirrored output or region, exec, ${mirror.region}"
        "$mod, Super_L, Default launcher, exec, ${config.launch.all}"
        "$mod, SPACE, alternative/fallback launcher, exec, ${config.launch.alt}"
        "$mod CONTROL, SPACE, Quick calculator, exec, [float; center; size 888 420] ${config.launch.calc}"
        "$mod SHIFT, SPACE, Quick password manager, exec, ${config.launch.pass}"
        ", Menu, Open launcher with media key, exec, ${config.launch.all}"
        ", XF86MenuKB, Open launcher with media key, exec, ${config.launch.all}"
        ", XF86HomePage, Open launcher with media key, exec, ${config.launch.all}"
        ", XF86Calculator, Quick calculator with media key, exec, ${config.launch.calc}"
        ", XF86Search, Quick search with media key, exec, ${config.launch.all}"
        "$mod, RETURN, Open a default terminal, exec, ${config.term.cmd}"
        "$mod SHIFT, RETURN, Open a floating default terminal, exec, [float; center; size 888 420] ${config.term.cmd}"
        "$mod CONTROL, RETURN, Open an alternative/fallback terminal, exec, ${config.term.alt.cmd}"
        "$mod CONTROL SHIFT, Open floating alt terminal, RETURN, exec, [float; center; size 888 420] ${config.term.alt.cmd}"
        "$mod, f, Toggle window floating, togglefloating,"
        "$mod, w, Toggle window fullscreen, fullscreen,"
        "$mod, q, Close current window, killactive,"
        "$mod CONTROL, q, Close another window by clicking it, exec, hyprctl kill," # FIXME
        "$mod, c, Focus the window on the left, movefocus, l"
        "$mod, t, Focus the window below, movefocus, d"
        "$mod, s, Focus the window above, movefocus, u"
        "$mod, r, Focus the window on the right, movefocus, r"
        "$mod SHIFT, c, Move focused window to the left, movewindoworgroup, l"
        "$mod SHIFT, t, Move focused window below, movewindoworgroup, d"
        "$mod SHIFT, s, Move focused window above, movewindoworgroup, u"
        "$mod SHIFT, r, Move focused window to the right, movewindoworgroup, r"
        "$mod CONTROL SHIFT, c, Move focused window to the left, swapwindow, l"
        "$mod CONTROL SHIFT, t, Move focused window below, swapwindow, d"
        "$mod CONTROL SHIFT, s, Move focused window to the right, swapwindow, u"
        "$mod CONTROL SHIFT, r, Move focused window to the right, swapwindow, r"
        "$mod, g, Toggle group or focus next window in group if there’s one, exec, ${cycleOrToggleGroup}"
        "$mod CONTROL, g, Toggle grouping, togglegroup,"
        "$mod SHIFT, g, Focus next window in group, changegroupactive, f"
        "$mod CONTROL SHIFT, g, Focus previous window in group, changegroupactive, b"
        "$mod CONTROL, b, Open alternative/fallback browser 1, exec, ${config.home.sessionVariables.BROWSER_ALT}"
        "$mod CONTROL SHIFT, b, Open alternative/fallback browser 2, exec, ${config.home.sessionVariables.BROWSER_ALT}"
        ", Print, Take a zoned screenshot, exec, ${screenshot.region} ${screenshot.dest-zone}"
        "CONTROL, Print, Copy screen zone to clipboard, exec, ${screenshot.region} - | wl-copy"
        "SHIFT, Print, Full screenshot, exec, ${screenshot.fullscreen} ${screenshot.dest-ws}"
        "$mod, k, Pick a color anywhere on the screen, exec, ${picker}"
        "$mod, b, Web browsing workspace, workspace, name:web"
        "$mod, b, Open browser in web workspace, exec, ${
          ifWorkspaceEmpty { ws = "web"; }
        } ${config.home.sessionVariables.BROWSER}"
        "$mod SHIFT, b, Move window to web workspace, movetoworkspace, name:web"
        "$mod ALT, b, Move web workspace to monitor, focusworkspaceoncurrentmonitor, name:web"
        "$mod, a, Audio workspace, workspace, name:art"
        "$mod, a, Launch Audio/Video app, exec, ${
          ifWorkspaceEmpty { ws = "art"; }
        } ${config.launch.category} AudioVideo"
        "$mod SHIFT, a, Move window to audio workspace, movetoworkspace, name:art"
        "$mod, p, Go to Personal Information Management workspace, workspace, name:pim"
        "$mod, p, Open Personal Information Management software, exec, ${
          ifWorkspaceEmpty { ws = "pim"; }
        } ${config.organization.pim}"
        ", XF86Mail, Go to Personal Information Management workspace, workspace, name:pim"
        ", XF86Mail, Open Personal Information Management software, exec, ${
          ifWorkspaceEmpty { ws = "pim"; }
        } ${config.organization.pim}"
        "$mod SHIFT, p, Move window to PIM workspace, movetoworkspace, name:pim"
        "$mod, o, Open any file on dedicated workspace, workspace, name:opn"
        "$mod, o, Open any file on dedicated workspace, exec, ${
          ifWorkspaceEmpty { ws = "opn"; }
        } ${open}"
        "$mod, i, Informations / monItorIng workspace, workspace, name:inf"
        "$mod, i, Open monitoring software, exec, ${
          ifWorkspaceEmpty { ws = "inf"; }
        } ${monitor}"
        "$mod, u, SUp / SUpplementary workspace, workspace, name:sup"
        "$mod, u, Launch an app on suplementary workspace, exec, ${
          ifWorkspaceEmpty { ws = "sup"; }
        } ${config.launch.app}"
        "$mod SHIFT, u, SUp / SUpplementary workspace, movetoworkspace, name:sup"
        "$mod, e, Etc (et cetera) workspace, workspace, name:etc"
        "$mod, e, Launch an app on etc workspace, exec, ${
          ifWorkspaceEmpty { ws = "etc"; }
        } ${config.launch.app}"
        "$mod SHIFT, e, Move window to etc workspace, movetoworkspace, name:etc"
        "$mod, x, eXt / eXtra workspace, workspace, name:ext"
        "$mod, x, Launch an app on ext workspace, exec, ${
          ifWorkspaceEmpty { ws = "ext"; }
        } ${config.launch.app}"
        "$mod SHIFT, x, Move window to ext workspace, movetoworkspace, name:ext"
        # Workspaces (Right hand) may auto launch associated app
        "$mod, l, cLi / terminaL workspace, workspace, name:cli"
        "$mod, l, Open a terminal on cli workspace, exec, ${
          ifWorkspaceEmpty { ws = "cli"; }
        } ${config.term.cmd}"
        "$mod SHIFT, l, Move window to cli workspace, movetoworkspace, name:cli"
        "$mod, n, Go to notetaking workspace, workspace, name:not"
        "$mod, n, Open any document in main user folders, exec, ${
          ifWorkspaceEmpty { ws = "not"; }
        } ${open}"
        "$mod SHIFT, n, Move window to notetaking workspace, movetoworkspace, name:not"
        "$mod, m, Go to messaging workspace, workspace, name:msg"
        "$mod, m, Launch a messaging app, exec, ${
          ifWorkspaceEmpty { ws = "msg"; }
        } ${config.launch.app}"
        "$mod, d, Go to DisplayPort workspace, workspace, name:dpp" # FIXME right port
        "$mod SHIFT, d, Move window to DisplayPort workspace, movetoworkspace, name:dpp"
        "$mod, h, Go to HDMI workspace, workspace, name:hdm" # FIXME right port
        "$mod SHIFT, h, Move window to HDMI workspace, movetoworkspace, name:hdm"
        ", XF86AudioMedia, Go to media workspace, workspace, name:media"
        ", XF86AudioMedia, Launch default media player, exec, ${
          ifWorkspaceEmpty { ws = "media"; }
        } ${config.media.favorite}"
        ", XF86Tools, Go to media workspace, workspace, name:media"
        ", XF86Tools, Launch default media player, exec, ${
          ifWorkspaceEmpty { ws = "media"; }
        } ${config.media.favorite}"
        "SHIFT, XF86AudioMedia, Open quick mixer, exec, [float; center; size 888 420] ${mixer}"
        "SHIFT, XF86Tools, Open quick mixer, exec, [float; center; size 888 420] ${mixer}"
      ];
      binde = [
        "$mod SHIFT, c, moveactive, -10 0" # Move left
        "$mod SHIFT, t, moveactive, 0 10" # Move down
        "$mod SHIFT, s, moveactive, 0 -10" # Move up
        "$mod SHIFT, r, moveactive, 10 0" # Move right
        "$mod CONTROL, c, resizeactive, -10 0" # Resize to the left
        "$mod CONTROL, t, resizeactive, 0 10" # Resize to the bottom
        "$mod CONTROL, s, resizeactive, 0 -10" # Resize to the top
        "$mod CONTROL, r, resizeactive, 10 0" # Resize to the right
      ];
      bindl = [
        ", XF86AudioMute, exec, ${audio.speaker.toggle}"
        "SHIFT, XF86AudioMute, exec, ${audio.mic.toggle}"
        "CONTROL, XF86AudioMute, exec, ${audio.mic.toggle}"
        ", XF86AudioMicMute, exec, ${audio.mic.toggle}"
        "SHIFT, XF86AudioMicMute, exec, ${audio.speaker.toggle}"
        "CONTROL, XF86AudioMicMute, exec, ${audio.speaker.toggle}"
        ", XF86AudioPlay, exec, ${audio.play.toggle}"
        "SHIFT, XF86AudioPlay, exec, ${audio.media.toggle}"
        ", XF86AudioPause, exec, ${audio.play.toggle}"
        "SHIFT, XF86AudioPause, exec, ${audio.media.toggle}"
        ", XF86AudioNext, exec, ${audio.play.next}"
        "SHIFT, XF86AudioNext, exec, ${audio.media.next}"
        ", XF86AudioPrev, exec, ${audio.play.previous}"
        "SHIFT, XF86AudioPrev, exec, ${audio.media.previous}"
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
      bindm = [ "$mod, mouse:272, movewindow" "$mod, mouse:273, resizewindow" ];
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
