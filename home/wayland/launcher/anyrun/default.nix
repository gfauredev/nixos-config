{ pkgs, ... }: {
  # imports = [ inputs.anyrun.homeManagerModules.default ];

  home.packages = with pkgs;
    [
      anyrun # Modern full-featured launcher
    ];

  # programs.anyrun = {
  #   # DOC: https://github.com/Kirottu/anyrun
  #   enable = true; # TODO add flake and test
  #   package = pkgs.anyrun;
  #   config = {
  #     plugins = with inputs.anyrun.packages.${pkgs.system}; [
  #       applications
  #       dictionary
  #       kidex
  #       randr
  #       rink
  #       shell
  #       # stdin
  #       symbols
  #       translate
  #       websearch
  #     ];
  #     hideIcons = false;
  #     ignoreExclusiveZones = false;
  #     layer = "overlay";
  #     hidePluginInfo = false;
  #     closeOnClick = false;
  #     showResultsImmediately = false;
  #     maxEntries = 12;
  #   };
  # };
}
