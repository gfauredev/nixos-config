{ pkgs, ... }: # My main laptop, a Framework Laptop 13
{
  imports = [
    ../.
    ./hardware.nix
  ];

  networking.hostName = "griffin";
  networking.hostId = "bbfdd0e2";

  environment.systemPackages = with pkgs; [
    framework-tool # Hardware related tools for framework laptops
  ];

  # nix = {
  #   settings = {
  #     substituters = [ "https://cache.nixos.org" ];
  #     trusted-public-keys = [
  #       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  #     ];
  #   };
  # };

  # services.fwupd = {
  #   extraRemotes = [ "lvfs-testing" ];
  # };

  system.stateVersion = "25.05";
}
