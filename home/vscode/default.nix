{ inputs, lib, config, pkgs, ... }: {
  # Doc : https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.extensions
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      # ms-python.pyright
      ms-python.vscode-pylance
      ms-python.python
    ];
    # userSettings = {
    #   # JSON
    #   vim.enableNeovim = true;
    #   vim.neovimUseConfigFile = true;
    # };
    # userTasks = {
    #   # JSON
    # };
    # keybindings = [
    #   # List of JSON modules
    # ];
    # globalSnippets = {
    #   # JSON
    # };
    # languageSnippets = {
    #   # JSON
    # };
  };
}
