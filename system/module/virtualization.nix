{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true; # KVM/QEMU daemon
    podman.enable = true;
    docker.enable = false; # INSECURE
    virtualbox.host.enable = false;
    spiceUSBRedirection.enable = true; # Allow pass USB devices to VM
    libvirtd = {
      qemu = {
        swtpm.enable = true; # Software emulated TMP
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
      onBoot = "ignore"; # Do not auto start by default
      parallelShutdown = 4; # Shutdown up to 4 VMs in parallel
    };
    podman = {
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers.containersConf.settings = {
      engine.runtimes = {
        runsc = [ "${pkgs.gvisor}/bin/runsc" ];
      };
    };
  };

  services.spice-webdavd.enable = true; # WebDav daemon to share files with VMs
  programs.virt-manager.enable = true; # Libvirt GUI, prefer serial

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt 0755 root root - +C"
  ];

  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  # environment.systemPackages = with pkgs; [
  #   gvisor # Sandbox runtime for containers
  #   gvproxy
  #   cloud-init # Cloud instance initialization tool
  #   docker-compose # YAML files defining container(s)
  # ];
}
