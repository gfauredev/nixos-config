{ ... }: {
  programs = {
    wezterm = {
      enable = true; # Modern terminal emulator
      enableZshIntegration = true;
      # extraConfig = ''
      #   cfg = wezterm.config_builder() -- Base config
      extraConfig = ''
        local wezterm = require "wezterm"
        local cfg = {}
        ${builtins.readFile ./cfg.lua}
        ${builtins.readFile ./key.lua}
        return cfg
      '';
    };
  };
}
