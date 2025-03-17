{ config, ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${config.term.cmd} ${config.term.exec}";
        layer = "overlay";
      };
    };
  };
}
