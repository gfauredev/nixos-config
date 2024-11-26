{ ... }: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${term.cmd} ${term.exec}";
        layer = "overlay";
      };
      colors = {
        background = "00000080";
        border = "00000000";
      };
    };
  };
}
