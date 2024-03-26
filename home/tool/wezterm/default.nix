{ ... }: {
  programs = {
    wezterm = {
      enable = true; # Modern terminal emulator
      extraConfig = ''
        cfg = wezterm.config_builder() -- Base config

        ${builtins.readFile ./cfg.lua}

        ${builtins.readFile ./key.lua}

        return cfg
      '';
    };
  };
}
