# Configuration for my main user gf on my main laptop Griffin
{ ... }: {
  imports =
    [ ../module/terminal/ghostty ../default.nix ../module/wayland/chimera.nix ];

  programs.mpv.enable = true;
}

