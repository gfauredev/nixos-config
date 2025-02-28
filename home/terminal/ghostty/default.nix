{ ... }: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;
  };

  # See: https://ghostty.org/docs/config
  programs.ghostty.settings = {
    theme = "catppuccin-mocha";
    font-size = 12;
    keybind = [
      "ctrl+t=new_tab"
      "ctrl+s=next_tab"
      "performable:ctrl+c=copy_to_clipboard"
      "performable:ctrl+v=paste_from_clipboard"
    ];
  };
}
