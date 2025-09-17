{ lib, pkgs, ... }:
{
  services = {
    printing.enable = true; # Enable CUPS to print documents
    avahi.enable = lib.mkDefault true; # Discover printers & scanners on network
    printing.cups-pdf.enable = true; # Printing to PDF
    avahi.nssmdns4 = true;
    ipp-usb.enable = lib.mkDefault true; # USB printers
  };

  hardware = {
    sane.enable = lib.mkDefault true;
    sane.extraBackends = with pkgs; [ sane-airscan ];
  };
}
