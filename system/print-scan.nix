{ inputs, lib, config, pkgs, ... }: {
  hardware = {
    sane = {
      enable = lib.mkDefault true;
      extraBackends = with pkgs;[
        # sane-backends
        sane-airscan
        hplipWithPlugin
      ];
    };
  };
}
