{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    heroic # gog and epic games launcher
    gogdl # gog module for heroic launcher
    legendary-gl # Epic games launcher alternative
    # moonlight-qt # Game streaming client # TEST if better than rustdesk
  ];
}
