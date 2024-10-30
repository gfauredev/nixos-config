{ pkgs, term, ... }: {
  home.packages = with pkgs;
    [
      albert # Full-featured launcher
    ];
  # TODO config
}
