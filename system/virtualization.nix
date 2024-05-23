{ lib, pkgs, ... }: {
  # networking.firewall.enable = lib.mkForce false; # FIXME for virt nets

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.enable = true;
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
      extraPackages = with pkgs; [ podman-compose gvisor ];
      dockerSocket.enable = false;
      dockerCompat = false;
    };
    docker = {
      enable = true;
      extraPackages = with pkgs; [ docker-compose ];
    };
    virtualbox.host = {
      enable = false;
      enableExtensionPack = false; # WARNING needs a lot of compilation
    };
    vmware.host = {
      enable = false; # PROPRIETARY
    };
  };
}
