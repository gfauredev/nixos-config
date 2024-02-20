{ pkgs, ... }: {
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Fixes https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  programs = {
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play TEST
      # dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server TEST
    };
    gamemode.enable = true;
    gamescope = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    steam-run # Run program with a steam like environment
  ];
}
