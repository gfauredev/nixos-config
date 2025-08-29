{ lib, config, ... }:
{
  programs.firefox = {
    enable = true; # Web browser
    languagePacks = [
      "en-GB"
      "fr"
      "en-US"
      "es-ES"
    ];
    # See https://mozilla.github.io/policy-templates
    policies = {
      BlockAboutConfig = false; # FIXME set to true when finished config
      DefaultDownloadDirectory = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "normal_installed";
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
          private_browsing = true;
        };
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "allow";
          private_browsing = true;
        };
      };
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
      containersForce = true; # WARN force overrides containers config
      search.force = true; # WARN override stateful config
      search.default = "ecosia";
      search.privateDefault = "ecosia";
      search.engines = {
        ecosia = {
          urls = [
            {
              template = "https://www.ecosia.org/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@eco" ];
        };
        nixpackages = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@pkg" ];
          # icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };
        nixoptions = {
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@opt" ];
        };
        nixwiki = {
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@nw" ];
          # iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
        };
        bing.metadata.hidden = true;
      };
      search.order = [
        "Bookmarks"
        "History"
        "Actions"
        "ecosia"
        "Wikipedia"
        # "YouTube" # TODO
        "nixpackages"
        "nixoptions"
        "nixwiki"
        # "Arch Wiki" # TODO
      ];
      settings = {
        "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks";
        "sidebar.notification.badge.aichat" = false;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        # Style settings from gwfox (Zen Browser like style)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true;
        "sidebar.animation.enabled" = false;
        # "browser.startup.homepage" = "";
        # "browser.search.region" = "GB";
        # "browser.search.isUS" = false;
        # "distribution.searchplugins.defaultLocale" = "en-GB";
        # "general.useragent.locale" = "en-GB";
        # "browser.bookmarks.showMobileBookmarks" = true;
      };
      userChrome = lib.readFile ./userChrome.css;
      userContent = lib.readFile ./userContent.css;
      # extensions = {
      #   force = true; # WARN overrides stateful settings
      #   packages = with pkgs.nur.repos.rycee.firefox-addons; [
      #     ublock-origin
      #     privacy-badger
      #   ];
      #   settings."uBlock0@raymondhill.net" = {
      #     settings = {
      #       selectedFilterLists = [
      #         "ublock-filters"
      #         "ublock-badware"
      #         "ublock-privacy"
      #         "ublock-unbreak"
      #         "ublock-quick-fixes"
      #       ];
      #     };
      #     # See https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json/permissions
      #     permissions = [ "activeTab" ];
      #   };
      # };
    };
  };
}
