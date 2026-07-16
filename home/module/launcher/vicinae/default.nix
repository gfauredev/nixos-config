{ config, ... }: {
  programs.vicinae.enable = true;

  # programs.vicinae.enableFirefoxIntegration = true;

  # programs.vicinae.extensions = [
  #   (config.lib.vicinae.mkExtension {
  #     name = "test-extension";
  #     npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #     src =
  #       pkgs.fetchFromGitHub {
  #         owner = "schromp";
  #         repo = "vicinae-extensions";
  #         rev = "f8be5c89393a336f773d679d22faf82d59631991";
  #         sha256 = "sha256-zk7WIJ19ITzRFnqGSMtX35SgPGq0Z+M+f7hJRbyQugw=";
  #       }
  #       + "/test-extension";
  #   })
  #   (config.lib.vicinae.mkRayCastExtension {
  #     name = "gif-search";
  #     sha256 = "sha256-G7il8T1L+P/2mXWJsb68n4BCbVKcrrtK8GnBNxzt73Q=";
  #     rev = "4d417c2dfd86a5b2bea202d4a7b48d8eb3dbaeb1";
  #     npmDepsHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  #   })
  #   See https://docs.vicinae.com/extensions/introduction
  # ];

  programs.vicinae.settings = {
    close_on_focus_loss = true;
    search_files_in_root = true;
    font = {
      rendering = "qt";
      normal.size = 11;
    };
    launcher_window = {
      opacity = 0.8; # TEST
      client_side_decorations.enabled = false;
      compact_mode.enabled = true;
    };
    providers = {
      core = {
        entrypoints = {
          about.enabled = false;
          open-config-file.enabled = false;
          open-default-config.enabled = false;
          sponsor.enabled = false;
          store.enabled = false;
        };
      };
      files = {
        preferences = {
          autoIndexing = true;
          excludedIndexingPaths = [ ];
          indexingPaths = [
            "/home/gf/project"
            "/home/gf/life"
            "/home/gf/image"
          ];
        };
      };
      power = {
        entrypoints = {
          power-off.alias = "off";
          reboot.alias = "boot";
        };
      };
      raycast-compat = {
        entrypoints = {
          store.enabled = false;
        };
      };
    };
    # theme = {
    #   light.name = "stylix";
    #   dark.name = "stylix";
    # };
  };

  xdg.configFile = {
    "vicinae/settings.json.mutable" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/settings.json";
    };
  };

  programs.vicinae.systemd.enable = true;
  programs.vicinae.systemd.autoStart = true;

  # programs.vicinae.themes = { managed by stylix };
}
