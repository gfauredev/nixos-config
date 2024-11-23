{ lib, pkgs, ... }: {
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
            interval = 15;
            full-at = 95;
            states = {
              notfull = 85;
              low = 30;
              warning = 25;
              critical = 15;
            };
            format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰂀" "󰂁" "󰂂" "󰁹" ];
            # format-icons =
            #   [ "< " "> " "< " "> " "< " "> " "< " "> " "< " "> " ];
            # format-time = "{H}:{m}";
            format = "{icon} {power:4.2f}";
            format-charging-notfull = " {power:4.2f}";
            # format-charging-notfull = " {power:4.2f}";
            format-charging = "󱐥 {power:4.2f}";
            # format = "{icon} {capacity}";
            # format-charging = "󱐥 {cycles}";
            # format-charging = "󱐥 {capacity}";
            tooltip = false;
            # max-length = 8;
          };

          temperature = let
            hwmon = "6";
            temp = "1";
          in {
            # thermal-zone = 0;
            hwmon-path = "/sys/class/hwmon/hwmon${hwmon}/temp${temp}_input";
            critical-threshold = "75";
            format = "{icon} {temperatureC}";
            format-icons = [ "" "" "" "" "" ];
            tooltip = false;
            # max-length = 6;
          };

          cpu = {
            states = {
              warning = 60;
              critical = 80;
            };
            format = "󰻠 {usage}";
            tooltip = false;
            # max-length = 6;
          };

          memory = {
            states = {
              warning = 60;
              critical = 80;
            };
            format = " {percentage}";
            tooltip = false;
            # max-length = 6;
          };

          network = {
            format = "󰈂 {ifname}";
            format-wifi = "{icon} {ipaddr}/{cidr}";
            format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
            format-ethernet = "󰈀 {ipaddr}/{cidr}";
            format-disconnected = "󰤮 {ifname}";
            tooltip = false;
            # max-length = 20;
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
            tooltip = false;
            ignored-sinks = [ "Easy Effects Sink" ];
            # max-length = 20;
          };

          "hyprland/workspaces" = {
            all-outputs = false;
            # format = "{name}";
            format = "{icon}";
            format-icons = {
              web = "󰖟";
              art = "";
              pim = "󰸍";
              opn = "󰥨";
              top = "󱕍";
              etc = "";
              ext = "";
              sup = "";
              cli = "❯"; # ""; # "";
              note = "";
              msg = "󰵅";
              media = "";
              dpp = "󰍹";
              hdm = "";
            };
          };

          window = {
            format = "{title}";
            icon = true;
            tooltip = false;
            # max-length = lib.mkDefault 400;
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
              brave = "󰖟";
              firefox = "";
              nyxt = "󰖟";
              chromium = "";
            };
            status-icons = {
              stopped = "";
              playing = "";
              paused = "󰏤";
            };
          };

          clock = {
            # timezone = "Europe/Paris";
            # format = "{: %H:%M  %a %d %b}";
            format = "{:%H:%M %a %d %b}";
            tooltip = false;
            # max-length = 30;
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
