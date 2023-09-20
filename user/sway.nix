{ inputs, lib, config, pkgs, ... }:
let
  term = "${pkgs.wezterm}/bin/wezterm start --always-new-process"; # Exec
  term-name = "wezterm"; # Name
  term-exec = term;
  term-menu = "${term-exec} --class menu"; # Menu term
  # launch = "${pkgs.rofi-wayland}/bin/rofi"; # Launcher
  launch = "rofi -show combi -show-icons -combi-modes"; # Launcher # TODO absolute path
  mod = "Mod4"; # Keys used to work with SUPER
  left = "c";
  down = "t";
  up = "s";
  right = "r";
in
{
  home.packages = with pkgs; [
    wlr-randr # Edit display settings for wayland
    wl-clipboard # Copy from CLI
    hyprpicker # Better color picker
    grim # Take screenshots
    slurp # Select a screen zone with mouse
    wev # Evaluate inputs to wayland
    swaybg # Display a background
    autotiling # Simulate dwindle layout on sway and i3
    # wl-color-picker # A color picker
    # onagre # TEST which launcher is better
    # albert # Previous general purpose launcher
    # swayidle # Perform actions if inactive
    # kanshi # TEST if relevant
    # pcmanfm # TEST if relevant, TODO display files previews in terminal
    # swaylock # Screen locker for wayland
    # autotiling-rs
    # wpaperd
    # fuzzel
    # eww
  ];

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      left = left;
      down = down;
      up = up;
      right = right;
      output = {
        "*" = {
          bg = "$HOME/.wallpapers/island.jpg fill";
        };
        eDP-1 = {
          bg = "$HOME/.wallpapers/island.jpg fill";
          scale = "1.5";
          resolution = "2256x1504";
        };
        DP-1 = {
          bg = "$HOME/.wallpapers/island.jpg fill";
          scale = "1.5";
          # resolution = "3440x1440";
        };
        # HDMI-A-1 = {
        #   resolution = "1920x1080 position 0 1080";
        # };
        # HDMI-A-2 = {
        #   resolution = "1920x1080 position 0 1080";
        # };
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "fr,us,fr";
          xkb_variant = "bepo_afnor,,";
          xkb_options = "grp:ctrls_toggle";
          repeat_delay = "250";
          repeat_rate = "50";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "disabled";
          middle_emulation = "enabled";
        };
      };
      seat = {
        "*" = {
          hide_cursor = "when-typing enable";
          xcursor_theme = "Nordzy-cursors 24";
        };
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
        # Exit sway (logs out of Wayland session)
        "${mod}+Control+Shift+q" = "exec swaymsg exit";
        # Lock & Suspend
        "${mod}+comma" = "exec swaylock -f -i $HOME/.wallpapers/desert.jpg"; # TODO select a random one
        "${mod}+Shift+comma" = "exec systemctl suspend";

        # Launch
        "${mod}+space" = "exec ${launch} 'drun,window'"; # General
        "${mod}+Shift+space" = "exec ${launch} 'top'"; # TODO setings
        "${mod}+Shift+m" = "exec ${launch} 'calc'"; # TODO maths
        "${mod}+o" = "exec ${launch} 'filebrowser'"; # TODO file opening
        "${mod}+Shift+o" = "exec ${launch} 'file-browser-extended'"; # TODO advanced file opening
        # Tools
        # Browsers
        "${mod}+Control+b" = "exec firefox";
        "${mod}+Shift+Control+b" = "exec chromium";
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
        "${mod}+b" = "workspace 󰖟; exec pgrep -i $BROWSER || $BROWSER";
        "${mod}+a" = "workspace ; exec pgrep -i ardour || ardour7";
        "${mod}+eacute" = "workspace 󰵅; exec pgrep -i discord || discord ; exec pgrep -i signal || signal-desktop";
        # "${mod}+u" = "workspace ; exec swaymsg -t get_tree | grep -i ${term} || ${term-exec}";
        # "${mod}+u" = "workspace ; exec swaymsg -t get_tree | grep -i ${term} || ${term-exec}";
        "${mod}+u" = "workspace ; exec swaymsg -t get_tree | grep -i ${term-name} || ${term-exec}";
        "${mod}+i" = "workspace 󰋼; exec pgrep -i btm || ${term-exec} --class btm btm";
        "${mod}+e" = "workspace  …";
        "${mod}+n" = "workspace ; exec swaymsg -t get_tree | grep -i 'app_id.*note' || exec ${term-exec} --cwd ~/note/ --class note $EDITOR";
        # "${mod}+n" = "workspace ";
        # "${mod}+Control+n" = "workspace ; exec swaymsg -t get_tree | grep -i 'app_id.*note-tomorrow' || exec ${term-exec} --cwd ~/note/ --class note-tomorrow note tomorrow";
        # "${mod}+Shift+Control+n" = "workspace ; exec swaymsg -t get_tree | grep -i 'app_id.*note-yesterday' || exec ${term-exec} --cwd ~/note/ --class note-yesterday note yesterday";
        "${mod}+l" = "workspace 󰑴; exec pgrep -i anki || anki";
        # Move focused container to workspaces
        "${mod}+Shift+b" = "move container to workspace 󰖟";
        "${mod}+Shift+a" = "move container to workspace ";
        "${mod}+Shift+eacute" = "move container to workspace 󰵅";
        # "${mod}+Shift+u" = "move container to workspace ";
        "${mod}+Shift+u" = "move container to workspace ";
        # "${mod}+Shift+p" = "move container to workspace ";
        "${mod}+Shift+i" = "move container to workspace 󰋼";
        "${mod}+Shift+e" = "move container to workspace  …";
        "${mod}+Shift+n" = "move container to workspace ";
        "${mod}+Shift+l" = "move container to workspace 󰑴";

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

        # Media controls
        "XF86AudioPause" = "exec playerctl play-pause";
        "Shift+XF86AudioPause" = "exec playerctl play-pause -p spotify";
        "XF86AudioPlay" = "exec playerctl play-pause";
        "Shift+XF86AudioPlay" = "exec playerctl play-pause -p spotify";

        "XF86AudioNext" = "exec playerctl next";
        "Shift+XF86AudioNext" = "exec playerctl next -p spotify";
        "XF86AudioPrev" = "exec playerctl previous";
        "Shift+XF86AudioPrev" = "exec playerctl previous -p spotify";

        "Print" = "exec grim -g \"$(slurp)\" $HOME/img/$(date +'%Y-%m-%d_%Hh%Mm%Ss.png')";
        "Shift+Print" = "exec grim $HOME/img/$(date +'%Y-%m-%d_%Hh%Mm%Ss.png')";
        "XF86AudioMedia" = "workspace ; exec pgrep -i spotify || spotify";
        "${mod}+Shift+p" = "workspace ; exec pgrep -i spotify || spotify";
        "Shift+XF86AudioMedia" = "exec ${term-menu} pulsemixer";
        "${mod}+m" = "exec ${term-menu} pulsemixer";
        "${mod}+p" = "exec hyprpicker";

        "XF86RFKill" = "exec rfkill toggle 0 1"; # Disable two first interfaces

        # Audio controls
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "Shift+XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        "Shift+XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "Control+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
        "Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
        "Control+Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+";

        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "Control+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        "Shift+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
        "Control+Shift+XF86AudioLowerVolume" = "exec set-volume @DEFAULT_AUDIO_SINK@ 1%-";
      };
      bars = [
        {
          command = "waybar";
          fonts = {
            # names = [ "Fira Code" ];
            names = [ "FiraCode Nerd Font" ];
            style = "Light";
            size = 10.0;
          };
        }
      ];
      startup = [
        { command = "autotiling --limit 4"; }
        # { command = "gsettings set org.gnome.desktop.interface cursor-theme 'Nordzy-cursors'"; } # TODO With Nix directly
      ];
      defaultWorkspace = "workspace …";
      window.titlebar = false;
      modes = { };
    };
    extraConfig = ''
      default_border pixel 2
      hide_edge_borders --i3 smart
      floating_modifier ${mod} normal

      for_window [app_id="menu"] floating enable, resize set width 888 px height 420 px
    '';
    # extraOptions = [
    # "--unsupported-gpu"
    # "--verbose"
    # "--debug"
    # ];
    # extraSessionCommands = '' # TODO with nix directly
    #   ln --force -s ${pkgs.nordzy-cursor-theme}/share/icons/Nordzy-cursors/ $HOME/.icons/  # Set up cursor icons
    # '';
    # systemd.enable = true; # TEST relevance
    wrapperFeatures = {
      base = true;
      gtk = true; # TEST if relevant
    };
    xwayland = true;
  };

  services = {
    clipman = {
      enable = true;
      systemdTarget = "sway-session.target";
    };
    swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.playerctl}/bin/playerctl pause"; }
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f -i $HOME/.wallpapers/desert.jpg"; }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "swaymsg 'output * dpms off'";
          resumeCommand = "swaymsg 'output * dpms on'";
        }
        {
          timeout = 330;
          command = "swaylock -f -i $HOME/.lockscreen";
        }
        { timeout = 600; command = "systemctl suspend"; }
      ];
      systemdTarget = "sway-session.target";
    };
  };

  programs = {
    # TODO set with nix directly, or more cleanly
    zsh.loginExtra = ''
      # Start window managers at login on first TTYs
      if [ -z "''${DISPLAY}" ]; then
        if [ "''${XDG_VTNR}" -eq 1 ]; then
          exec $HOME/.nix-profile/bin/sway
        fi
        if [ "''${XDG_VTNR}" -eq 2 ]; then
          exec startx $HOME/.nix-profile/bin/i3
        fi
      fi
    '';
    swaylock = {
      enable = true;
      settings = {
        indicator-idle-visible = true;
      };
    };
    waybar = {
      enable = true;
      settings = {
        bottomBar = {
          layer = "top";
          position = "bottom";
          # height = 0;
          # width = 0;

          modules-left = [
            "battery"
            "temperature"
            "cpu"
            "memory"
            "network"
            "pulseaudio"
          ];
          modules-center = [
            "sway/workspaces"
            "sway/window"
          ];
          modules-right = [
            "tray"
            "mpris"
            "clock"
          ];

          margin = "0 3 3 3";
          spacing = 3;
          exclusive = true;
          fixed-center = false;
          # passthrough = true;

          battery = {
            states = {
              warning = "30";
              critical = "15";
            };
            format = "{icon} {capacity}";
            format-charging = "󱐥 {capacity}";
            # format-time = "{H}:{M}";
            format-icons = [ " " " " " " " " " " ];
            max-length = 8;
            tooltip = false;
          };

          temperature = {
            # thermal-zone = 5;
            thermal-zone = 2;
            critical-threshold = "75";
            format = "{icon} {temperatureC}";
            format-icons = [ "" "" "" "" "" ];
            max-length = 6;
            tooltip = false;
          };

          cpu = {
            states = {
              warning = "60";
              critical = "80";
            };
            format = "󰻠 {usage}";
            max-length = 6;
            tooltip = false;
          };

          memory = {
            states = {
              warning = "60";
              critical = "80";
            };
            format = " {percentage}";
            max-length = 6;
            tooltip = false;
          };

          network = {
            format = "󰈂 {ifname}";
            format-wifi = "{icon} {ipaddr}/{cidr}";
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
            format-ethernet = "󰈀 {ipaddr}/{cidr}";
            format-disconnected = "󰤮 {ifname}";
            max-length = 20;
            tooltip = false;
          };

          pulseaudio = {
            format = "{icon} {volume} {format_source}";
            format-bluetooth = "{icon}  {volume} {format_source}";
            format-bluetooth-muted = "{icon}  󰸈 {format_source}";
            format-muted = "󰸈 {format_source}";
            format-source = " {volume}";
            format-source-muted = " ";
            format-icons = {
              headphone = "";
              hands-free = "󰋎";
              headset = "󰋎";
              phone = "";
              portable = "";
              car = " ";
              default = [ "" "" " " ];
            };
            max-length = 20;
            tooltip = false;
          };

          window = {
            format = "{title}";
            max-length = 400;
            icon = true;
            tooltip = false;
          };

          workspaces = {
            all-outputs = false;
            format = "{name}";
            disable-scroll = true; # TODO not working
            disable-click = true; # TODO not working
          };

          tray = {
            spacing = 3;
          };

          mpris = {
            # format = "{status_icon} {dynamic} {player_icon}";
            format = "{player_icon} {status_icon}";
            player-icons = {
              default = "";
              spotify = "";
              spotifyd = "";
              mpv = "";
              brave = "";
              chromium = "";
              chrome = "";
              firefox = "";
            };
            status-icons = {
              stopped = "";
              playing = "";
              paused = "󰏤";
            };
          };

          clock = {
            timezone = "Europe/Paris";
            format = "{: %H:%M  %a %d %b}";
            max-length = 30;
            tooltip = false;
          };
        };
      };
      style = pkgs.lib.readFile ../style/waybar.css;
      # systemd = { # TEST relevance
      #   enable = true;
      #   target = "sway-session.target";
      # };
    };
    rofi = {
      enable = true; # TEST which launcher is better
      package = pkgs.rofi-wayland;
      cycle = true;
      font = "FiraCode Nerd Font";
      location = "top";
      pass = {
        enable = true;
        # extraConfig = ''
        # '';
        # stores = [];
      };
      plugins = with pkgs; [
        rofi-file-browser
        rofi-calc
        rofi-top
        rofi-emoji
        rofi-bluetooth
        rofi-pulse-select
        rofi-systemd
      ];
      # shell = "${pkgs.dash}/bin/dash";
      terminal = "${term-exec}";
      theme = "arthur";
      extraConfig = {
        # modi = "combi,drun,filebrowser,calc,emoji,top,file-browser-extended,keys,window,run,ssh";
        modi = "combi,drun,filebrowser,calc,emoji,top,window";
      };
    };
    # wofi = {
    #   enable = true; # TEST if better than rofi
    # };
  };
}
