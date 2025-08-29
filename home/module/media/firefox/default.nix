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
      BlockAboutConfig = true;
      DefaultDownloadDirectory = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
      ExtensionSettings = {
        uBlockOrigin = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        protonPass = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        darkReader = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        languageTool = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        clearUrls = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "normal_installed";
          private_browsing = true;
        };
        privacyBadger = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "normal_installed";
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
      userChrome = lib.readFile ./userChrome.css;
      userContent = lib.readFile ./userContent.css;
      # TEST if better than with policies
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
      # TEST if useful
      # settings = {
      #   "browser.startup.homepage" = "";
      #   "browser.search.region" = "GB";
      #   "browser.search.isUS" = false;
      #   "distribution.searchplugins.defaultLocale" = "en-GB";
      #   "general.useragent.locale" = "en-GB";
      #   "browser.bookmarks.showMobileBookmarks" = true;
      #   "browser.newtabpage.pinned" = [
      #     {
      #       title = "NixOS";
      #       url = "https://nixos.org";
      #     }
      #   ];
      # };
    };
  };
}
