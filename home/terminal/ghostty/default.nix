{ lib, ... }: {
  programs.ghostty = {
    enable = true;
    installBatSyntax = true;
    installVimSyntax = true;
  };

  # See https://ghostty.org/docs/config
  programs.ghostty.settings = {
    keybind = [
      "ctrl+t=new_tab"
      "ctrl+s=next_tab"
      "performable:ctrl+c=copy_to_clipboard"
      "performable:ctrl+v=paste_from_clipboard"
    ];
    # theme = "catppuccin-mocha"; # TODO Stylix
    # font-size = 12; # TODO Stylix
    background-opacity = ".8"; # Stylix
    background = lib.mkForce "#000000"; # Stylix
  };
}
