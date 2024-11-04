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

  xdg.desktopEntries.wezterm = {
    name = "WezTerm";
    genericName = "Terminal emulator";
    settings."GenericName[fr]" = "Émulateur de terminal";
    comment = "Wez’s Terminal Emulator";
    settings.TryExec = "wezterm";
    exec = "env SHELL=zsh wezterm start --cwd .";
    terminal = false; # It is a terminal
    type = "Application";
    settings.Keywords = "shell;prompt;command;commandline;cmd;cli;";
    settings."Keywords[fr]" = "shell;prompt;commande;cmd;cli;";
    icon = "org.wezfurlong.wezterm";
    categories = [ "Utility" "System" "TerminalEmulator" ];
    startupNotify = false;
    settings.StartupWMClass = "org.wezfurlong.wezterm";
    mimeType = [ "application/x-shellscript" "inode/directory" ];
    actions."Directory".exec =
      ''"env SHELL=zsh wezterm start --cwd %f zsh -ic 'l;zsh'"'';
  };
}
