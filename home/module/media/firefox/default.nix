{ lib, config, ... }:
{
  programs.firefox = {
    enable = true; # Web browser
    languagePacks = [
      "en-GB"
      "fr"
      "es-ES"
      "en-US"
    ];
    # See https://mozilla.github.io/policy-templates
    policies = {
      AutofillAddressEnabled = false; # Use password manager instead
      AutofillCreditCardEnabled = false; # Use password manager
      BlockAboutAddons = false; # FIXME set to true when configured
      BlockAboutConfig = false; # FIXME set to true when finished config
      BlockAboutProfiles = false; # FIXME set to true when configured
      BlockAboutSupport = false; # FIXME set to true when configured
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
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false; # Use password manager instead
      OverrideFirstRunPage = "";
      PasswordManagerEnabled = false; # Use extension instead
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
      containersForce = true; # WARN force overrides containers config
      search.force = true; # WARN override stateful config
      search.engines = {
        AlternativeTo = {
          urls = [
            {
              template = "https://alternativeto.net/browse/search/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@alt" ];
        };
        Amazon = {
          urls = [
            {
              template = "https://www.amazon.fr/s/";
              params = [
                {
                  name = "field-keywords";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@am"
            "@amz"
          ];
        };
        ArchWiki = {
          urls = [
            {
              template = "https://wiki.archlinux.org/index.php?title=Special:Search";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@aw" ];
        };
        Bluesky = {
          urls = [
            {
              template = "https://bsky.app/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@bs"
            "@bsky"
          ];
        };
        CDiscount = {
          urls = [
            {
              template = "https://www.cdiscount.com/search/10/{searchTerms}";
            }
          ];
          definedAliases = [ "@cd" ];
        };
        ChatGPT = {
          urls = [
            {
              template = "https://chat.openai.com/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@gpt" ];
        };
        DataSheetCatalog = {
          urls = [
            {
              template = "https://search.datasheetcatalog.net/key/";
              params = [
                {
                  name = "key";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@dsc" ];
        };
        DeepLEnFr = {
          urls = [
            {
              template = "https://www.deepl.com/translator#en/fr/{searchTerms}";
            }
          ];
          definedAliases = [ "@en-fr" ];
        };
        DeepLFrEn = {
          urls = [
            {
              template = "https://www.deepl.com/translator#fr/en/{searchTerms}";
            }
          ];
          definedAliases = [ "@fr-en" ];
        };
        DeepLFrEs = {
          urls = [
            {
              template = "https://www.deepl.com/translator#fr/es/{searchTerms}";
            }
          ];
          definedAliases = [ "@fr-es" ];
        };
        DeepSeek = {
          urls = [
            {
              template = "https://chat.deepseek.com/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@ds" ];
        };
        # DuckDuckGo, built-in Firefox, only supports adding an alias
        # ddg = {
        #   urls = [
        #     {
        #       template = "https://duckduckgo.com/";
        #       params = [
        #         {
        #           name = "q";
        #           value = "{searchTerms}";
        #         }
        #       ];
        #     }
        #   ];
        #   definedAliases = [
        #     "@dd"
        #     "@ddg"
        #   ];
        # };
        # eBay, built-in Firefox, only supports adding an alias
        # ebay = {
        #   urls = [
        #     {
        #       template = "https://www.ebay.fr/sch/i.html";
        #       params = [
        #         {
        #           name = "_nkw";
        #           value = "{searchTerms}";
        #         }
        #       ];
        #     }
        #   ];
        #   definedAliases = [ "@eb" ];
        # };
        # Ecosia
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
          definedAliases = [
            "@e"
            "@eco"
          ];
        };
        FDroid = {
          urls = [
            {
              template = "https://search.f-droid.org/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@fdroid" ];
        };
        GitHub = {
          urls = [
            {
              template = "https://github.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@gh"
            "@git"
          ];
        };
        GitLab = {
          urls = [
            {
              template = "https://gitlab.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@gl" ];
        };
        google.metaData.alias = "@g"; # Builtin, only supports adding an alias
        # google = {
        #   urls = [
        #     {
        #       template = "https://www.google.com/search";
        #       params = [
        #         {
        #           name = "q";
        #           value = "{searchTerms}";
        #         }
        #       ];
        #     }
        #   ];
        #   definedAliases = [
        #     "@g"
        #     "@ggl"
        #   ];
        # };
        GoogleMaps = {
          urls = [
            {
              template = "https://www.google.com/maps/search/{searchTerms}/";
            }
          ];
          definedAliases = [
            "@gm"
            "@map"
            "@maps"
          ];
        };
        GoogleScholar = {
          urls = [
            {
              template = "https://scholar.google.com/scholar";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@gs" ];
        };
        GoogleTranslate = {
          urls = [
            {
              template = "https://translate.google.com/";
              params = [
                {
                  name = "text";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@gt" ];
        };
        HelixDocs = {
          urls = [
            {
              template = "https://docs.helix-editor.com/";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@hx" ];
        };
        LeBonCoin = {
          urls = [
            {
              template = "https://www.leboncoin.fr/recherche";
              params = [
                {
                  name = "text";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@lbc" ];
        };
        mdn = {
          urls = [
            {
              template = "https://developer.mozilla.org/fr/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@mdn" ];
        };
        Mistral = {
          urls = [
            {
              template = "https://chat.mistral.ai/chat/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@mist"
            "@chat"
          ];
        };
        NixOptions = {
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
        NixWiki = {
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
        };
        NixpkgsIssues = {
          urls = [
            {
              template = "https://github.com/NixOS/nixpkgs/issues";
              params = [
                {
                  name = "q";
                  value = "is:issue+is:open+{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@nissue" ];
        };
        NixPackages = {
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
        };
        NixVersions = {
          urls = [
            {
              template = "https://lazamar.co.uk/nix-versions/";
              params = [
                {
                  name = "package";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@pkgv" ];
        };
        NixPrTracker = {
          urls = [
            {
              template = "https://nixpk.gs/pr-tracker.html";
              params = [
                {
                  name = "pr";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@nixpr" ];
        };
        Noogle = {
          urls = [
            {
              template = "https://noogle.dev/q";
              params = [
                {
                  name = "term";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@noo" ];
        };
        NosToday = {
          urls = [
            {
              template = "https://nos.today/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@nos" ];
        };
        NostrBand = {
          urls = [
            {
              template = "https://nostr.band/";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@nostr" ];
        };
        OpenStreetMaps = {
          urls = [
            {
              template = "https://www.openstreetmap.org/search";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@m" ];
        };
        Searchix = {
          urls = [
            {
              template = "https://searchix.alanpearce.eu/";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "@nix" ];
        };
        TypstDocs = {
          urls = [
            {
              template = "https://typst.app/docs/{searchTerms}";
            }
          ];
          definedAliases = [
            "@typ"
            "@typst"
          ];
        };
        wikipedia.metaData.alias = "@w"; # Builtin, only supports adding alias
        # WikipediaEn = {
        #   urls = [
        #     {
        #       template = "https://en.wikipedia.org/w/index.php";
        #       params = [
        #         {
        #           name = "search";
        #           value = "{searchTerms}";
        #         }
        #       ];
        #     }
        #   ];
        #   definedAliases = [
        #     "@w"
        #     "@we"
        #   ];
        # };
        WikipediaFr = {
          urls = [
            {
              template = "https://fr.wikipedia.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@wf"
            "@wiki"
          ];
        };
        WikiGrapher = {
          urls = [
            {
              template = "https://wikigrapher.com/paths";
              params = [
                {
                  name = "sourceTitle";
                  value = "{searchTerms}";
                }
                {
                  name = "targetTitle";
                  value = "{searchTerms}"; # TODO
                }
                {
                  name = "skip";
                  value = 0;
                }
                {
                  name = "limit";
                  value = 5;
                }
                {
                  name = "fetch";
                  value = true;
                }
              ];
            }
          ];
          definedAliases = [
            "@wg"
          ];
        };
        WolframAlpha = {
          urls = [
            {
              template = "https://www.wolframalpha.com/input/";
              params = [
                {
                  name = "i";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@wa"
            "@alpha"
          ];
        };
        YouTube = {
          urls = [
            {
              template = "https://www.youtube.com/results";
              params = [
                {
                  name = "search_query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "@y"
            "@yt"
          ];
        };
        bing.metadata.hidden = true; # Bing
      };
      search.default = "ecosia";
      search.privateDefault = "ecosia";
      search.order = [
        "Tabs" # Builtin
        "Bookmarks" # Builtin
        "History" # Builtin
        "Actions" # Builtin
        "wikipedia" # Wikipedia (en), builtin
        "WikipediaFr"
        "YouTube"
        "NixWiki"
        "ArchWiki"
        "ddg" # DuckDuckGo # Builtin
        "OpenStreetMaps"
        "NixPackages"
        "NixOptions"
      ];
      settings = {
        "browser.uiCustomization.navBarWhenVerticalTabs" = [
          "vertical-spacer"
          "back-button"
          "forward-button"
          "reload-button"
          "vertical-spacer"
          "urlbar-container"
          "ublock0_raymondhill_net-browser-action"
          "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
          "addon_darkreader_org-browser-action"
          "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
          "languagetool-webextension_languagetool_org-browser-action"
          "firefox-view-button"
        ];
        "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks";
        "sidebar.notification.badge.aichat" = false;
        "sidebar.revamp" = true;
        "sidebar.verticalTabs" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "widget.gtk.rounded-bottom-corners.enabled" = true; # TEST if useful
        "sidebar.animation.enabled" = false; # TEST if useful
        "browser.download.dir" = config.home.sessionVariables.XDG_DOWNLOAD_DIR;
        # "browser.download.useDownloadDir" = false; # TEST
        # "browser.policies.runOncePerModification.displayBookmarksToolbar" = "newtab";
        # "browser.startup.homepage" = "";
        # "browser.search.region" = "GB";
        # "browser.search.isUS" = false;
        # "distribution.searchplugins.defaultLocale" = "en-GB";
        # "general.useragent.locale" = "en-GB";
        # "browser.bookmarks.showMobileBookmarks" = true;
      };
      userChrome = lib.readFile ./userChrome.css; # TEST ArcWTF
      userContent = lib.readFile ./userContent.css; # TEST ArcWTF
    };
  };
}
