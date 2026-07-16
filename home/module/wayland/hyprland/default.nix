{
  lib,
  pkgs,
  config,
  ...
}:
let
  hlLib = import ./lib.nix { inherit lib config; };
  workspaceSet = import ./workspaces.nix { inherit lib config; };
  cycleOrToggleGroup = "hyprctl -j activewindow | jq -e '.grouped[0,1]' && hyprctl dispatch changegroupactive f || hyprctl dispatch togglegroup";
  pick = "hyprpicker --autocopy"; # Color picker
  timestamp = "$(date +'%Y-%m-%d-%Hh%Mm%S')"; # Current date as string
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
    play.toggle = "playerctl play-pause"; # -p ${config.media}";
    play.pause = "playerctl pause"; # -p ${config.media}";
    play.next = "playerctl next"; # -p ${config.media}";
    play.previous = "playerctl previous";
  };
  brightness = {
    raise = "brightnessctl --device intel_backlight set 1%+";
    RAISE = "brightnessctl --device intel_backlight set 5%+";
    lower = "brightnessctl --device intel_backlight set 1%-";
    LOWER = "brightnessctl --device intel_backlight set 5%-";
  };
  mirror = {
    default = "wl-present mirror"; # Mirror an output or region
    region = "wl-present set-region"; # Change mirrored output or region
    freeze = "wl-present toggle-freeze"; # Freeze mirrored image
  };
  screenshot = rec {
    activeWin = ''$(hyprctl activewindow -j | jq -r '.["title"]' | tr '/|\\ ' '\n' | tail -n1)'';
    activeWs = ''$(hyprctl activeworkspace -j | jq -r '.["name"]')'';
    fullscreen = "grim";
    region = ''grim -g "$(slurp)"'';
    dest-ws = "${config.home.sessionVariables.XDG_PICTURES_DIR}/screenshot/${activeWs}${timestamp}.png";
    dest-zone = "${config.home.sessionVariables.XDG_PICTURES_DIR}/screenshot/${activeWin}${timestamp}.png";
  };
in
{
  home.packages = with pkgs; [
    jq # Interpret `hyprctl -j` JSON in keybindings
    hyprutils # Hypr ecosystem utilities
    hyprcursor # Modern cursor engine
    hyprshell # Window switcher & application launcher TODO configure
    # hyprpolkitagent # Hypr Polkit auth agent
  ];

  wayland.windowManager.hyprland = {
    enable = true; # See https://wiki.hyprland.org/Configuring
    systemd.enable = true;
    xwayland.enable = true; # Backwards compatibility
    configType = "lua";
    settings =
      let
        _base07 = config.stylix.base16Scheme.base07;
        base07 = "rgb(${builtins.substring 1 (builtins.stringLength _base07) _base07})";
        black = "rgb(000000)"; # Pitch black background for OLED
      in
      {
        config.debug.disable_logs = false; # Enable logs
        config.xwayland.force_zero_scaling = true;
        config.input = {
          kb_layout = "fr,us";
          kb_variant = "bepo_afnor,";
          kb_options = "grp:alt_altgr_toggle"; # ctrls_toggle alt_shift_toggle shifts_toggle alts_toggle
          repeat_delay = 190;
          repeat_rate = 50;
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false; # Going up goes up
          tablet.output = "current";
        };
        bind = [
          {
            _args = [
              # ${mod}, RETURN, Open a default terminal, exec, ${config.term.cmd}
              (lib.generators.mkLuaInline "\"SUPER + RETURN\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.term.cmd}\")")
            ];
          }
          {
            _args = [
              # ${mod} CONTROL, RETURN, Open an alternative/fallback terminal, exec, ${config.term.alt.cmd}
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + RETURN\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.term.alt.cmd}\")")
            ];
          }
          {
            # ${mod}, q, Close current window, killactive,
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + q\"")
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
              { locked = true; } # Why?
            ];
          }
          {
            # ${mod}, BackSpace, Close current window, killactive,
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + BackSpace\"")
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
              { locked = true; } # Why?
            ];
          }
          {
            # ${mod}, Delete, Close current window, killactive,
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + Delete\"")
              (lib.generators.mkLuaInline "hl.dsp.window.close()")
              { locked = true; } # Why?
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + SHIFT + q\"")
              (lib.generators.mkLuaInline "hl.dsp.exit()")
              { description = "Exit Hyprland (user session)"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + comma\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.wayland.lock}\")")
              { description = "Lock session and obfuscates display"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + comma\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.wayland.lock-session}\")")
              { description = "Lock session with loginctl"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + comma\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.wayland.suspend}\")")
              { description = "Suspend computer to sleep"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + j\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${mirror.default}\")")
              { description = "Mirror output or region"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + j\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${mirror.freeze}\")")
              { description = "Freeze mirrored image"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + j\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${mirror.region}\")")
              { description = "Change mirrored output or region"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + Super_L\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launch.all}\")")
              { description = "Default launcher"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + Super_L\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launch.alt2}\")")
              { description = "alternative/fallback launcher"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SPACE\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launch.alt}\")")
              { description = "alternative/fallback launcher"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"Menu\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launch.all}\")")
              { description = "Open launcher with media key"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86MenuKB\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launch.all}\")")
              { description = "Open launcher with media key"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86HomePage\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${config.launch.all}\")")
              { description = "Open launcher with media key"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86Calculator\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\'${config.launch.calc}\')")
              { description = "Quick calculator with media key"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86Search\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\'${config.launch.all}\')")
              { description = "Quick search with media key"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + f\"")
              (lib.generators.mkLuaInline "hl.dsp.window.float({ action = \"toggle\" })")
              { description = "Toggle window floating"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + w\"")
              (lib.generators.mkLuaInline "hl.dsp.window.fullscreen()")
              { description = "Toggle window fullscreen"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + c\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"l\" })")
              { description = "Focus the window on the left"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + t\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"d\" })")
              { description = "Focus the window below"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + s\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"u\" })")
              { description = "Focus the window above"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + r\"")
              (lib.generators.mkLuaInline "hl.dsp.focus({ direction = \"r\" })")
              { description = "Focus the window on the right"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + c\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"l\" })")
              { description = "Move focused window to the left"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + t\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"d\" })")
              { description = "Move focused window below"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + s\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"u\" })")
              { description = "Move focused window above"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + r\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ direction = \"r\" })")
              { description = "Move focused window to the right"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + SHIFT + c\"")
              (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"l\" })")
              { description = "Move focused window to the left"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + SHIFT + t\"")
              (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"d\" })")
              { description = "Move focused window below"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + SHIFT + s\"")
              (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"u\" })")
              { description = "Move focused window to the right"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + SHIFT + r\"")
              (lib.generators.mkLuaInline "hl.dsp.window.swap({ direction = \"r\" })")
              { description = "Move focused window to the right"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + g\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${cycleOrToggleGroup}\")")
              { description = "Toggle group or focus next window in group if there’s one"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + g\"")
              (lib.generators.mkLuaInline "hl.dsp.group.toggle()")
              { description = "Toggle grouping"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + g\"")
              (lib.generators.mkLuaInline "hl.dsp.group.next()")
              { description = "Focus next window in group"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + SHIFT + g\"")
              (lib.generators.mkLuaInline "hl.dsp.group.prev()")
              { description = "Focus previous window in group"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"Print\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd([[${screenshot.region} ${screenshot.dest-zone}]])")
              { description = "Take a zoned screenshot"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + Print\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd([[${screenshot.region} - | wl-copy]])")
              { description = "Copy screen zone to clipboard"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + Print\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd([[${screenshot.fullscreen} ${screenshot.dest-ws}]])")
              { description = "Full screenshot"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + k\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${pick}\")")
              { description = "Pick a color anywhere on the screen"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioMedia\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"[float; center; size 888 420] ${config.launch.mix}\")")
              { description = "Open audio mixer"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86Tools\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"[float; center; size 888 420] ${config.launch.mix}\")")
              { description = "Open audio mixer"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86AudioMedia\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"[float; center; size 888 420] ${config.term.cmd} ${config.term.exec} bluetoothctl\")")
              { description = "Open bluetooth manager"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86Tools\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"[float; center; size 888 420]  ${config.term.cmd} ${config.term.exec} bluetoothctl\")")
              { description = "Open bluetooth manager"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86AudioMedia\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"[float; center; size 888 420] ${config.term.cmd} ${config.term.exec} bluetoothctl\")")
              { description = "Open bluetooth manager"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86Tools\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"[float; center; size 888 420]  ${config.term.cmd} ${config.term.exec} bluetoothctl\")")
              { description = "Open bluetooth manager"; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + c\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ x = -10, y = 0, relative = true })")
              { repeating = true; }
            ];
          } # Move left
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + t\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ x = 0, y = 10, relative = true })")
              { repeating = true; }
            ];
          } # Move down
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + s\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ x = 0, y = -10, relative = true })")
              { repeating = true; }
            ];
          } # Move up
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + SHIFT + r\"")
              (lib.generators.mkLuaInline "hl.dsp.window.move({ x = 10, y = 0, relative = true })")
              { repeating = true; }
            ];
          } # Move right
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + c\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = -10, y = 0, relative = true })")
              { repeating = true; }
            ];
          } # Resize to the left
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + t\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = 10, relative = true })")
              { repeating = true; }
            ];
          } # Resize to the bottom
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + s\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 0, y = -10, relative = true })")
              { repeating = true; }
            ];
          } # Resize to the top
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + CONTROL + r\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize({ x = 10, y = 0, relative = true })")
              { repeating = true; }
            ];
          } # Resize to the right
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioMute\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86AudioMute\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86AudioMute\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioMicMute\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86AudioMicMute\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86AudioMicMute\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioPlay\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.play.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioPause\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.play.toggle}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioNext\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.play.next}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioPrev\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.play.previous}\")")
              { locked = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86MonBrightnessUp\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightness.RAISE}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86MonBrightnessDown\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightness.LOWER}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86MonBrightnessUp\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightness.raise}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86MonBrightnessDown\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightness.lower}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86MonBrightnessUp\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightness.raise}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86MonBrightnessDown\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${brightness.lower}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioRaiseVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.RAISE}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86AudioRaiseVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.raise}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86AudioRaiseVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.RAISE}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + SHIFT + XF86AudioRaiseVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.raise}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"XF86AudioLowerVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.LOWER}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + XF86AudioLowerVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.speaker.lower}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SHIFT + XF86AudioLowerVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.LOWER}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"CONTROL + SHIFT + XF86AudioLowerVolume\"")
              (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"${audio.mic.lower}\")")
              {
                repeating = true;
                locked = true;
              }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + mouse:272\"")
              (lib.generators.mkLuaInline "hl.dsp.window.drag()")
              { mouse = true; }
            ];
          }
          {
            _args = [
              (lib.generators.mkLuaInline "\"SUPER + mouse:273\"")
              (lib.generators.mkLuaInline "hl.dsp.window.resize()")
              { mouse = true; }
            ];
          }
        ]
        ++ (hlLib.genBinds "SUPER" workspaceSet);
        monitor = lib.mkDefault [
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = 1;
          }
        ];
        config.general = {
          gaps_in = 0; # Keep only borders, spare screen surface
          gaps_out = 0; # Keep only borders, spare screen surface
          border_size = 2; # Keep only borders, spare screen surface
          layout = "dwindle"; # Default new window placement algorithm
          "col.inactive_border" = lib.mkForce black; # Low-cost gaps
        };
        config.cursor = {
          no_hardware_cursors = false;
          inactive_timeout = 1;
          enable_hyprcursor = true;
          hide_on_key_press = true;
          hide_on_touch = true;
        };
        config.dwindle.preserve_split = true; # you probably want this
        config.group = {
          groupbar.enabled = false; # Don’t eat my screen space
          "col.border_active" = lib.mkForce base07; # Stylix
          "col.border_inactive" = lib.mkForce black; # Low-cost gaps
        };
        config.decoration = {
          rounding = 6;
          blur.enabled = lib.mkDefault false; # Save power
          shadow.enabled = false; # Save power
        };
        config.animations.enabled = lib.mkDefault false; # Save power
        config.misc.background_color = lib.mkForce "0x000000"; # Stylix
        window_rule = [
          {
            match = {
              float = false;
              workspace = "w[t1]";
            };
            border_size = 0; # No border for single tiled
          }
          {
            match.title = "Albert";
            border_size = 0; # No border for launcher
          }
          {
            match.workspace = "name:dpp";
            idle_inhibit = "fullscreen"; # Inhibit while presenting
          }
          {
            match.workspace = "name:hdm";
            idle_inhibit = "fullscreen"; # Inhibit while presenting
          }
          {
            match.workspace = "name:int";
            idle_inhibit = "fullscreen"; # Inhibit while presenting
          }
        ];
        env = [
          {
            _args = [
              "NIXOS_OZONE_WL"
              "1" # Force Wayland support for some apps (Chromium)
            ];
          }
          {
            _args = [
              "GTK_IM_MODULE"
              "simple" # Simple GTK input method (use builtin deadkeys)
            ];
          }
        ]
        ++ lib.mapAttrsToList (var: val: {
          _args = [
            var
            (toString val)
          ];
        }) config.home.sessionVariables;
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

  services.hyprpolkitagent.enable = true;
}
