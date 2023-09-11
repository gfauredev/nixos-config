{ inputs, lib, config, pkgs, ... }: {
  networking.useDHCP = lib.mkDefault true;
}
