{ config, lib, ... }:
{
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  programs.waybar.settings = {
    bottomBar = {
      layer = "top";
      position = "bottom";
      margin = "0";

      modules-left = [
        "battery"
        "temperature"
        "cpu"
        "memory"
        "network"
      ];
      modules-center = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-right = [
        "tray"
        "mpris"
        "pulseaudio"
        "clock"
      ];

      battery = {
        interval = 15;
        full-at = 95;
        states = {
          notfull = 85;
          low = 30;
          warning = 25;
          critical = 15;
        };
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        # format-icons = [ "" "" "" "" "" ]; # FA
        # format-time = "{H}:{m}";
        format-critical = "{icon} {capacity} %";
        format = "{icon} {power:4.2f}";
        format-charging-notfull = "  {power:4.2f}";
        format-charging = " {power:4.2f}"; # When above 85% (full)
        tooltip = false;
        # max-length = 8;
      };

      temperature =
        let # TODO Nixos module options or better, dynamic
          griffin.cpu-temps = [
            "/sys/devices/platform/coretemp.0/hwmon/hwmon7/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon6/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon5/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon1/temp1_input"
            "/sys/devices/platform/coretemp.0/hwmon/hwmon0/temp1_input"
          ];
        in
        {
          hwmon-path = griffin.cpu-temps;
          critical-threshold = "75";
          format = "{icon} {temperatureC}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ]; # FA
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
        format-icons = [
          "󰤯"
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
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
          default = [
            ""
            " "
            " "
          ];
        };
        tooltip = false;
        ignored-sinks = [ "Easy Effects Sink" ];
        # max-length = 20;
      };

      "hyprland/workspaces" = {
        on-click = null;
        all-outputs = false;
        format = "{icon}";
        # TODO Declaratively from ../hyprland/workspaces.nix
        format-icons = {
          art = "";
          web = "";
          dpp = "󰍹";
          etc = "";
          hdm = "";
          int = "";
          cli = ""; # ❯  
          mon = "󱕍";
          not = "";
          opn = "󰥨"; # 
          pim = ""; # 󰸍
          ext = "";
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
          firefox = "";
          brave = "󰖟";
          chromium = "";
          nyxt = "󰖟";
        };
        status-icons = {
          stopped = "";
          playing = "";
          paused = "󰏤";
        };
      };

      clock = {
        timezone = "Europe/Paris"; # TODO Use same timezone as system
        # format = "{: %H:%M  %a %d %b}";
        format = "{:%H:%M %a %d %b}";
        tooltip = false;
        # max-length = 30;
      };
    };
    style = ''
      * {
        margin-top: 0;
        margin-bottom: 0;
        padding-top: 0;
        padding-bottom: 0;
        min-height: 0;
        font-family:
          "${config.stylix.fonts.monospace.name}",
          "FontAwesome", "Symbols Nerd Font";
        font-size: 14;
      }
      @keyframes warn {
        to {
          color: red;
        }
      }
      @keyframes crit {
        to {
          background-color: red;
        }
      }
      #battery.low:not(.charging) {
        color: red;
      }
      #battery.warning:not(.charging),
      #cpu.warning,
      #memory.warning {
        animation-name: warn;
        animation-duration: 0.5s;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      #battery.critical:not(.charging),
      #temperature.critical,
      #cpu.critical,
      #memory.critical {
        animation-name: crit;
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
}
