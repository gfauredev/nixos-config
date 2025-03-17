# Configuration for my main user gf on my main laptop Griffin
{ ... }: {
  imports = [
    ./default.nix
    ./home/wayland/griffin.nix # Griffin laptop’s GUI
  ];
}
