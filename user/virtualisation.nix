{ inputs, lib, config, pkgs, ... }: {
  # programs = { # TEST relevance
  #   dconf.enable = true;
  # };

  environment.systemPackages = with pkgs; [
    # TODO use dedicated option when possible
    # virt-manager
    # vagrant # VM orchestrator
    # looking-glass-client
    # docker-compose
    # kubernetes # Container orchestrator
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    docker.enable = true;
    virtualbox.host = {
      enable = true;
      # enableExtensionPack = true; # WARNING needs a lot of compilation
    };
    # vmware.host = { # PROPRIETARY
    #   enable = true;
    # };
  };
}
