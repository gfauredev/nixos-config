{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    heroic # gog and epic games launcher
    gogdl # gog module for heroic launcher
    legendary-gl # Epic games launcher alternative
    # TEST relevance of all
    # gamescope # steamos compositing manager
    # appimage-run # Run appimages directly
    # steam # PROPRIETARY video games store and launcher
    # steam-run # Run in isolated FHS
  ];
}
