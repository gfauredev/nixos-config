{ lib, pkgs, ... }: {
  networking.firewall.enable = lib.mkForce false; # FIXME for virt nets

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker = {
      enable = true;
      extraPackages = with pkgs; [
        docker-compose
      ];
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
