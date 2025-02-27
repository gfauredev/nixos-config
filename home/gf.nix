{ lib, ... }: {
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
      "libsciter" # Used by rustdesk
    ];

  home = {
    username = "gf"; # TEST home-manager.users.<name> config structure
    homeDirectory = "/home/gf";

    sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME/data";
      XDG_DOCUMENTS_DIR = "$HOME/data";
      XDG_MUSIC_DIR = "$HOME/data";
      XDG_PICTURES_DIR = "$HOME/dcim";
      XDG_VIDEOS_DIR = "$HOME/dcim";
      XDG_DOWNLOAD_DIR = "$HOME/tmp";
      BROWSER = "brave"; # TODO this directly in Nix
      PAGER = "ov";
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
          pim = "thunderbird";
          pdf = "org.pwmt.zathura";
          explorer = "directory";
          document = "writer";
          spreadsheet = "calc";
          # term = "org.wezfurlong.wezterm";
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
          "x-scheme-handler/mailto" = "${pim}.desktop";
          "x-scheme-handler/webcal" = "${pim}.desktop";
          "x-scheme-handler/webcals" = "${pim}.desktop";
          "x-scheme-handler/mid" = "${pim}.desktop";
          "x-scheme-handler/news" = "${pim}.desktop";
          "x-scheme-handler/snews" = "${pim}.desktop";
          "x-scheme-handler/nntp" = "${pim}.desktop";
          "x-scheme-handler/feed" = "${pim}.desktop";
          "application/rss+xml" = "${pim}.desktop";
          "application/x-extension-rss" = "${pim}.desktop";
          "application/x-extension-ics" = "${pim}.desktop";
          "text/calender" = "${pim}.desktop";
        };
    };
  };
}
