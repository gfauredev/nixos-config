{ inputs, lib, config, pkgs, ... }: {
  musnix = {
    enable = true; # WARNING increases power consumption
    kernel = {
      realtime = true; # WARNING needs to compile kernel ourselves
    };
  };

  # security.rtkit.enable = true; # TEST relevance
}
