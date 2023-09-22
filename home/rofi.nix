{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    libqalculate # Calculation library used by rofi
  ];

  programs = {
    rofi = {
      enable = true; # TEST which launcher is better
      # package = pkgs.rofi-wayland; # Set this for wayland
      cycle = true;
      font = "FiraCode Nerd Font";
      # location = "top";
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
      terminal = "${term-exec}";
      theme = ../style/rounded-blue-dark.rasi;
      extraConfig = {
        # TODO configure better
        # modi = "combi,drun,filebrowser,calc,emoji,top,file-browser-extended,keys,window,run,ssh";
        modi = "combi,drun,run,window,file-browser-extended,calc,emoji,top";
      };
    };
    # wofi = {
    #   enable = true; # TEST if better than rofi
    # };
  };
}
