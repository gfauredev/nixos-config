{ config, lib, ... }: {
  # TODO move most of this in home/default.nix, this file should no be needed
  # TODO common user config for system/ and home/ in the flake.nix,
  #      infer homeConfigurations of the form `user@machine` based on it
  imports = [ ./default.nix ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "albert"
      "discord"
      "vital"
      "bespokesynth"
      "bespokesynth-with-vst2"
      "spotify"
      "steam-unwrapped"
      "steam"
      "libsciter" # Used by rustdesk
    ];

  home = {
    username = "gf"; # TEST home-manager.users.<name> config structure
    homeDirectory = "/home/gf";
    sessionVariables = { # Maybe Nix modules and options are more appropriated
      XDG_DESKTOP_DIR = "$HOME/data";
      XDG_DOCUMENTS_DIR = "$HOME/data";
      XDG_MUSIC_DIR = "$HOME/data";
      XDG_PICTURES_DIR = "$HOME/dcim";
      XDG_VIDEOS_DIR = "$HOME/dcim";
      XDG_DOWNLOAD_DIR = "$HOME/tmp";
      CONFIG_FLAKE = "~/.config/flake"; # System and home flake configs
      SHELL = "nu"; # TEST if better with full paths
      PAGER = "ov"; # TEST if better with full paths
      BROWSER = "brave"; # TEST if better with full paths
      BROWSER_ALT = "firefox"; # TEST if better with full paths
      PASSWORD_STORE_DIR =
        "${config.home.sessionVariables.XDG_DATA_HOME}/password-store";
    };
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.11";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs = {
    git = {
      userName = "Guilhem Fauré";
      userEmail = "pro@gfaure.eu";
    };
  };

  xdg = {
    mimeApps = {
      defaultApplications =
        let # TODO should SSOT, maybe put in flake or modularize
          text = "Helix";
          image = "imv";
          audio = "mpv";
          video = "mpv";
          web = "brave-browser";
          pdf = "org.pwmt.zathura";
          explorer = "directory";
          document = "writer";
          spreadsheet = "calc";
        in {
          # Text & Code
          "text/plain" = "${text}.desktop";
          "text/markdown" = "${text}.desktop";
          "text/code" = "${text}.desktop";
          "inode/directory" = "${explorer}.desktop"; # Workspace
          # Document
          "application/vnd.oasis.opendocument.text" = "${document}.desktop";
          "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =
            "${spreadsheet}.desktop";
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
