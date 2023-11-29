{ inputs, lib, config, pkgs, ... }: {
  # Doc : https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.extensions
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    # package = pkgs.vscode-with-extensions;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # Quality of life
      vscodevim.vim
      # Nix
      jnoortheen.nix-ide
      # Lua
      sumneko.lua
      # Python
      # ms-python.pyright
      ms-python.vscode-pylance
      ms-python.python
      # Rust
      rust-lang.rust-analyzer
      techtheawesome.rust-yew
      # C / C++
      llvm-vs-code-extensions.vscode-clangd
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
