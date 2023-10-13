{ inputs, lib, config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vagrant # VM orchestrator
    # virt-manager # GUI frontend to libvirtd
    # looking-glass-client
    # Containers
    kubernetes # Container orchestrator
  ];

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
      enable = true;
      # enableExtensionPack = true; # WARNING needs a lot of compilation
    };
    # vmware.host = {
    #   enable = true; # PROPRIETARY
    # };
  };
}
