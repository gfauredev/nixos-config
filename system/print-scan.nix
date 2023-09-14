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

  services = {
    avahi = {
      # Discover printers & scanners on network
      enable = lib.mkDefault true;
      nssmdns = true;
    };
    printing = {
      enable = true; # Enable CUPS to print documents
      cups-pdf.enable = true; # Printing to PDF
      drivers = with pkgs; [
        hplipWithPlugin
      ];
    };
    ipp-usb.enable = lib.mkDefault true; # USB printers
  };
}
