# Ideally find a semantic place to refile those settings
{ inputs, lib, config, pkgs, ... }: {
  services = {
    localtimed.enable = true;
    nfs.server.enable = true;
    # cachix-agent.enable = true;
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
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
      tray = "never";
    };
    syncthing = {
      enable = true;
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
    adb.enable = true;
    ssh.startAgent = true;
  };

  environment = {
    shells = with pkgs; [ zsh ];
    # pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [
      age
      gnupg
      openssl
      libsecret

      zip
      unzip
      p7zip
      gzip
      bzip2
      bzip3
      librsvg

      exfat
      ntfs3g
    ];
  };

  security = {
    sudo.enable = true;
    # polkit.enable = true; # TODO: test pertinence
    # apparmor.enable = true; # TODO: test pertinence
  };
}
