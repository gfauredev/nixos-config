{ pkgs, ... }:
{
  imports = [
    ./typst # Typst config
    ./font.nix # Additional fonts
  ];

  home.packages = with pkgs; [
    # calibre # Ebook management
    # Document & Spreadsheet & Presentation
    # quarto # Scientific and technical publishing system
    # hovercraft # impress.js presentations
    onlyoffice-desktopeditors # Full office suite
    kiwix # Offline reader for web
    # libreoffice-fresh # Office suite
    # PDF Reading & Editing & Scan
    # mupdf # Minimalist PDF reader
    # sioyek # Minimalist PDF reader
    # poppler-utils # PDF metadata reading/editing
    qpdf # More modern CLI PDF manipulation
    # pdf-sign # Automated PDF signing
    # pdfmixtool # Simple GUI to edit PDFs structure
    naps2 # Scan PDFs with OCR
    ocrmypdf # Add a layer of text on scanned PDFs
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner
    pdfpc # PDF Presentator Console
    # Diagrams
    # mermaid-cli # Markdown-like diagrams
    plantuml-c4 # UML diagrams from text with additions
    # plantuml-server # Server for PlantUML
  ];

  programs.mpv.enable = true; # Audio and video player
}
