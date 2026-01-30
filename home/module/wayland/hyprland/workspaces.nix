{ lib, config, ... }:
let
  open = "${config.term.cmd} ${config.term.exec} ${config.home.sessionVariables.SHELL} -i -e br"; # TODO options for -i -e
  monitor = "${config.term.cmd} ${config.term.exec} btm --battery";
  note = "anki"; # Note-taking app
  # Worskpaces management (Key refers to workspace key): $mod (SUPER) + …
  # - Key (another WS focused): move focus to Key workspace (WS)
  #   - Key WS empty: launch default "empty" app for that WS
  # - Key (Key WS focused): launch alternative "already" app for that WS
  # - SHIFT + Key (another WS focused): move focused window to key WS
  # - SHIFT + Key (Key WS focused): cycle Key WS among monitors
in
rec {
  a = {
    name = "art"; # Artistic creation
    empty = "${config.launch.category} AudioVideo"; # Exec if focused + empty
    alreadyWinRules = "[float; center; size 888 420]"; # TODO Cleaner
    already = config.launch.mix; # Already focusing ws
    icon = ""; # TODO Use it in waybar identified by name
  };
  b = {
    name = "web"; # weB Browsing
    empty = config.browser.command; # Exec if workspace empty when focusing it
    already = config.browser.alt.command; # Exec if $mod+attrName + WS focused
    icon = "";
  };
  d = {
    name = "dpp"; # Displayport video output
    monitor = lib.mkDefault "DP-1"; # Monitor to which this workspace is tied
    icon = "󰍹";
  };
  e = {
    name = "etc"; # Et cetera (anything)
    # empty = config.launch.app; # Exec if focused + empty
    # already = config.launch.app; # If ws already focused + $mod+attrName
    icon = "";
  };
  h = {
    name = "hdm"; # Hdmi video output
    monitor = lib.mkDefault "DP-3"; # Monitor to which this workspace is tied
    icon = "󰍹";
  };
  i = {
    name = "int"; # Internal video output WARN Previously known as inf (monitoring)
    monitor = lib.mkDefault "eDP-1"; # Monitor to which this workspace is tied
    icon = "󰍹";
  };
  l = {
    name = "cli"; # command Line (terminaLs)
    empty = config.term.cmd; # Exec if focused + empty
    already = config.term.cmd; # Execute if already focusing workspace
    icon = "";
  };
  m = {
    name = "mon"; # system Monitoring WARN Previously known as msg (messaging)
    empty = monitor; # Exec if focused + empty
    icon = "󱕍";
  };
  n = {
    name = "not"; # Note taking and reviewing
    empty = note; # Exec if focused + empty
    icon = "";
  };
  o = {
    name = "opn"; # file Opening
    empty = open; # Exec if focused + empty
    already = open; # Execute if already focusing the workspace + $mod+attrName
    icon = "";
  };
  p = {
    name = "pim"; # Personal information management
    empty = config.organization.pim; # Exec if focused + empty
    icon = "";
  };
  XF86Mail = p;
  x = {
    name = "ext"; # eXtra (anything)
    icon = "";
  };
  # Still usable on right hand: ^ v z ç ’
  # Still usable on left hand: é è u ê à y .
}
