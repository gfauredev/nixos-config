# Search engines configs TODO use these engines definition as SST (Albert config…)
{
  alternativeto = {
    name = "AlternativeTo";
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
    definedAliases = [ "alt" ];
  };
  amazon = {
    name = "Amazon";
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
      "am"
      "amz"
    ];
  };
  archwiki = {
    name = "ArchLinux Wiki";
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
    definedAliases = [ "aw" ];
  };
  bluesky = {
    name = "Bluesky";
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
      "bs"
      "bsky"
    ];
  };
  cdiscount = {
    name = "CDiscount";
    urls = [
      {
        template = "https://www.cdiscount.com/search/10/{searchTerms}";
      }
    ];
    definedAliases = [ "cd" ];
  };
  chatgpt = {
    name = "ChatGPT";
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
    definedAliases = [ "gpt" ];
  };
  datasheetcatalog = {
    name = "DataSheetCatalog";
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
    definedAliases = [ "dsc" ];
  };
  deepl-en-fr = {
    name = "DeepL en->fr";
    urls = [
      {
        template = "https://www.deepl.com/translator#en/fr/{searchTerms}";
      }
    ];
    definedAliases = [ "en-fr" ];
  };
  deepl-fr-en = {
    name = "DeepL fr->en";
    urls = [
      {
        template = "https://www.deepl.com/translator#fr/en/{searchTerms}";
      }
    ];
    definedAliases = [ "fr-en" ];
  };
  deepl-fr-es = {
    name = "DeepL fr->es";
    urls = [
      {
        template = "https://www.deepl.com/translator#fr/es/{searchTerms}";
      }
    ];
    definedAliases = [ "fr-es" ];
  };
  deepseek = {
    name = "DeepSeek";
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
    definedAliases = [ "ds" ];
  };
  # ddg = {
  # name = "DuckDuckGo" # Built-in Firefox, only supports adding an alias
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
  #     "dd"
  #     "ddg"
  #   ];
  # };
  # ebay = {
  # name = "eBay" # Built-in Firefox, only supports adding an alias
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
  #   definedAliases = [ "eb" ];
  # };
  ecosia = {
    name = "Ecosia";
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
      "e"
      "eco"
    ];
  };
  f-droid = {
    name = "F-Droid";
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
    definedAliases = [ "fdroid" ];
  };
  github = {
    name = "GitHub";
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
      "gh"
      "git"
    ];
  };
  gitlab = {
    name = "GitLab";
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
    definedAliases = [ "gl" ];
  };
  google.metaData.alias = "g"; # Builtin, only supports adding an alias
  # google = {
  # name = "Google";
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
  #     "g"
  #     "ggl"
  #   ];
  # };
  googlemaps = {
    name = "Google Maps";
    urls = [
      {
        template = "https://www.google.com/maps/search/{searchTerms}/";
      }
    ];
    definedAliases = [
      "gm"
      "map"
      "maps"
    ];
  };
  googlescholar = {
    name = "Google Scholar";
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
    definedAliases = [ "gs" ];
  };
  googletranslate = {
    name = "Google Translate";
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
    definedAliases = [ "gt" ];
  };
  helixdocs = {
    name = "Helix Docs";
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
    definedAliases = [ "hx" ];
  };
  homemanagerissues = {
    name = "Home Manager Issues";
    urls = [
      {
        template = "https://github.com/nix-community/home-manager/issues";
        params = [
          {
            name = "q";
            value = "is:issue+is:open+{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ "hmissue" ];
  };
  leboncoin = {
    name = "LeBonCoin";
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
    definedAliases = [ "lbc" ];
  };
  mdn = {
    # name = "mdn";
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
    definedAliases = [ "mdn" ];
  };
  mistral = {
    name = "Mistral";
    urls = [
      {
        template = "https://chat.mistral.ai/chat";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [
      "mist"
      "chat"
    ];
  };
  mynixos = {
    name = "MyNixOS";
    urls = [
      {
        template = "https://mynixos.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [
      "nix"
      "mynix"
    ];
  };
  nixoptions = {
    name = "NixOS Options";
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
    definedAliases = [ "opt" ];
  };
  nixwiki = {
    name = "NixOS Wiki";
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
    definedAliases = [ "nw" ];
  };
  nixpkgsissues = {
    name = "Nixpkgs Issues";
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
    definedAliases = [ "nissue" ];
  };
  nixpackages = {
    name = "Nix Packages";
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
    definedAliases = [ "pkg" ];
  };
  nixversions = {
    name = "Nix Packages Versions";
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
    definedAliases = [ "pkgv" ];
  };
  nixprtracker = {
    name = "Nix PRs Tracker";
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
    definedAliases = [ "nixpr" ];
  };
  noogle = {
    name = "Noogle";
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
    definedAliases = [ "noo" ];
  };
  nostoday = {
    name = "Nos.Today";
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
    definedAliases = [ "nos" ];
  };
  nostrband = {
    name = "Nostr.Band";
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
    definedAliases = [ "nostr" ];
  };
  openstreetmaps = {
    name = "Open Street Maps";
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
    definedAliases = [ "m" ];
  };
  searchix = {
    name = "Searchix";
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
    definedAliases = [ "six" ];
  };
  typstdocs = {
    name = "Typst Docs";
    urls = [
      {
        template = "https://typst.app/docs/{searchTerms}";
      }
    ];
    definedAliases = [
      "typ"
      "typst"
    ];
  };
  wikipedia.metaData.alias = "w"; # Builtin, only supports adding alias
  # wikipedia = {
  # name = "Wikipedia (en)";
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
  #     "w"
  #     "we"
  #   ];
  # };
  wikipedia-fr = {
    name = "Wikipedia (fr)";
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
      "wf"
      "wiki"
    ];
  };
  wikigrapher = {
    name = "WikiGrapher";
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
      "wg"
    ];
  };
  wolframalpha = {
    name = "WolframAlpha";
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
      "wa"
      "alpha"
    ];
  };
  youtube = {
    name = "YouTube";
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
      "y"
      "yt"
    ];
  };
  bing.metaData.hidden = true; # Bing
  tabs.metaData.alias = "tb"; # Builtin, only supports adding alias
  bookmarks.metaData.alias = "bm"; # Builtin, only supports adding alias
  history.metaData.alias = "hist"; # Builtin, only supports adding alias
  actions.metaData.alias = "act"; # Builtin, only supports adding alias
}
