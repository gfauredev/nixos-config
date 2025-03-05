{ config, lib, ... }: {
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
            format = " {usage}";
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
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
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
          margin: 0;
          padding: 0;
          min-height: 0;
          min-width: 0;
        }
        label {
          font-family: "${config.stylix.fonts.monospace.name}";
          font-size: 12;
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

      '';
      #   window,
      #   box,
      #   widget,
      #   label,
      #   button {
      #     color: inherit;
      #     font-size: inherit;
      #     margin: 0;
      #     padding: 0;
      #     min-height: 0;
      #     min-width: 0;
      #     background-color: transparent;
      #   }

      #   label,
      #   box {
      #     padding: 0 1px;
      #   }

      #   .modules-left label {
      #     margin-left: 0;
      #     margin-right: 8px;
      #   }

      #   #waybar {
      #     color: #fdc;
      #     font-size: 14px;
      #   }

      #   #battery {
      #     min-width: 20px;
      #   }

      #   #pulseaudio {
      #     min-width: 100px;
      #   }

      #   #pulseaudio.muted.source-muted {
      #     min-width: 40px;
      #   }

      #   #pulseaudio.muted,
      #   #pulseaudio.source-muted {
      #     min-width: 75px;
      #   }

      #   #workspaces button {
      #     padding-right: 3px;
      #     margin-right: 3px;
      #     border-radius: 8px;
      #   }

      #   #workspaces {
      #     margin-top: 2px;
      #     margin-bottom: 1px;
      #   }

      #   #workspaces button:last-child {
      #     margin: 0;
      #   }

      #   #workspaces button.urgent {
      #     background-color: #fdc;
      #     animation-name: bgBlink;
      #     animation-duration: 0.5s;
      #     animation-iteration-count: infinite;
      #     animation-direction: alternate;
      #   }

      #   #workspaces button.focused,
      #   #workspaces button.active {
      #     background-color: #fdc;
      #     color: black;
      #   }

      #   #workspaces button:hover {
      #     box-shadow: inherit;
      #     text-shadow: inherit;
      #     background: #876;
      #     border-color: #876;
      #   }

      #   #tray {
      #     border-radius: 8px;
      #   }

      #   #clock {
      #     min-width: 160px;
      #     padding: 0 1px;
      #   }
      # '';
    };
  };
}
