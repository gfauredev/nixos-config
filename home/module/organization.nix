{
  pkgs,
  pkgs-unstable,
  lib,
  config,
  ...
}: # Email, Calendar, Task, Contact, Note, Organization
{
  options.organization.pim = lib.mkOption {
    default = "proton-mail";
    description = "Main Personal Information Management app";
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
    # calcurse # TEST Me
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
    todoman.enable = true; # TODO Config
    himalaya.enable = true; # TODO Config
    khal.enable = false; # TODO Seems to need an explicit config file
    khard.enable = false; # TODO Config
    pimsync.enable = true; # TODO Config
    thunderbird.profiles.default.isDefault = true;
    thunderbird.package = pkgs.thunderbird-bin;
    khal.settings.default = {
      default_calendar = "perso-important";
      timedelta = "7d";
    };
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

  config.services.activitywatch.enable = true; # TEST me
  # config.services.conky.enable = true; # FIXME Display as wallpaper
}
