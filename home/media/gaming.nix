{ pkgs, ... }: {
  home.packages = with pkgs; [
    heroic # Modern launcher supporting Gog and Epic Games
    # gogdl # Gog alternative
    # legendary-gl # Epic Games launcher alternative

    # moonlight-qt # Game streaming client # TEST if better than rustdesk
    mangohud # A practical HUD on top of games
    # protonup-ng # Manage installation of proton-ge
  ];
}
