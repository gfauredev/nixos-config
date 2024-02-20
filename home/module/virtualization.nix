{ pkgs, ... }: {
  home.packages = with pkgs; [
    vagrant # VM auto provisionner
    virt-manager # GUI frontend to libvirtd
    # looking-glass-client
    # kubernetes # Container orchestrator
  ];
}
