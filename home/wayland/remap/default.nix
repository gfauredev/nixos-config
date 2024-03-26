{ ... }: {
  # home.packages = with pkgs; [
  #   weylus # Phone as graphic tablet
  # ];

  # xdg.configFile = {
  #   input-remapper-2 = {
  #     source = ./input-remapper-2;
  #   };
  # };

  home.file = {
    XCompose = {
      # TODO cleaner
      target = ".XCompose";
      source = ./XCompose;
    };
  };
}
