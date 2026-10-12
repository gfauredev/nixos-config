{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: # Email, Calendar, Task, Contact, Note, Organization
{
  options.organization = {
    email = {
      entry = lib.mkOption {
        default = "proton-framagenda";
        description = "Email (progressive web) app";
      };
      cmd = lib.mkOption {
        default = config.xdg.desktopEntries.proton-framagenda.exec;
        description = "Email (progressive web) app";
      };
    };
    calendar = {
      entry = lib.mkOption {
        default = "proton-framagenda";
        description = "Calendar (progressive web) app";
      };
      cmd = lib.mkOption {
        default = config.xdg.desktopEntries.proton-framagenda.exec;
        description = "Calendar (progressive web) app";
      };
    };
  };

  config.home.packages = with pkgs-unstable; [
    # (actual-client.overrideAttrs (old: {
    #   postInstall = (old.postInstall or "") + ''
    #     wrapProgram $out/bin/actual --prefix LD_LIBRARY_PATH : "${
    #       lib.makeLibraryPath [ pkgs-unstable.stdenv.cc.cc.lib ]
    #     }"
    #   '';
    # })) # Finance management BUG cannot import self-signed certificate
    # anki # Best memorization tool
    # protonmail-desktop # Electron app worse than web app, no extensions
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
    todoman.enable = true; # TODO Config
    himalaya.enable = true;
    khal.enable = false; # TODO Seems to need an explicit config file
    khard.enable = false; # TODO Config
    pimsync.enable = true; # TODO Config
    thunderbird.profiles.default.isDefault = true;
    thunderbird.package = pkgs.thunderbird-bin;
    khal.settings.default = {
      default_calendar = "perso-important";
      timedelta = "7d";
    };
    himalaya.settings = { }; # FIX HM Complaints
  };

  config.xdg.desktopEntries.proton-framagenda =
    let
      launchWebApps = pkgs.writeShellScript "launch-proton-framagenda" ''
        ${pkgs.firefox}/bin/firefox --new-window "https://mail.proton.me"
        ${pkgs.firefox}/bin/firefox -new-tab "https://framagenda.org"
      '';
    in
    {
      name = "Proton Mail & Framagenda";
      genericName = "Mail & Calendar";
      comment = "Open Proton Mail and Framagenda in a dedicated Firefox window";
      icon = "firefox";
      terminal = false;
      categories = [
        "Network"
        "Email"
        "Office"
        "Calendar"
      ];
      exec = "${launchWebApps}";
    };

  config.home.activation = {
    # lib.hm.dag.entryAfter ensures it runs after necessary setup steps
    home-folders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir --mode=700 --parents --verbose ~/author ~/collect ~/shelve
      echo "Existence of ~/author ~/collect ~/shelve ensured"
      mkdir --mode=700 --parents --verbose ~/image/camera ~/image/screenshot
      echo "Existence of ~/image/camera ~/image/screenshot ensured"
      ${pkgs.bat}/bin/bat ${config.location}/public/home/module/orga.md
    '';
  };
  # TODO Put some Syncthing config here publicly

  config.services.activitywatch.enable = false; # To configure
  config.services.etesync-dav.enable = false; # E2E PIM sync
}
