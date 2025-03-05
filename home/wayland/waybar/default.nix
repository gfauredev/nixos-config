{ config, lib, ... }: {
  programs = {
    waybar = {
      enable = true;
      settings = {
        bottomBar = {
          layer = "top";
          position = "bottom";
          margin = "0";

          modules-left = [ "battery" "temperature" "cpu" "memory" "network" ];
          modules-center = [ "hyprland/workspaces" "hyprland/window" ];
          modules-right = [ "tray" "pulseaudio" "mpris" "clock" ];

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
            # format-icons = [ "" "" "" "" "" ]; # FA
            # format-time = "{H}:{m}";
            format-critical = "{icon} {capacity} %";
            format = "{icon} {power:4.2f}";
            format-charging-notfull = " {power:4.2f}";
            format-charging = " {power:4.2f}"; # When above 85% (full)
            tooltip = false;
            # max-length = 8;
          };

          temperature = let
            hwmon = "4"; # TODO Nixos module options or better, dynamic
            temp = "1"; # TODO Nixos module options or better, dynamic
          in {
            # thermal-zone = 0;
            hwmon-path = "/sys/class/hwmon/hwmon${hwmon}/temp${temp}_input";
            critical-threshold = "75";
            format = "{icon} {temperatureC}";
            format-icons = [ "" "" "" "" "" ]; # FA
            tooltip = false;
            # max-length = 6;
          };

          cpu = {
            states = {
              warning = 60;
              critical = 80;
            };
            # format = "󰻠 {usage}";
            format = " {usage}";
            tooltip = false;
            # max-length = 6;
          };

          memory = {
            states = {
              warning = 60;
              critical = 80;
            };
            format = " {percentage}";
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
            format-source-muted = " ";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" " " " " ];
            };
            tooltip = false;
            ignored-sinks = [ "Easy Effects Sink" ];
            # max-length = 20;
          };

          "hyprland/workspaces" = {
            on-click = null;
            all-outputs = false;
            # format = "{name}";
            format = "{icon}";
            format-icons = {
              web = "";
              art = "";
              pim = ""; # "󰸍";
              opn = ""; # "󰥨";
              inf = "󱕍";
              etc = "";
              ext = "";
              sup = "";
              cli = ""; # "❯"; # ""; # "";
              not = "";
              msg = ""; # "󰵅";
              media = ""; # "";
              dpp = "󰍹";
              hdm = "󰍹"; # "";
            };
          };

          window = {
            format = "{title}";
            icon = true;
            tooltip = false;
            # max-length = lib.mkDefault 400;
          };

          tray.spacing = 3;

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
      # TODO fgBlink to Stylix fg color
      style = ''
        * {
          margin-top: 0;
          margin-bottom: 0;
          padding-top: 0;
          padding-bottom: 0;
          min-height: 0;
        }
        label {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: 14;
        }
        @keyframes fgBlink {
          to {
            color: white;
          }
        }
        @keyframes bgBlink {
          to {
            background-color: rgba(0, 0, 0, 0.8);
          }
        }
        #battery.low:not(.charging) {
          color: red;
        }
        #battery.warning:not(.charging),
        #cpu.warning,
        #memory.warning {
          color: red;
          animation-name: fgBlink;
          animation-duration: 0.5s;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        #battery.critical:not(.charging),
        #temperature.critical,
        #cpu.critical,
        #memory.critical {
          background-color: red;
          animation-name: bgBlink;
          animation-duration: 0.5s;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        #workspaces button {
          padding-left: 0;
          padding-right: 5px;
        }
      '';
    };
  };
}
