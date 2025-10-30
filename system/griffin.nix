{
  pkgs,
  modulesPath,
  ...
}: # My main laptop, a Framework Laptop 13
let
  nvme0n1 = {
    p1 = "/dev/disk/by-uuid/1D92-247E"; # FAT 32
    p2 = "/dev/disk/by-uuid/436884c6-7982-407c-b213-8d034a22f466"; # LUKS
  };
  cryptroot = "/dev/disk/by-uuid/7a87ac1f-33a3-415f-b339-2bba2c847c24"; # Btrfs
in
{
  networking.hostName = "griffin";
  networking.hostId = "bbfdd0e2";

  imports = [
    ./. # Systems defaults
    ./module/laptop.nix # Laptops specifics
    ./module/virtualization.nix # Virtualization tools
    (modulesPath + "/installer/scan/not-detected.nix") # Why ?
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "resume_offset=5776640" ];
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
      luks.devices."cryptroot".device = nvme0n1.p2;
    };
    resumeDevice = cryptroot;
  };
  hardware.cpu.intel.updateMicrocode = true; # Intel CPU…

  fileSystems = {
    "/".device = cryptroot; # System root
    "/boot".device = nvme0n1.p1; # ESP
    "/code".device = cryptroot; # Executable location for users
    "/home".device = cryptroot; # Users homes
    "/log".device = cryptroot; # Logs
    "/nix".device = cryptroot; # Nix Store
    "/swap".device = cryptroot; # Contains the swapfile
  };

  services.fwupd.extraRemotes = [ "lvfs-testing" ]; # Necessary for Framework
  # services.fwupd.uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;

  environment.systemPackages = with pkgs; [
    framework-tool # Hardware related tools for framework laptops
  ];

  system.stateVersion = "25.05";
}
