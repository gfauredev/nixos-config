{
  pkgs,
  lib,
  modulesPath,
  ...
}: # My main laptop, a Framework Laptop 13
{
  networking.hostName = "griffin";
  networking.hostId = "bbfdd0e2";

  imports = [
    ./.
    ../module/loginManager # Launch graphical env at login
    ../module/secureboot.nix # Secure Boot (Lanzaboote)
    (modulesPath + "/installer/scan/not-detected.nix") # Why ?
  ];

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

  environment.systemPackages = with pkgs; [
    framework-tool # Hardware related tools for framework laptops
  ];

  boot.initrd.luks.devices."cryptroot".device =
    "/dev/disk/by-uuid/436884c6-7982-407c-b213-8d034a22f466";

  fileSystems =
    let
      nvme0n1 = {
        p1 = "/dev/disk/by-uuid/1D92-247E"; # FAT 32
        p2 = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24"; # btrfs
      };
    in
    {
      "/".device = nvme0n1.p2; # System root
      "/boot".device = nvme0n1.p1; # ESP
      "/code".device = nvme0n1.p2; # Executable location for users
      "/home".device = nvme0n1.p2; # Users homes
      "/log".device = nvme0n1.p2; # Logs
      "/nix".device = nvme0n1.p2; # Nix Store
      "/swap".device = nvme0n1.p2; # Contains the swapfile
    };

  system.stateVersion = "25.05";
}
