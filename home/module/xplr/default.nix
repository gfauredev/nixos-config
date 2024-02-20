{ ... }: {
# TODO set an explorer that can open & preview every file
  programs = {
    xplr = {
      enable = true; # CLI file explorer
      extraConfig = ''
        ${builtins.readFile ./xplr.lua}
      '';
    };
  };
}
