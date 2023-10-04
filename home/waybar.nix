{ inputs, lib, config, pkgs, hwmon ? "2/temp3_input", ... }: {
  programs = {
    waybar = {
      enable = true;
      settings = {
        bottomBar = {
          layer = "top";
          position = "bottom";

          modules-left = [
            "battery"
            "temperature"
            "cpu"
            "memory"
            "network"
            "pulseaudio"
          ];
          modules-center = [
            "hyprland/workspaces"
            "hyprland/window"
            "sway/workspaces"
            "sway/window"
          ];
          modules-right = [
            "tray"
            "mpris"
            "clock"
          ];

          margin = "1 4 3 4";
          spacing = 3;
          exclusive = true;
          fixed-center = false;

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
            max-length = 8;
            tooltip = false;
          };

          temperature = {
            # thermal-zone = 0;
            hwmon-path = "/sys/class/hwmon/hwmon" + hwmon;
            critical-threshold = "75";
            format = "{icon} {temperatureC}";
            format-icons = [ "" "" "" "" "" ];
            max-length = 6;
            tooltip = false;
          };

          cpu = {
            states = {
              warning = 60;
              critical = 80;
            };
            format = "󰻠 {usage}";
            max-length = 6;
            tooltip = false;
          };

          memory = {
            states = {
              warning = 60;
              critical = 80;
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
            ignored-sinks = [ "Easy Effects Sink" ];
          };

          "hyprland/workspaces" = {
            all-outputs = false;
            # format = "{name}";
            format = "{icon}";
            format-icons = {
              web = "󰖟";
              aud = "";
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
            max-length = 400;
            icon = true;
            tooltip = false;
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
      style = pkgs.lib.readFile style/waybar.css;
      # systemd = { # TEST relevance
      #   enable = true;
      #   target = "sway-session.target";
      # };
    };
  };
}
