{ pkgs, config, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = false;
    extraPackages = config.editor.commonPackages;
    extraLuaConfig = ''
      ${builtins.readFile ./remap.lua}
      ${builtins.readFile ./opt.lua}
    '';
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars # Parsing & text highlighting
      nvim-lspconfig # Boilerplate to use language servers
      telescope-nvim # Fuzzy search & navigate files & code
    ];
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text editor";
    settings."GenericName[fr]" = "Éditeur de texte";
    comment = "Edit text files";
    settings."Comment[fr]" = "Éditer des fichiers texte";
    # settings.TryExec = "${pkgs.neovim}/bin/nvim";
    settings.TryExec = "nvim";
    terminal = true; # Doesn’t work all the time
    # terminal = false; # We want xdg-open to open it in new window
    # exec = "env SHELL=zsh ${term.cmd} ${term.exec} nvim %F";
    type = "Application";
    settings.Keywords = "text;editor;";
    settings."Keywords[fr]" = "texte;éditeur;";
    icon = "nvim";
    categories = [
      "Utility"
      "TextEditor"
    ];
    startupNotify = false;
    mimeType = [
      "text/english"
      "text/french"
      "text/plain"
      "text/x-makefile"
      "text/x-c++hdr"
      "text/x-c++src"
      "text/x-chdr"
      "text/x-csrc"
      "text/x-java"
      "text/x-moc"
      "text/x-pascal"
      "text/x-tcl"
      "text/x-tex"
      "application/x-shellscript"
      "text/x-c"
      "text/x-c++"
    ];
  };
}
