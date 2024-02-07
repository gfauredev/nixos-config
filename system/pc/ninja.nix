{ ... }: {
  imports = [
    ./ninja-hardware.nix # Hardware specific conf
  ];

  nix = {
    settings = {
      substituters = [
        "http://admin.gfaure.eu" # knight as binary cache
      ];
      trusted-public-keys = [
        "admin.gfaure.eu:J5VSLwk9wb1x2eTEIcfvRyWcYuXu4WhuTc6g5QavjkY="
      ];
    };
  };

  hardware = {
    sensor.iio.enable = true;
  };

  boot = {
    # extraModprobeConfig = ''
    #   options snd_usb_audio vid=0x1235 pid=0x8210 device_setup=1
    # '';
    # Last line above is used for Focusrite sound interfaces
    bootspec.enable = true;
    loader.systemd-boot.enable = false; # Disabled for secureboot
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  networking = {
    hostName = "ninja";
    firewall = {
      enable = true;
      # Syncthing:22000,21027 | Vagrant:2049
      allowedTCPPorts = [ 22000 2049 ]; # Opened TCP ports
      allowedUDPPorts = [ 22000 21027 2049 ]; # Open UDP ports
      # extraCommands = ''
      #   iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
      # '';
    };
    wireguard.enable = true;
  };

  security = {
    pam.services = {
      swaylock = { };
    };
  };

  services = {
    fwupd = {
      # extraRemotes = [ "lvfs-testing" ];
    };
    fprintd = {
      enable = true; # Support figerprint reader
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
