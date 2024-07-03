{ lib, ... }: {
  nixpkgs = {
    config = {
      # allowUnfree = true;
      # Fixes https://github.com/nix-community/home-manager/issues/2942
      # allowUnfreePredicate = (_: true);
      # More fine-grain control
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-run"
        ];
    };
  };

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

  # environment.systemPackages = with pkgs;
  #   [
  #     steam-run # Run program with a steam like environment
  #   ];
}
