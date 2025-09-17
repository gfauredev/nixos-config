{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
    podman.enable = true;
    docker.enable = false; # INSECURE
    virtualbox.host.enable = false; # SLOW
    vmware.host.enable = false; # PROPRIETARY
    spiceUSBRedirection.enable = true; # Allow pass USB devices to VM
    libvirtd = {
      qemu = {
        runAsRoot = false;
        swtpm.enable = true; # Software emulated TMP
        ovmf.enable = true; # UEFI implementation
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
      onBoot = "ignore"; # Do not auto start by default
      parallelShutdown = 4; # Shutdown up to 4 VMs in parallel
    };
    podman = {
      autoPrune.enable = true;
      extraPackages = with pkgs; [
        podman-compose
        # gvisor
        # dive
      ];
      dockerSocket.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.spice-webdavd.enable = true; # WebDav daemon to share files with VMs
  programs.virt-manager.enable = true; # GUI for libvirt
}
