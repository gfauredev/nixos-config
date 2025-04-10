{ lib, pkgs, ... }: {
  services = {
    printing = {
      enable = true; # Enable CUPS to print documents
      cups-pdf.enable = true; # Printing to PDF
      # drivers = with pkgs;
      #   [
      #     # hplip
      #     hplipWithPlugin
      #   ];
    };
    avahi = {
      # Discover printers & scanners on network
      enable = lib.mkDefault true;
      nssmdns4 = true;
    };
    ipp-usb.enable = lib.mkDefault true; # USB printers
  };

  hardware = {
    sane = {
      enable = lib.mkDefault true;
      extraBackends = with pkgs;
        [
          sane-airscan
          # hplipWithPlugin
          # sane-backends
        ];
    };
  };
}
