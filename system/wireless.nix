{ inputs, lib, config, pkgs, ... }: {
  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };
  };

  networking = {
    networkmanager = {
      enable = lib.mkDefault true; # TODO append dns0
    };
  };
}
