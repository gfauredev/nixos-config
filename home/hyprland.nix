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
      monitor = ",preferred,auto,auto";

      # See https://wiki.hyprland.org/Configuring/Keywords
      env = "XCURSOR_SIZE,24";
      # exec-once = hyprpaper & waybar # TEST relevance

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
        # TODO move windows
        # Workspaces (Left)
        "$mod, b, workspace, web" # Browsing workspace
        # /!\ Cannot move to Browsing worspace
        "$mod, a, workspace, aud" # Audio workspace
        "$mod SHIFT, a, movetoworkspace, aud" # Audio workspace
        "$mod, i, workspace, top" # Informations / monItorIng
        # /!\ Cannot move to Monitoring worspace
        "$mod, e, workspace, etc" # Etc / Extra workspace
        "$mod SHIFT, e, movetoworkspace, etc" # Etc / Extra
        # Workspaces (Right)
        "$mod, l, workspace, cli" # cLi / terminaL workspace
        "$mod SHIFT, l, movetoworkspace, cli" # cLi / terminaL
        "$mod, n, workspace, not" # Notetaking workspace
        "$mod SHIFT, n, movetoworkspace, not" # Notetaking
        "$mod, m, workspace, msg" # Messaging workspace
        "$mod SHIFT, m, movetoworkspace, msg" # Messaging
        # Workspaces (Special)
        "$mod, XF86AudioMedia, workspace, med" # Media workspace
        # /!\ Cannot move to Media worspace
        # Terminal
        "$mod, RETURN, exec, ${pkgs.wezterm}/bin/wezterm start --always-new-process"
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

      # See https://wiki.hyprland.org/Configuring/Variables
      general = {
        gaps_in = 3;
        gaps_out = 0;
        border_size = 2;
        layout = "dwindle";
        cursor_inactive_timeout = 1;
        # col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        # col.inactive_border = "rgba(595959aa)";
      };

      # See https://wiki.hyprland.org/Configuring/Variables
      # gestures = {
      #   workspace_swipe = false;
      # };

      # decoration = {
      #   rounding = 10;
      #   blur = {
      #     enabled = true;
      #     size = 3;
      #     passes = 1;
      #   };
      #   drop_shadow = true;
      #   shadow_range = 4;
      #   shadow_render_power = 3;
      #   col.shadow = "rgba(1a1a1aee)";
      # };

      # See https://wiki.hyprland.org/Configuring/Animations
      # animations = {
      #   enabled = true;
      #   bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      #   animation = [
      #     "windows, 1, 7, myBezier"
      #     "windowsOut, 1, 7, default, popin 80%"
      #     "border, 1, 10, default"
      #     "borderangle, 1, 8, default"
      #     "fade, 1, 7, default"
      #     "workspaces, 1, 6, default"
      #   ];
      # };
    };
    # systemdIntegration = true; # TEST relevance
    xwayland.enable = true;
    # extraConfig = ''
    # '';
  };
}
