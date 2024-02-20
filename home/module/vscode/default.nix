{ inputs, lib, config, pkgs, ... }: {
  # Doc : https://nix-community.github.io/home-manager/options.html#opt-programs.vscode.extensions
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # vscodevim.vim # (Neo)Vim mode & keybindings
      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
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
