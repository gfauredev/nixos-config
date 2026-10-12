{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  options.browser =
    with lib;
    let
      str = types.str;
    in
    {
      command = mkOption {
        type = str;
        default = "firefox"; # TODO Consider full path
        description = "Main web browser command";
      };
      desktop = mkOption {
        type = str;
        default = "firefox";
        description = "Main web browser desktop entry (without .desktop)";
      };
      alt = {
        command = mkOption {
          type = str;
          default = "chromium";
          description = "Alternative web browser command";
        };
        desktop = mkOption {
          type = str;
          default = "chromium";
          description = "Alternative web browser desktop entry (without .desktop)";
        };
      };
    };

  config.programs = {
    firefox.enable = true; # Gecko web browser
    firefoxpwa.enable = true; # Gecko web browser PWA support
    chromium.enable = true; # Blink web browser
    # chromium.package = pkgs.brave; # Better privacy and security than Chromium
    chromium.package = pkgs.ungoogled-chromium; # Extremely standard
    firefox = {
      package = pkgs-unstable.firefox.override {
        nativeMessagingHosts = [ pkgs-unstable.firefoxpwa ];
      };
      configPath = "${config.xdg.configHome}/mozilla/firefox"; # Hardcoded in FF
      languagePacks = [
        "en-GB"
        "fr"
        "es-ES"
        "en-US"
      ]; # See https://mozilla.github.io/policy-templates
      policies = {
        AutofillAddressEnabled = false; # Use password manager extension instead
        AutofillCreditCardEnabled = false; # Use password manager extension instead
        BlockAboutAddons = false; # May be set to true when configured
        BlockAboutConfig = false; # May be set to true when finished config
        BlockAboutProfiles = false; # May be set to true when configured
        BlockAboutSupport = false; # May be set to true when configured
        DefaultDownloadDirectory = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
        DownloadDirectory = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
        DisplayBookmarksToolbar = false;
        DisplayMenuBar = false;
        DontCheckDefaultBrowser = true;
        ExtensionSettings = {
          "adnauseam@rednoise.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "allow";
            private_browsing = true;
          };
          "firefoxpwa@filips.si" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/firefoxpwa/latest.xpi"; # FIXME
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "languagetool-webextension@languagetool.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = false;
          };
          "firefox@vicinae.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vicinae/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "faststream@andrews" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/faststream/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "ATBC@EasonWong" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adaptive-tab-bar-colour/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          # "DeepL" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/…/latest.xpi";
          #   installation_mode = "force_installed";
          #   private_browsing = true;
          # };
          # "Buster" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/…/latest.xpi";
          #   installation_mode = "force_installed";
          #   private_browsing = true;
          # };
          # "{26ef8318-6349-483c-affa-6c6db6d30517}" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/automa/latest.xpi";
          #   installation_mode = "allow";
          #   private_browsing = true;
          # };
          # "jid1-MnnxcxisBPnSXQ@jetpack" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          #   installation_mode = "allow";
          #   private_browsing = true;
          # };
          # "{74145f27-f039-47ce-a470-a662b129930a}" = {
          #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          #   installation_mode = "allow";
          #   private_browsing = false;
          # };
        };
        ImportEnterpriseRoots = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false; # Use password manager extension instead
        OverrideFirstRunPage = "";
        PasswordManagerEnabled = false; # Use password manager extension instead
        ShowHomeButton = false;
        SkipTermsOfUse = true;
        Preferences = {
          "browser.download.folderList" = 2;
          "browser.download.useDownloadDir" = true;
          # "browser.download.dir" = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
          # "browser.download.lastDir" = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "always-show";
          "sidebar.expandOnHover" = false; # Buggy
          "sidebar.notification.badge.aichat" = false;
          "sidebar.main.expanded" = true;
          "sidebar.animation.enabled" = false; # Too slow
        };
      };
      profiles.${config.user.name} = {
        id = 0;
        isDefault = true;
        containers = {
          perso = {
            id = 1;
            color = "blue";
            icon = "chill";
          };
          tech = {
            id = 2;
            color = "purple";
            icon = "briefcase";
          };
          music = {
            id = 3;
            color = "yellow";
            icon = "circle";
          };
          bank = {
            color = "green";
            icon = "dollar";
            id = 4;
          };
          shop = {
            color = "pink";
            icon = "cart";
            id = 5;
          };
        };
        containersForce = true; # Forces overrides containers config
        search.force = true; # Forces overrides containers config
        search.engines = import ../web/search.nix;
        search.default = "ecosia"; # Ecosia
        search.privateDefault = "ddg"; # DuckDuckGo
        search.order = [
          "Tabs" # Builtin
          "Bookmarks" # Builtin
          "History" # Builtin
          "Actions" # Builtin
          "wikipedia" # Wikipedia (en), builtin
          "wikipedia-fr"
          "youtube"
          "nixwiki"
          "archwiki"
          "ddg" # DuckDuckGo # Builtin
          "openstreetmaps"
          "nixpackages"
          "nixoptions"
        ];
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Allow custom styles
          "browser.translations.neverTranslateLanguages" = "en,fr,es";
          "services.sync.declinedEngines" = "passwords,addresses,creditcards";
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };
      };
    };
    firefoxpwa = {
      package = pkgs-unstable.firefoxpwa; # Gecko web browser PWA support
      profiles."01M4QHM8WQW6C4KWDN83WMP28Z" = {
        name = "default";
        sites = {
          "01M4QHP62X5MXXWEKYT2PPJGCD" = {
            name = "MDN Web Docs";
            url = "https://developer.mozilla.org/";
            manifestUrl = "https://developer.mozilla.org/manifest.f42880861b394dd4dc9b.json";
            desktopEntry.icon = pkgs.fetchurl {
              url = "https://developer.mozilla.org/favicon-192x192.png";
              sha256 = "0p8zgf2ba48l2pq1gjcffwzmd9kfmj9qc0v7zpwf2qd54fndifxr";
            };
          };
          "01M4QJ0V92SFM4X262C675WSTA" = {
            name = "Proton Mail";
            url = "https://mail.proton.me";
            manifestUrl = null;
            desktopEntry = {
              enable = true;
              categories = [ "Email" ];
              icon = pkgs.fetchurl {
                url = "https://mail.proton.me/assets/favicon.ico";
                sha256 = "1dv73irmxzhmhk8x9b7xq82y866csa5zpzapn2ahmdjg4qcrg2m8";
              };
            };
          };
          "01M4QJ8D5RXXQDCBP0QACJ6ZG0" = {
            name = "Framagenda";
            url = "https://framagenda.org";
            manifestUrl = null;
            desktopEntry = {
              enable = true;
              categories = [ "Calendar" ];
              icon = pkgs.fetchurl {
                url = "https://framagenda.org/apps/theming/favicon/calendar?v=ce284119";
                sha256 = "1n4pn2wzhrg2gg9mj20mg6sws2kyzks4gbq8v5k2a8y6dhh1jnsf";
              };
            };
          };
        };
      };
    };

  };
  # config.home.file."${config.programs.firefox.configPath}/${config.user.name}/chrome/userChrome.css".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/web/firefoxUserChrome.css";

  config.home.sessionVariables.BROWSER = config.browser.command; # Set default web browser
}
