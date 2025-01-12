{ pkgs, ... }: {
  # networking.firewall.enable = lib.mkForce false; # FIXME for virt nets

  environment.systemPackages = with pkgs;
    [
      virtiofsd # virtio-fs backend
    ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
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
    vmware.host = {
      enable = false; # PROPRIETARY
    };
    # sharedDirectories = {
    #   virt-share = {
    #     source = "/virt-share";
    #     target = "/mnt/virt-share";
    #   };
    # };
  };
}
