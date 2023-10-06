{ inputs, lib, config, pkgs, ... }: {
  specialisation.realtime.configuration = {
    musnix = {
      enable = true;
      kernel = {
        realtime = false; # WARNING if true we need to recompile kernel
      };
    };
  };
}
