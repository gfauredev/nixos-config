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
      entry = mkOption {
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
        entry = mkOption {
          type = str;
          default = "chromium";
          description = "Alternative web browser desktop entry (without .desktop)";
        };
      };
    };

  config.programs = {
    firefox.enable = true; # Gecko web browser
    chromium.enable = true; # Blink web browser
    firefoxpwa.enable = false; # Gecko web browser PWA support
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
          "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "adnauseam@rednoise.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adnauseam/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "languagetool-webextension@languagetool.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = false;
          };
          "firefox@vicinae.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/vicinae/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "simple-translate@sienori" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-translate/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "{e58d3966-3d76-4cd9-8552-1582fbc800c1}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/buster-captcha-solver/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "faststream@andrews" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/faststream/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "firefoxpwa@filips.si" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/pwas-for-firefox/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "{5384767E-00D9-40E9-B72F-9CC39D655D6F}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/epubreader/latest.xpi";
            installation_mode = "normal_installed";
            private_browsing = true;
          };
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "allow";
            private_browsing = true;
          };
          "firefox-extension@deepl.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/deepl-translate/latest.xpi";
            installation_mode = "allow";
            private_browsing = true;
          };
          "{26ef8318-6349-483c-affa-6c6db6d30517}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/automa/latest.xpi";
            installation_mode = "allow";
            private_browsing = true;
          };
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "allow";
            private_browsing = true;
          };
          "ATBC@EasonWong" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adaptive-tab-bar-colour/latest.xpi";
            installation_mode = "allow";
            private_browsing = true;
          };
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
      profiles."00000000000000000000000001" = {
        name = "default";
        sites = {
          "0000000000PR0T0NMA11000000" = {
            name = "Proton Mail";
            url = "https://mail.proton.me";
            manifestUrl = "https://mail.proton.me/assets/manifest.webmanifest";
            desktopEntry = {
              enable = true;
              categories = [ "Email" ];
              icon = pkgs.fetchurl {
                url = "https://mail.proton.me/assets/favicon.ico";
                sha256 = "1dv73irmxzhmhk8x9b7xq82y866csa5zpzapn2ahmdjg4qcrg2m8";
              };
            };
          };
          "0000000000FRAMAGENDA000000" = {
            name = "Framagenda";
            url = "https://framagenda.org";
            manifestUrl = "https://framagenda.org/apps/theming/manifest/calendar?v=ce284119";
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
