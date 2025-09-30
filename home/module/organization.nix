{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: # PIM, Notes
{
  options.organization.pim = lib.mkOption {
    default = "thunderbird";
    description = "Main Personal Information Management app";
  };
  config.home.packages = with pkgs; [
    # Flashcards
    anki # Best memorization tool
    # markdown-anki-decks
    # Notes
    pkgs-unstable.xournalpp # Handwriting notetaking
    # appflowy # Notion alternative
    # anytype # Knowledge base
    # logseq # Knowledge base
    # siyuan # Knowledge management # No p2p sync
    # silverbullet # Knowledge management # No p2p sync
    # affine # Knowledge base # No Android app
    # mindforger # Outliner note taking
    # emanote # Structured view text notes
    # rnote # Note tool
    # memos # Atomic memo hub
    # emacsPackages.org-roam-ui
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
    #   # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.anki.addons
    # };
    # See https://nix-community.github.io/home-manager/options.xhtml#opt-programs.thunderbird.profiles
    thunderbird.profiles.default = {
      isDefault = true;
      # search.engines = config.programs.firefox.profiles.default.search.engines;
    };
    khal.settings.default = {
      default_calendar = "perso";
      timedelta = "7d";
    };
  };
}
