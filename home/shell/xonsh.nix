{ pkgs, ... }: {
  home.packages = with pkgs; [
    xonsh # Shell which is a superset of Python which is a shell
  ];

  # programs.xonsh = { # TODO Home Manager module
  #   enable = true; # Shell which is a superset of Python
  # };
}
