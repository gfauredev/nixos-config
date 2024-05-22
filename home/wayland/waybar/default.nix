{ lib, pkgs, hwmon, ... }: {
  programs = {
    waybar = {
      enable = true;
      settings = {
        bottomBar = {
          layer = "top";
          position = "bottom";

          modules-left =
            [ "battery" "temperature" "cpu" "memory" "network" "pulseaudio" ];
          modules-center = [ "hyprland/workspaces" "hyprland/window" ];
          modules-right = [ "tray" "mpris" "clock" ];

          margin = "0";
          exclusive = true; # No drawing on top or underneath
          # fixed-center = false; # Fixed position of center module

          battery = {
            states = {
              low = 30;
              warning = 25;
              critical = 15;
            };
            format = "{icon} {capacity}";
            format-charging = "󱐥 {capacity}";
            # format-time = "{H}:{M}";
            format-icons = [ " " " " " " " " " " ];
            # max-length = 8;
            tooltip = false;
          };

          temperature = {
            # thermal-zone = 0;
            hwmon-path = "/sys/class/hwmon/hwmon" + hwmon;
            critical-threshold = "75";
            format = "{icon} {temperatureC}";
            format-icons = [ "" "" "" "" "" ];
            # max-length = 6;
            tooltip = false;
          };

          cpu = {
            states = {
              warning = 60;
              critical = 80;
            };
            format = "󰻠 {usage}";
            # max-length = 6;
            tooltip = false;
          };

          memory = {
            states = {
              warning = 60;
              critical = 80;
            };
            format = " {percentage}";
            # max-length = 6;
            tooltip = false;
          };

          network = {
            format = "󰈂 {ifname}";
            format-wifi = "{icon} {ipaddr}/{cidr}";
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
            format-ethernet = "󰈀 {ipaddr}/{cidr}";
            format-disconnected = "󰤮 {ifname}";
            # max-length = 20;
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
            # max-length = 20;
            tooltip = false;
            ignored-sinks = [ "Easy Effects Sink" ];
          };

          "hyprland/workspaces" = {
            all-outputs = false;
            # format = "{name}";
            format = "{icon}";
            format-icons = {
              web = "󰖟";
              aud = "";
              pim = "󰸍";
              opn = "󰥨";
              top = "󱕍";
              etc = "";
              ext = "";
              sup = "";
              cli = "❯";
              # cli = "";
              # cli = "";
              not = "";
              msg = "󰵅";
              med = "";
              dpp = "󰍹";
              hdm = "󰍹";
            };
          };

          window = {
            format = "{title}";
            # max-length = lib.mkDefault 400;
            icon = true;
            tooltip = false;
          };

          tray = { spacing = 3; };

          mpris = {
            format = lib.mkDefault "{player_icon} {status_icon} {dynamic}";
            dynamic-len = lib.mkDefault 20;
            player-icons = {
              default = "";
              spotify = "";
              spotifyd = "";
              mpv = "";
              brave = "";
              chromium = "";
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
            # format = "{: %H:%M  %a %d %b}";
            format = "{:%H:%M %a %d %b}";
            # max-length = 30;
            tooltip = false;
          };
        };
      };
      style = pkgs.lib.readFile ./style.css;
      # systemd = { # TEST relevance
      #   enable = true;
      #   target = "sway-session.target";
      # };
    };
  };
}
