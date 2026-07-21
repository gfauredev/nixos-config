{
  pkgs,
  config,
  lib,
  ...
}:
let
  searchEngines = import ../../web/search.nix;
  validEngines = lib.filterAttrs (n: v: v ? urls) searchEngines;

  getDomain =
    url:
    let
      m = builtins.match "^https?://([^/]+).*$" url;
    in
    if m != null then builtins.head m else "localhost";

  buildUrl =
    {
      template,
      params ? [ ],
    }:
    let
      queryString = builtins.concatStringsSep "&" (
        map (
          p: "${p.name}=${builtins.replaceStrings [ "{searchTerms}" ] [ "{argument}" ] (toString p.value)}"
        ) params
      );
    in
    if params == [ ] then
      builtins.replaceStrings [ "{searchTerms}" ] [ "{argument}" ] template
    else
      template + (if builtins.match ".*\\?.*" template != null then "&" else "?") + queryString;

  shortcutsList = lib.mapAttrsToList (id: engine: {
    id = "sct-${id}";
    name = engine.name or id;
    icon = "icon://favicon/${getDomain (builtins.head engine.urls).template}?fallback=icon://omnicast/image?fill%3Dprimary-text";
    url = buildUrl (builtins.head engine.urls);
    app = "firefox.desktop";
    # openCount = 0; createdAt = 0; updatedAt = 0; lastUsedAt = 0;
  }) validEngines;

  shortcutAliases = lib.mapAttrs' (
    id: engine:
    lib.nameValuePair "sct-${id}" {
      alias = (builtins.head engine.definedAliases) + " ";
    }
  ) validEngines;

in
{
  programs.vicinae.enable = true;

  # programs.vicinae.enableFirefoxIntegration = true; TODO

  programs.vicinae.extensions = with pkgs; [
    (
      (config.lib.vicinae.mkExtension {
        name = "bluetooth";
        npmDepsHash = lib.fakeHash;
        src =
          fetchFromGitHub {
            owner = "vicinaehq";
            repo = "extensions";
            rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
            hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
          }
          + "/extensions/bluetooth";
      }).overrideAttrs
      (oldAttrs: {
        preBuild = (oldAttrs.preBuild or "") + ''
          echo "Patching node_modules for missing debug dependency..."
          mkdir -p node_modules/debug
          echo 'module.exports = function() { return function() {}; };' > node_modules/debug/index.js
          echo '{"name": "debug", "version": "9.9.9", "main": "index.js"}' > node_modules/debug/package.json
        '';
      })
    )
    (config.lib.vicinae.mkExtension {
      name = "process-manager";
      npmDepsHash = pkgs.lib.fakeHash;
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/process-manager";
    })
    (config.lib.vicinae.mkExtension {
      name = "wifi-commander";
      npmDepsHash = pkgs.lib.fakeHash;
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/wifi-commander";
    })
    (config.lib.vicinae.mkExtension {
      name = "systemd";
      npmDepsHash = pkgs.lib.fakeHash;
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/systemd";
    })
    (config.lib.vicinae.mkExtension {
      name = "it-tools";
      npmDepsHash = pkgs.lib.fakeHash;
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/it-tools";
    })
    # (config.lib.vicinae.mkExtension {
    #   name = "firefox";
    #   npmDepsHash = "sha256-i2rOeiCSoS/dCQ746TCRQnpQ8BOndVkstWTs1rRmGEg=";
    #   src =
    #     fetchFromGitHub {
    #       owner = "vicinaehq";
    #       repo = "extensions";
    #       rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
    #       hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
    #     }
    #     + "/extensions/firefox";
    # })
    (config.lib.vicinae.mkExtension {
      name = "hypr-keybinds";
      npmDepsHash = "sha256-luKBk70eXXq/U4lk3FmlRNyOFHKo5Zqm3pjOdOk4ESc=";
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/hypr-keybinds";
    })
    (config.lib.vicinae.mkExtension {
      name = "nix";
      npmDepsHash = "sha256-TEyCCDjAtRYX2uH2TpLfe4/hTzyfMiyDhzVdyQXhEus=";
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/nix";
    })
    (config.lib.vicinae.mkExtension {
      name = "wikipedia";
      npmDepsHash = pkgs.lib.fakeHash;
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/wikipedia";
    })
    (config.lib.vicinae.mkExtension {
      name = "wiktionary";
      npmDepsHash = pkgs.lib.fakeHash;
      src =
        fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "ca74eede9a778a9373c8f5fd221b0a5026dcd1ef";
          hash = "sha256-fzPBEJZiRvc/FNMdpbdcfaZzF01U4IQenHW9IQFzhos=";
        }
        + "/extensions/wiktionary";
    })
  ];

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
      shortcuts.entrypoints = shortcutAliases;
      system.entrypoints.run.alias = "$";
    };
  };

  xdg.dataFile = {
    "vicinae/scripts".source =
      config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/scripts";
    "vicinae/shortcuts/shortcuts.jsonc".text = builtins.toJSON shortcutsList;
    "vicinae/shortcuts/shortcuts.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.sessionVariables.XDG_DATA_HOME}/vicinae/shortcuts/shortcuts.jsonc";
    "vicinae/snippets".source =
      config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/snippets";
  };

  xdg.configFile."vicinae/settings.mut.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/launcher/vicinae/settings.jsonc";

  programs.vicinae.systemd.enable = true;
  programs.vicinae.systemd.autoStart = true;
}
