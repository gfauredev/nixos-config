{ ... }: {
  xdg.configFile = {
    "qimgv/qimgv.static.conf".source = ./qimgv.conf;
    "qimgv/savedState.static.conf".source = ./savedState.conf;
    "qimgv/theme.static.conf".source = ./theme.conf;
  };
}
