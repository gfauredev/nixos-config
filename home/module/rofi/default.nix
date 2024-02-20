{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    libqalculate # Calculation library used by rofi
  ];

  programs = {
    rofi = {
      enable = true; # TEST which launcher is better
      cycle = true;
      font = "FiraCode Nerd Font";
      # pass = { # TODO configure
      #   enable = true;
      #   extraConfig = ''
      #   '';
      #   stores = [];
      # };
      plugins = with pkgs; [
        rofi-file-browser
        rofi-calc
        rofi-top
        rofi-emoji
        rofi-bluetooth
        rofi-pulse-select
        rofi-systemd
      ];
      # shell = "${pkgs.dash}/bin/dash";
      # terminal = "${term-exec}"; TODO global variables
      terminal = "wezterm start --always-new-process";
      theme = ./rounded-blue-dark.rasi;
      extraConfig = {
        modi = "combi,drun,run,window,file-browser-extended,calc,emoji,top";
      };
    };
  };
}
