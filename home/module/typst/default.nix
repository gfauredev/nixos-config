{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    typst # Advanced document processor TODO Typst packages nixpkgs
  ];

  xdg.dataFile."typst/packages/local" = {
    # recursive = true; # Link Typst library
    source = config.lib.file.mkOutOfStoreSymlink "${config.location}/public/home/module/typst/";
  };
}
