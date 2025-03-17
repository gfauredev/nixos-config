{ ... }: {
  # home.packages = with pkgs; [
  #   weylus # Phone as graphic tablet
  # ];

  home.file = {
    XCompose = {
      # TODO cleaner
      target = ".XCompose";
      source = ./XCompose;
    };
  };
}
