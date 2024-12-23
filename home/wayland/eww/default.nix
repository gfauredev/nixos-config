{ ... }: {
  programs.eww = {
    enable = true;
    configDir = ./config;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
