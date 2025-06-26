{ pkgs, ... }: {
  # networking.firewall.enable = lib.mkForce false; # FIXME for virt nets
  # environment.systemPackages = with pkgs;
  #   [
  #     virtiofsd # virtio-fs backend
  #   ];

  # See https://search.nixos.org/options?channel=unstable&show=virtualisation.vlans&from=50&size=50&sort=relevance&type=packages&query=virtualisation
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = false;
        swtpm.enable = true; # Software emulated TMP
        ovmf.enable = true; # UEFI implementation
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
      spiceUSBRedirection.enable = true; # Allow pass USB devices to VM
      onBoot = "ignore"; # Do not autostart by default
      parallelShutdown = 4; # Shutdown up to 4 VMs in parallel
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
      extraPackages = with pkgs; [ podman-compose gvisor dive ];
      dockerSocket.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      enable = false;
      extraPackages = with pkgs; [ docker-compose ];
    };
    virtualbox.host = {
      enable = false;
      enableExtensionPack = false; # WARNING needs a lot of compilation
    };
    vmware.host.enable = false; # PROPRIETARY
    # vlans = [ ];
    # sharedDirectories = {
    #   virt-share = {
    #     source = "/virt-share";
    #     target = "/mnt/virt-share";
    #   };
    # };
  };

  services.spice-webdavd.enable = true; # WebDav daemon to share files with VMs

  programs.virt-manager.enable = true;
}
