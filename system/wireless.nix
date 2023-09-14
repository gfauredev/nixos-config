{ inputs, lib, config, pkgs, ... }: {
  hardware = {
    bluetooth = {
      enable = lib.mkDefault true;
      powerOnBoot = lib.mkDefault true;
    };
  };

  networking.useDHCP = lib.mkDefault true;
}
