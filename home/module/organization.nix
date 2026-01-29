{
  pkgs,
  lib,
  config,
  ...
}: # Email, Calendar, Task, Contact, Note, Organization
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
      mkdir --mode=700 --parents --verbose ~/project ~/life
      mkdir --mode=700 --parents --verbose ~/image/camera ~/image/screenshot
      mkdir --mode=700 --parents --verbose ~/archive/project ~/archive/life

      echo "Existence of Home folders (~/project, ~/life, …) ensured"
      echo
      echo "Subdirectories (mostly Projects and Life areas) naming convention :"
      echo "- camelCase noun representing the thing(s) to improve or increase,"
      echo "  or camelCase verb representing the action to do or get better at"
      echo "  - Eventually, several related ones separated by + (NO SPACES)"
      echo "- Eventual tag (or property) after the nouns, beginning with a ."
      echo "  - Eventually, several ones separated by . (NO SPACES)"
      echo "  - .git: It’s a Git repository, should not be synced otherwise"
      echo "  - .large: Should not be synced with lower capacity devices"
      echo "  - .local: Should not be synced at all, specific to this device"
      echo "  - .byIssuer: Subdirectories are nouns representing data sources"
      echo
      echo "Subdirectories (Projects, Life areas, …) organization conventions :"
      echo "- ~/life: Records of important areas needing continuous monitoring,"
      echo "          or data that might be recurrently needed, throughout life"
      echo "- ~/project: Data possibly required to progress towards an"
      echo "             ultimate goal or a precise, defined milestone"
      echo "- ~/archive: Definitively complete or discontinued projects,"
      echo "             or expired or no longer useful documents"
      echo "- If some data might go to several (sub)directories"
      echo "  - Put it in the most specific (often the less frequently used)"
      echo "  - Eventually symlink it to other relevant (sub)directories"
      echo
    '';
    # echo "- Graph: Linked and non-hierarchical data, typically managed through a dedicated app"
  };

  config.services.syncthing.settings.folders =
    let
      default = {
        type = "sendreceive";
        devices = [ "shiba" ];
        versioning = {
          type = "simple";
          params.keep = "4";
          params.cleanoutDays = "180";
        };
      };
    in
    {
      project = default // {
        path = "${config.user.home}/project";
      };
      life = default // {
        path = "${config.user.home}/life";
      };
      camera = default // {
        # Store picture when taken, synced with phone’s DCIM/Camera
        path = "${config.home.sessionVariables.XDG_PICTURES_DIR}/camera";
      };
      screenshots = default // {
        # Store screenshot when taken, synced with phone’s Pictures/Screenshots
        path = "${config.home.sessionVariables.XDG_PICTURES_DIR}/screenshot";
      };
      projectArchive = default // {
        path = "${config.user.home}/archive/project";
      };
      lifeArchive = default // {
        path = "${config.user.home}/archive/life";
      };
    };
}
