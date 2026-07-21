# Additional search engines configs
{
  google = {
    name = "Google";
    urls = [
      {
        template = "https://www.google.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [
      "g"
      "ggl"
    ];
  };
  ddg = {
    name = "DuckDuckGo"; # Built-in Firefox, only supports adding an alias
    urls = [
      {
        template = "https://duckduckgo.com/";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [
      "dd"
      "ddg"
    ];
  };
  ebay = {
    name = "eBay"; # Built-in Firefox, only supports adding an alias
    urls = [
      {
        template = "https://www.ebay.fr/sch/i.html";
        params = [
          {
            name = "_nkw";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ "eb" ];
  };
  wikipedia = {
    name = "Wikipedia (en)";
    urls = [
      {
        template = "https://en.wikipedia.org/w/index.php";
        params = [
          {
            name = "search";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [
      "w"
      "we"
    ];
  };
}
