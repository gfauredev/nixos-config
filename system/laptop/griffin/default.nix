{
  pkgs,
  lib,
  modulesPath,
  ...
}: # My main laptop, a Framework Laptop 13
{
  imports = [
    ../.
    ./filesystem.nix
    ../../module/loginManager # Launch graphical env at login
    ../../module/secureboot.nix # Secure Boot (Lanzaboote)
    (modulesPath + "/installer/scan/not-detected.nix") # Why ?
  ];

  # users.extraUsers.root = rec {
  #   initialHashedPassword = hashedPassword; # FIXME
  #   hashedPassword = null;
  #   initialPassword = password;
  #   password = null;
  #   hashedPasswordFile = null;
  # };

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        # "usb_storage"
        "uas"
        "sd_mod"
      ];
      kernelModules = [
        "snd-seq" # TEST relevance, used by musnix
        "snd-rawmidi" # TEST relevance, used by musnix
      ];
    };
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true; # Intel CPU…

  networking.hostName = "griffin";
  networking.hostId = "bbfdd0e2";

  environment.systemPackages = with pkgs; [
    framework-tool # Hardware related tools for framework laptops
  ];

  # services.fwupd = {
  #   extraRemotes = [ "lvfs-testing" ];
  # };

  system.stateVersion = "25.05";
}
