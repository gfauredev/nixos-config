{
  pkgs,
  lib,
  ...
}: # Email, Calendar, Task, Contact, Note
{
  options.organization.pim = lib.mkOption {
    default = "thunderbird";
    description = "Main Personal Information Management app";
  };
  config.home.packages = with pkgs; [
    anki # Best memorization tool
    # markdown-anki-decks
    # pkgs-unstable.xournalpp # Handwriting notetaking
    rnote # Modern handwriten note taking app
    # appflowy # Notion alternative
    # affine # Knowledge base # No Android app
    # logseq # Knowledge base
    # anytype # Knowledge base
    # siyuan # Knowledge management # No p2p sync
    # silverbullet # Knowledge management # No p2p sync
    # mindforger # Outliner note taking
    # emanote # Structured view text notes
    # rnote # Note tool
    # memos # Atomic memo hub
  ];
  config.programs = {
    thunderbird.enable = true;
    # anki.enable = true; # Best memorization TODO 25.11
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
    #   language = "fr_FR";
    # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.anki.addons
    # };
    thunderbird.profiles.default = {
      isDefault = true;
      # search.engines = config.programs.firefox.profiles.default.search.engines;
      # TODO LanguageTool extension; en-GB, fr-FR, en-US languages packs (in this order)
    };
    khal.settings.default = {
      default_calendar = "perso";
      timedelta = "7d";
    };
  };
}
