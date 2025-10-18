{
  pkgs,
  config,
  ...
}:
{
  programs = {
    firefox.enable = true; # Gecko web browser
    chromium.enable = true; # Blink web browser
    chromium.package = pkgs.brave; # Better privacy and security than Chromium
    firefox = {
      languagePacks = [
        "en-GB"
        "fr"
        "es-ES"
        "en-US"
      ];
      # See https://mozilla.github.io/policy-templates
      policies = {
        AutofillAddressEnabled = false; # Use password manager extension instead
        AutofillCreditCardEnabled = false; # Use password manager extension instead
        BlockAboutAddons = false; # May be set to true when configured
        BlockAboutConfig = false; # May be set to true when finished config
        BlockAboutProfiles = false; # May be set to true when configured
        BlockAboutSupport = false; # May be set to true when configured
        DefaultDownloadDirectory = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
        DisplayBookmarksToolbar = false;
        DisplayMenuBar = false;
        DontCheckDefaultBrowser = true;
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
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
          "{c8f79b34-c3ff-4ce4-bdf4-eefa15c87f98}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/deepl/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "faststream@andrews" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/faststream/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "{ec800ab3-79f6-474a-80e5-117b5d57c8e2}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/buster/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "ATBC@EasonWong" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/adaptive-tab-bar-colour/latest.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
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
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false; # Use password manager extension instead
        OverrideFirstRunPage = "";
        PasswordManagerEnabled = false; # Use password manager extension instead
        ShowHomeButton = false;
        SkipTermsOfUse = true;
      };
      profiles.default = {
        id = 0;
        isDefault = true;
        containers = {
          perso = {
            id = 0;
            color = "blue";
            icon = "chill";
          };
          tech = {
            id = 1;
            color = "purple";
            icon = "briefcase";
          };
          music = {
            id = 2;
            color = "yellow";
            icon = "circle";
          };
          bank = {
            color = "green";
            icon = "dollar";
            id = 3;
          };
          shop = {
            color = "pink";
            icon = "cart";
            id = 4;
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
          # "browser.download.dir" = config.home.sessionVariables.XDG_DOWNLOAD_DIR; # Redundant ?
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
          "sidebar.notification.badge.aichat" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = false;
          "browser.uiCustomization.navBarWhenVerticalTabs" = [
            "urlbar-container"
            "ublock0_raymondhill_net-browser-action" # uBlock Origin
            "addon_darkreader_org-browser-action" # Dark Reader
            "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action" # Proton Pass
          ];
          # "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks"; # To configure
          # "svg.context-properties.content.enabled" = true;
          # "browser.download.useDownloadDir" = false;
          # "widget.gtk.rounded-bottom-corners.enabled" = true;
          # "sidebar.animation.enabled" = false;
          # "browser.policies.runOncePerModification.displayBookmarksToolbar" = "newtab";
          # "browser.startup.homepage" = "";
          # "browser.search.region" = "GB";
          # "browser.search.isUS" = false;
          # "distribution.searchplugins.defaultLocale" = "en-GB";
          # "general.useragent.locale" = "en-GB";
          # "browser.bookmarks.showMobileBookmarks" = true;
        };
        # userChrome = lib.readFile ./firefox/chrome.css;
        # userContent = lib.readFile ./firefox/content.css;
      };
    };
  };
}
