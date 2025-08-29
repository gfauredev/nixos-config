{ pkgs, lib, ... }:
{
  programs.firefox = {
    enable = true; # Web browser
    languagePacks = [
      "en-GB"
      "fr"
      "en-US"
      "es-ES"
    ];
    # policies = { # TODO See https://mozilla.github.io/policy-templates
    #   BlockAboutConfig = true;
    #   DefaultDownloadDirectory = "\${home}/Downloads";
    #   ExtensionSettings = {
    #     "uBlock0@raymondhill.net" = {
    #       default_area = "menupanel";
    #       install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
    #       installation_mode = "force_installed";
    #       private_browsing = true;
    #     };
    #   };
    # };
    # TODO
    profiles.default = {
      id = 0;
      isDefault = true;
      # containers = {
      #   dangerous = {
      #     color = "red";
      #     icon = "fruit";
      #     id = 2;
      #   };
      #   shopping = {
      #     color = "blue";
      #     icon = "cart";
      #     id = 1;
      #   };
      # };
      # containersForce = true; # WARN force overrides containers config
      # TODO if better than with policies
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
      # TODO Bookmarks, History, Actions, Ecosia, Wikipedia, YouTube, ArchWiki
      # search.force = true; # WARN override stateful config
      # search.default = "ecosia";
      # search.privateDefault = "ecosia";
      # search.engines = {
      #   "Nix Packages" = {
      #     urls = [
      #       {
      #         template = "https://search.nixos.org/packages";
      #         params = [
      #           {
      #             name = "query";
      #             value = "{searchTerms}";
      #           }
      #         ];
      #       }
      #     ];
      #     icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #     definedAliases = [ "@pkg" ];
      #   };
      #   "Nix Options" = {
      #     urls = [
      #       {
      #         template = "https://search.nixos.org/options";
      #         params = [
      #           {
      #             name = "query";
      #             value = "{searchTerms}";
      #           }
      #         ];
      #       }
      #     ];
      #     definedAliases = [ "@opt" ];
      #     icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #   };
      #   "NixOS Wiki" = {
      #     urls = [
      #       { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }
      #     ];
      #     iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
      #     definedAliases = [ "@nw" ];
      #   };
      # };
      # search.order = [
      #   "bookmarks"
      #   "history"
      #   "actions"
      #   "ecosia"
      #   "wikipedia"
      #   "youtube"
      #   "Nix Packages"
      #   "Nix Options"
      #   "Nix Wiki"
      #   "Arch Wiki"
      # ];
      # TODO if useful
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
      userChrome = lib.readFile ./userChrome.css;
      userContent = lib.readFile ./userContent.css;
    };
  };
}
