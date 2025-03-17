{ ... }: {
  # imports = [ ./default.nix ];

  programs = {
    waybar = {
      settings = {
        bottomBar = {
          window.max-length = 600;
          mpris.dynamic-len = 120;
        };
      };
    };
  };
}
