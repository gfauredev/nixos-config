{ pkgs, ... }:
{
  imports = [ ./font.nix ]; # Additional fonts

  home.packages = with pkgs; [
    # calibre # Ebook management
    # Document & Spreadsheet & Presentation
    typst # Advanced document processor TODO Typst packages nixpkgs
    # quarto # Scientific and technical publishing system
    # hovercraft # impress.js presentations
    onlyoffice-desktopeditors # Full office suite
    libreoffice-fresh # Office suite
    # PDF Reading & Editing & Scan
    # mupdf # Minimalist PDF reader
    # sioyek # Minimalist PDF reader
    poppler_utils # PDF metadata reading/editing
    qpdf # More modern CLI PDF manipulation
    # pdf-sign # Automated PDF signing TODO config
    # pdfmixtool # Simple GUI to edit PDFs structure
    # naps2 # Scan PDFs FIX
    # ocrmypdf # Add a layer of text on scanned PDFs
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner
    # pdfpc # PDF Presentator Console
    # Diagrams
    # mermaid-cli # Markdown-like diagrams
    plantuml-c4 # UML diagrams from text with additions
    plantuml-server # Server for PlantUML
  ];

  programs = {
    zathura.enable = true; # Minimal PDF reader
    mpv.enable = true; # Audio and video player
    # imv.enable = true; # Minimal image viewer
    zathura = {
      extraConfig = ''
        set sandbox none
        set selection-clipboard clipboard

        set scroll-step 50
        set scroll-hstep 10

        map t scroll down
        map s scroll up
        map T navigate next
        map S navigate previous
        map c scroll left
        map r scroll right

        map R rotate rotate-cw
        map C rotate rotate-ccw

        map b recolor

        map D set "first-page-column 1"
        map <A-d> set "first-page-column 2"

        map [fullscreen] D set "first-page-column 1"
        map [fullscreen] <A-d> set "first-page-column 2"
      '';
    };
  };
}
