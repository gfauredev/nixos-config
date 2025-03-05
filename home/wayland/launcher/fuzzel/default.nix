{ config, lib, ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${config.term.cmd} ${config.term.exec}";
        layer = "overlay";
      };
      colors.background = lib.mkForce "00000080"; # Stylix
    };
  };
}
