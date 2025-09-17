{ ... }:
{
  programs.alacritty.enable = true; # Fast terminal emulator, see https://alacritty.org/config-alacritty.html
  programs.alacritty.settings = {
    general.live_config_reload = false;
    window.padding = {
      x = 2;
      y = 2;
    };
  };
}
