{ inputs, lib, config, pkgs, ... }: {
  i18n = {
    # Locales internatinalization properties
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "fr_FR.UTF-8/UTF-8"
    ];
    defaultLocale = "en_US.UTF-8"; # Set localization settings
    extraLocaleSettings = {
      LC_NUMERIC = "fr_FR.UTF-8";
      LC_TIME = "fr_FR.UTF-8";
      LC_MONETARY = "fr_FR.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_PAPER = "fr_FR.UTF-8";
      LC_NAME = "fr_FR.UTF-8";
      LC_ADDRESS = "fr_FR.UTF-8";
      LC_TELEPHONE = "fr_FR.UTF-8";
      LC_MEASUREMENTS = "fr_FR.UTF-8";
      LC_IDENTIFICATION = "fr_FR.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_COLLATE = "C";
    };
  };

  services = {
    pipewire = {
      enable = true; # Enable modern audio system PipeWire
      alsa.enable = true; # Enable support for old audio system
      jack.enable = true; # Enable support for old audio system
      pulse.enable = true; # Enable support for old audio system
    };
    udisks2 = {
      enable = true;
      settings = { };
    };
    udev.packages = [
      pkgs.android-udev-rules
    ];
  };

  programs = {
    # zsh.enable = true; TODO: test pertinence with hm
    gnupg = {
      agent.enable = true;
      agent.pinentryFlavor = "curses";
    };
    # firejail = { # TODO: test pertinence
    #   enable = true;
    #   wrappedBinaries = { };
    # };
    adb.enable = true; # Talk to Android devices
    ssh.startAgent = true;
  };
}
