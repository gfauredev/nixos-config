{
  config,
  lib,
  user,
  ...
}:
{
  # TODO move most of this in home/default.nix
  imports = [
    ../default.nix
    ../module/terminal # Terminal emulators
    ../module/editor # CLI and GUI text editors
    ../module/media # Media consuming and editing
  ];

  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "albert" # General launcher
        "discord" # Messaging
        "vital" # Synth
        "bespokesynth" # Synth
        "bespokesynth-with-vst2" # Synth
        "spotify" # Music
        "steam-unwrapped" # Videogames
        "steam" # Videogames
        "libsciter" # Used by rustdesk
        "ciscoPacketTracer8" # Network simulation
        "deconz" # Manage ZigBee/Matter networks
        "ventoy" # Multiboot USB
        "ventoy-1.1.05" # Multiboot USB
        "stm32cubemx" # STM32
      ];
    permittedInsecurePackages = [
      "ventoy-1.1.05" # Multiboot USB
    ];
  };

  home = {
    username = user.name;
    homeDirectory = user.home;
    sessionVariables = {
      # Maybe Nix modules and options are more appropriated
      XDG_DESKTOP_DIR = "${user.home}/data"; # FIXME not properly propagated to shell, wm…
      XDG_DOCUMENTS_DIR = "${user.home}/data";
      XDG_MUSIC_DIR = "${user.home}/data";
      XDG_PICTURES_DIR = "${user.home}/dcim";
      XDG_VIDEOS_DIR = "${user.home}/dcim";
      XDG_DOWNLOAD_DIR = "${user.home}/tmp";
      CONFIG_FLAKE = "~/.config/flake"; # System and home flake configs
      BAT_PAGING = "never";
      SHELL = "nu"; # TEST if better with full paths
      PAGER = "ov"; # TEST if better with full paths
      BROWSER = "firefox"; # TEST if better with full paths
      BROWSER_ALT = "brave"; # TEST if better with full paths
      # PASSWORD_STORE_DIR = "${config.home.sessionVariables.XDG_DATA_HOME}/password-store";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11"; # TODO update on clean install
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs =
    let
      name = user.description;
      email = "pro@gfaure.eu";
    in
    {
      git = {
        userName = name;
        userEmail = email;
      };
      jujutsu.settings.user = {
        name = name;
        email = email;
      };
    };

  xdg = {
    mimeApps = {
      defaultApplications =
        let # TODO should SSOT, maybe put in flake or modularize
          text = "Helix";
          image = "qimgv";
          audio = "mpv";
          video = "mpv";
          web = "firefox";
          pdf = "org.pwmt.zathura";
          explorer = "directory";
          document = "writer";
          spreadsheet = "calc";
        in
        {
          # Text & Code
          "text/plain" = "${text}.desktop";
          "text/markdown" = "${text}.desktop";
          "text/code" = "${text}.desktop";
          "inode/directory" = "${explorer}.desktop"; # Workspace
          # Document
          "application/vnd.oasis.opendocument.text" = "${document}.desktop";
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "${spreadsheet}.desktop";
          "application/vnd.ms-excel" = "${spreadsheet}.desktop";
          "application/pdf" = "${pdf}.desktop";
          # "application/x-colpkg" = "anki.desktop";
          # "application/x-apkg" = "anki.desktop";
          # "application/x-ankiaddon" = "anki.desktop";
          # "x-scheme-handler/appflowy-flutter" = "appflowy.desktop";
          # Image
          "image/avif" = "${image}.desktop";
          "image/webp" = "${image}.desktop";
          "image/png" = "${image}.desktop";
          "image/jpg" = "${image}.desktop";
          "image/jpeg" = "${image}.desktop";
          "image/bmp" = "${image}.desktop";
          "image/ico" = "${image}.desktop";
          "image/gif" = "${image}.desktop";
          # Audio
          "audio/flac" = "${audio}.desktop";
          "audio/ogg" = "${audio}.desktop";
          "audio/wav" = "${audio}.desktop";
          "audio/mp3" = "${audio}.desktop";
          # Video
          "video/mkv" = "${video}.desktop";
          "video/mp4" = "${video}.desktop";
          "video/avi" = "${video}.desktop";
          # Web
          "x-scheme-handler/https" = "${web}.desktop";
          "x-scheme-handler/http" = "${web}.desktop";
          # Email & Calendar
          "x-scheme-handler/mailto" = "${config.organization.pim}.desktop";
          "x-scheme-handler/webcal" = "${config.organization.pim}.desktop";
          "x-scheme-handler/webcals" = "${config.organization.pim}.desktop";
          "x-scheme-handler/mid" = "${config.organization.pim}.desktop";
          "x-scheme-handler/news" = "${config.organization.pim}.desktop";
          "x-scheme-handler/snews" = "${config.organization.pim}.desktop";
          "x-scheme-handler/nntp" = "${config.organization.pim}.desktop";
          "x-scheme-handler/feed" = "${config.organization.pim}.desktop";
          "application/rss+xml" = "${config.organization.pim}.desktop";
          "application/x-extension-rss" = "${config.organization.pim}.desktop";
          "application/x-extension-ics" = "${config.organization.pim}.desktop";
          "text/calender" = "${config.organization.pim}.desktop";
        };
    };
  };
}
