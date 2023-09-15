{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix # Shell config
  ];

  nixpkgs = {
    overlays = [
      # use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "gf";
    homeDirectory = "/home/gf";

    sessionVariables = lib.mkDefault {
      XDG_DESKTOP_DIR = "$HOME";
      XDG_DOCUMENTS_DIR = "$HOME/doc";
      XDG_DOWNLOAD_DIR = "$HOME/dl";
      XDG_MUSIC_DIR = "$HOME/audio";
      XDG_PICTURES_DIR = "$HOME/img";
      XDG_VIDEOS_DIR = "$HOME/vid";
      XDG_CONFIG_HOME = "$HOME/.config";

      # EDITOR = "nvim"; TODO: test pertinence
      # BROWSER = "brave";
      # VISUAL = "nvim";
      # TERMINAL = "wezterm";
      # TERM = "wezterm";

      # PNPM_HOME = "$HOME/.local/share/pnpm"; TODO: test pertinence
      # TYPST_FONT_PATHS = "$HOME/.nix-profile/share/fonts";
      # TYPST_ROOT = "$HOME/.local/share/typst";
    };
  };

  programs = {
    git = {
      userName = "Guilhem Fauré";
      userEmail = "pro@gfaure.eu";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
