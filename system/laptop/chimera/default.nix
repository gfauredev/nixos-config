{
  lib,
  modulesPath,
  ...
}: # My main laptop, a Framework Laptop 13
{
  networking.hostName = "chimera";
  networking.hostId = "acabacab";

  imports = [
    ../.
    ./filesystem.nix
    (modulesPath + "/installer/scan/not-detected.nix") # Why ?
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
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

  services.fprintd.enable = false;

  system.stateVersion = "25.05";
}
