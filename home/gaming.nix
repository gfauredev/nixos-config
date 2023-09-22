{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO specific options when possible
    # TEST relevance of all
    # steam # PROPRIETARY video games store and launcher
    # heroic # gog and epic games launcher
    # gogdl # gog dl module for heroic launcher
    # legendary-gl # epic games launcher alternative
    # appimage-run # Run appimages directly
    # steam-run # Run in isolated FHS
    # gamescope # steamos compositing manager
  ];
}
