{ inputs, lib, config, pkgs, ... }: {
  # TODO create a wayland common config along with sway
  home.packages = with pkgs; [
    hyprpaper # Wallpaper engine
    # swww # Dynamic wallpaper
    # eww # Widgets
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    plugins = [ ];
    settings = {
      # See https://wiki.hyprland.org/Configuring/Monitors
      monitor = [
        "eDP-1,2256x1504@60,0x0,1.4"
        ",preferred,auto,auto"
      ];

      # See https://wiki.hyprland.org/Configuring/Keywords
      env = "XCURSOR_SIZE,24";
      exec-once = [
        "hyprpaper"
        "hyprctl setcursor Nordzy-cursors 24"
        "waybar"
        # "wezterm-mux-server" # TEST relevance
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
        # Workspaces (Left)
        "$mod, b, workspace, name:web" # Browsing workspace
        # /!\ Cannot move to Browsing worspace
        "$mod, a, workspace, name:aud" # Audio workspace
        "$mod SHIFT, a, movetoworkspace, name:aud" # Audio workspace
        "$mod, i, workspace, name:top" # Informations / monItorIng
        # /!\ Cannot move to Monitoring worspace
        "$mod, e, workspace, name:etc" # Etc / Extra workspace
        "$mod SHIFT, e, movetoworkspace, name:etc" # Etc / Extra
        # Workspaces (Right)
        "$mod, l, workspace, name:cli" # cLi / terminaL workspace
        "$mod SHIFT, l, movetoworkspace, name:cli" # cLi / terminaL
        "$mod, n, workspace, name:not" # Notetaking workspace
        "$mod SHIFT, n, movetoworkspace, name:not" # Notetaking
        "$mod, m, workspace, name:msg" # Messaging workspace
        "$mod SHIFT, m, movetoworkspace, name:msg" # Messaging
        # Workspaces (Special)
        "$mod, XF86AudioMedia, workspace, name:med" # Media ws
        # /!\ Cannot move to Media worspace
        # Terminal # TODO test multiplexing, features of wezterm
        "$mod, RETURN, exec, ${pkgs.wezterm}/bin/wezterm start"
        # Launch
        "$mod, SPACE, exec, rofi -show-icons -show combi -combi-modes window,file-browser-extended,drun,emoji"
        "$mod CONTROL, SPACE, exec, rofi -show calc"
        "$mod SHIFT, SPACE, exec, rofi -show-icons -show combi -combi-modes top,ssh,run"
        # Misc
        "$mod, q, killactive," # Close window
        "$mod CONTROL SHIFT, q, exit," # Close wayland session
        "$mod, comma, exec, lock" # Lock screen TODO
        "$mod SHIFT, comma, exec, suspend" # Suspend TODO
        # Web
        "$mod CONTROL, b, exec, nyxt" # Firefox
        "$mod SHIFT, b, exec, firefox" # Nyxt
        "$mod CONTROL SHIFT, b, exec, chromium" # Chromium
      ];
      bindr = [
        # Launch with Super
        "$mod, SPACE, exec, rofi -show-icons -show combi -combi-modes window,file-browser-extended,drun,emoji"
      ];
      binde = [
        # Resize windows
        "$mod CONTROL, c, resizeactive, -10 0" # Move left
        "$mod CONTROL, t, resizeactive, 0 10" # Move down
        "$mod CONTROL, s, resizeactive, 0 -10" # Move up
        "$mod CONTROL, r, resizeactive, 10 0" # Move right
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
        workspace_swipe = false;
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
    # systemdIntegration = true; # TEST relevance
    xwayland.enable = true;
    # extraConfig = ''
    # '';
  };

  xdg.configFile = {
    hyprpaper = {
      target = "hypr/hyprpaper.conf";
      source = ../script+data/hyprpaper.conf;
    };
  };
}
