{ ... }: # My main laptop, a Framework Laptop 13
let
  nvme0n1 = {
    p1 = "/dev/disk/by-uuid/TODO"; # FAT 32
    p2 = "/dev/disk/by-uuid/TODO"; # LUKS
  };
  cryptroot = "/dev/disk/by-uuid/TODO"; # Btrfs
in
{
  networking.hostName = "chimera";
  networking.hostId = "acabacab";

  imports = [
    ./.
    ./module/laptop.nix # Laptops specifics
    # (modulesPath + "/installer/scan/not-detected.nix") # Why ?
  ];

  boot = {
    kernelModules = [ "kvm-intel" ];
    # kernelParams = [ "resume_offset=TODO" ];
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

  services.fprintd.enable = false;
}
