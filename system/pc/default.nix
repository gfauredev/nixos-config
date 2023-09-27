{ inputs, lib, config, pkgs, ... }: {
  # TODO place as much as possible in home configs

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

  systemd.services.unmount-boot = {
    description = "Unmount /boot at boot as useless once booted";
    script = "umount /boot";
    wantedBy = [ "multi-user.target" ];
  };

  services = {
    # TODO this may belong to home config
    fwupd.enable = lib.mkDefault true; # Update firmwares
    thermald.enable = lib.mkDefault true; # Keep cool
    udisks2 = {
      enable = true; # Mount USB without privileges
      settings = { };
    };
    geoclue2 = {
      enable = true; # Location provider
    };
    xserver = {
      enable = true;
      autorun = false;
      layout = "fr,us,fr";
      xkbVariant = "bepo_afnor,,";
      xkbOptions = "grp:ctrls_toggle";
      dpi = 144; # TODO better
      libinput.enable = true; # Enable touchpad support
      desktopManager.xterm.enable = false;
    };
    pipewire = {
      enable = true; # Enable modern audio system PipeWire
      # audio.enable = true; # Enable modern audio system PipeWire
      wireplumber.enable = true;
      alsa.enable = true; # Support kernel audio
      alsa.support32Bit = true; # Support kernel audio
      jack.enable = true; # Support advanced audio
      pulse.enable = true; # Support previous audio system
    };
    udev.packages = [
      pkgs.android-udev-rules # Talk to Android devices
    ];
    gnome.gnome-keyring.enable = true; # Manage secrets for apps
  };

  security.rtkit.enable = true;

  location.provider = "geoclue2";

  programs = {
    dconf.enable = true; # Recommended by virtualization wiki
    gnupg = {
      agent.enable = true;
      agent.pinentryFlavor = "curses";
    };
    ssh.startAgent = true;
    adb.enable = true; # Talk to Android devices
    zsh.enable = true;
    firejail = {
      enable = true; # TEST pertinence
      wrappedBinaries = { };
    };
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
      libsecret # Allow apps to use gnome-keyring
      iw # Control network cards
      exfat # fs tool
      ntfs3g # fs tool
      tldr # short man pages
      sshfs # browser ssh as directory
      rsync # cp through network & with superpowers
      sbctl # Secure Boot Control
    ];
  };
}
