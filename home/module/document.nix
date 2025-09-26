{ pkgs, ... }:
{
  imports = [ ./font.nix ]; # Additional fonts

  home.packages = with pkgs; [
    typst # Advanced document processor
    # mermaid-cli # Markdown-like diagrams
    plantuml-c4 # UML diagrams from text with additions
    # plantuml # UML diagrams from text
    # quarto # Scientific and technical publishing system
    # hovercraft # impress.js presentations
    # calibre # Ebook management
    # Document & Spreadsheet & Presentation
    onlyoffice-bin_latest # Full office suite
    libreoffice-fresh # Office suite
    # PDF Reading & Editing
    # mupdf # Minimalist PDF reader
    # sioyek # Minimalist PDF reader
    poppler_utils # PDF metadata reading/editing
    qpdf # More modern CLI PDF manipulation
    # pdftk # CLI PDF manipulation
    # pdfrip # PDF password cracking
    # pdf4qt # PDF edition
    # xpdf # PDF reader
    # pdf4qt # PDF editor
    # pdf-sign # Automated PDF signing TODO config
    # pdfmixtool # Simple GUI to edit PDFs structure
    # naps2 # Scan PDFs FIX
    # ocrmypdf # Add a layer of text on scanned PDFs
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner
    # pdfpc # PDF Presentator Console
  ];

  programs = {
    zathura.enable = true; # Minimal PDF reader
    mpv.enable = true; # Audio and video player
    imv.enable = true; # BUG Minimal image viewer
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
