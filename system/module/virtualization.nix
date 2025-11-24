{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true; # KVM/QEMU daemon
    podman.enable = true;
    docker.enable = false; # INSECURE
    virtualbox.host.enable = true;
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
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      # autoPrune.enable = true;
    };
  };

  services.spice-webdavd.enable = true; # WebDav daemon to share files with VMs
  programs.virt-manager.enable = true; # Libvirt GUI, prefer serial

  # environment.systemPackages = with pkgs; [
  #   cloud-init # Cloud instance initialization tool
  #   docker-compose # YAML files defining container(s)
  # ];
}
