{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: # Email, Calendar, Task, Contact, Note, Organization
{
  options.organization.pim = lib.mkOption {
    default = "thunderbird";
    description = "Main Personal Information Management app";
  };

  config.home.packages = with pkgs-unstable; [
    actual-client # Finance management
    # anki # Best memorization tool
    # markdown-anki-decks
    protonmail-desktop
    xournalpp # Handwriting notetaking
    rnote # Modern handwriten note taking app
    # affine # Knowledge base # No Android app
    # anytype # Knowledge base
    # siyuan # Knowledge management # No p2p sync
    # silverbullet # Knowledge management # No p2p sync
    # mindforger # Outliner note taking
    # emanote # Structured view text notes
    # memos # Atomic memo hub
  ];

  config.programs = {
    thunderbird.enable = true;
    anki.enable = true; # Best memorization
    himalaya.enable = true;
    khal.enable = false; # Seems to need an explicit config file
    khard.enable = false; # too
    # anki = {
    #   addons = with pkgs.ankiAddons; [ anki-connect ];
    #   answerKeys = [
    #     {
    #       ease = 1;
    #       key = "left";
    #     }
    #     {
    #       ease = 2;
    #       key = "up";
    #     }
    #     {
    #       ease = 3;
    #       key = "right";
    #     }
    #     {
    #       ease = 4;
    #       key = "down";
    #     }
    #   ];
    #   spacebarRatesCard = true;
    #   language = "fr_FR"; https://nix-community.github.io/home-manager/options.xhtml#opt-programs.anki.addons
    # };
    thunderbird.profiles.default = {
      isDefault = true;
      # search.engines = config.programs.firefox.profiles.default.search.engines;
      # TODO LanguageTool extension; en-GB, fr-FR, en-US languages packs (in this order)
    };
    thunderbird.package = pkgs.thunderbird-bin;
    khal.settings.default = {
      default_calendar = "perso";
      timedelta = "7d";
    };
  };

  config.home.activation = {
    # lib.hm.dag.entryAfter ensures it runs after necessary setup steps
    home-folders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir --mode=700 --parents --verbose ~/author ~/collect ~/shelve
      mkdir --mode=700 --parents --verbose ~/image/camera ~/image/screenshot
      ${pkgs.bat}/bin/bat ${config.location}/public/home/module/orga.md
    '';
  };
  # TODO Put some Syncthing config here publicly

  config.services.activitywatch.enable = true; # TEST me
  # config.services.conky.enable = true; # FIXME Display as wallpaper
}
