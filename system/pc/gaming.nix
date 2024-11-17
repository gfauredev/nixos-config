{ lib, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];

  programs = {
    steam = {
      enable = true;
      # gamescopeSession.enable = true;
      remotePlay.openFirewall = lib.mkDefault false; # Open ports
      dedicatedServer.openFirewall = lib.mkDefault false; # Open ports
    };
    gamemode.enable = true;
    # gamescope.enable = true;
  };
}
