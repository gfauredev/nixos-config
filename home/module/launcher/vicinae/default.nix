{ config, ... }: {
  programs.vicinae.enable = true;

  # programs.vicinae.enableFirefoxIntegration = true; TODO

  # programs.vicinae.extensions = [ TODO
  #   (config.lib.vicinae.mkExtension {
  #     name = "bluetooth";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/bluetooth";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "process-manager";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/process-manager";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "wifi-commander";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/wifi-commander";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "systemd";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/systemd";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "it-tools";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/it-tools";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "firefox";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/firefox";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "hypr-keybinds";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/hypr-keybinds";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "nix";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/nix";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "wikipedia";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/wikipedia";
  #   })
  #   (config.lib.vicinae.mkExtension {
  #     name = "wiktionary";
  #     npmDepsHash = pkgs.lib.fakeHash;
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "vicinaehq";
  #         repo = "extensions";
  #         rev = "afb84fe4b5253777ff82db8e19e6cc0c9b7f811f";
  #         sha256 = pkgs.lib.fakeSha256;
  #       }
  #       + "/extensions/wiktionary";
  #   })
  # ];

  programs.vicinae.settings = {
    close_on_focus_loss = true;
    search_files_in_root = true;
    font.normal.size = 11;
    telemetry.system_info = true; # Ease the team’s work
    launcher_window = {
      client_side_decorations.enabled = true;
      compact_mode.enabled = true;
      # opacity = 0.8;
    };
    fallbacks = [
      "shortcuts:sct-ecosia"
      "files:search"
    ];
    providers = {
      calculator.entrypoints.history.alias = "=";
      core.entrypoints = {
        about.enabled = false;
        open-config-file.enabled = false;
        open-default-config.enabled = false;
        search-emojis.alias = ":";
        store.enabled = false;
      };
      files.preferences = {
        autoIndexing = true;
        indexingPaths = [
          "/home/gf/project"
          "/home/gf/life"
          "/home/gf/image"
        ];
        # excludedIndexingPaths = [ ];
      };
      power.entrypoints = {
        power-off.alias = "off";
        reboot.alias = "boot";
      };
      raycast-compat.entrypoints.store.enabled = false;
      system.entrypoints.run.alias = "$";
    };
  };

  xdg.dataFile = {
    "vicinae/scripts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/scripts";
    };
    "vicinae/shortcuts" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/shortcuts";
    };
    "vicinae/snippets" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/snippets";
    };
  };

  xdg.configFile = {
    "vicinae/settings.mut.jsonc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/settings.jsonc";
    };
  };

  programs.vicinae.systemd.enable = true;
  programs.vicinae.systemd.autoStart = true;
}
