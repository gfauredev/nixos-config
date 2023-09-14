{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./neovim.nix
    ./helix.nix
  ];

  home.packages = with pkgs; [
    # TODO use home.programs or flakes when possible
    # Web
    brave # Blink based secure and private web browser
    firefox # Gecko based web browser
    # nyxt # Keyboard driven lightweight web browser
    # chromium # Blink based web browser

    # Theme & Style
    # nordzy-cursor-theme # TEST relevance

    # Misc
    # albert # General purpose launcher FIXME
    # xbanish # Hide mouse Xorg
    # bleachbit
    # gnome.seahorse
    # chntpw # Access Windows (dual boot) registry
    # protonvpn-gui # Free VPN service
  ];
}
