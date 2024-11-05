{ ... }: {
  imports = [ ./default.nix ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Fixes https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gf";
    homeDirectory = "/home/gf";

    sessionVariables = {
      XDG_DESKTOP_DIR = "$HOME/data";
      XDG_DOCUMENTS_DIR = "$HOME/data/document";
      XDG_DOWNLOAD_DIR = "$HOME/data.local/tmp";
      XDG_MUSIC_DIR = "$HOME/data/audio";
      XDG_PICTURES_DIR = "$HOME/data/image";
      XDG_VIDEOS_DIR = "$HOME/data/video";

      BROWSER = "brave"; # TODO this directly in Nix
      # PAGER = "nvim -R"; # Use terminal editor as pager
      # MANPAGER = "nvim +Man!"; # Use terminal editor as pager

      TYPST_FONT_PATHS =
        "$HOME/.nix-profile/share/fonts"; # Allow Typst to find fonts

      # WARNING setup secret storage like sops for this TODO
      COPILOT_API_KEY = "hey";
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
          # term = "org.wezfurlong.wezterm";
        in {
          # Text & Code
          "text/plain" = "${text}.desktop";
          "text/markdown" = "${text}.desktop";
          "text/code" = "${text}.desktop";
          "inode/directory" = "${explorer}.desktop"; # Workspace
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
          # Application specific
          "application/pdf" = "${pdf}.desktop";
          # "application/x-colpkg" = "anki.desktop";
          # "application/x-apkg" = "anki.desktop";
          # "application/x-ankiaddon" = "anki.desktop";
          # "x-scheme-handler/appflowy-flutter" = "appflowy.desktop";
        };
    };
  };
}
