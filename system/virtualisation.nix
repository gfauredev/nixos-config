{ inputs, lib, config, pkgs, ... }: {
  programs = {
    dconf.enable = true; # Recommended by virtualization wiki
  };

  environment.systemPackages = with pkgs; [
    # TODO use dedicated option when possible
    virt-manager # GUI frontend to libvirtd
    vagrant # VM orchestrator
    kubernetes # Container orchestrator
    # looking-glass-client
  ];

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
