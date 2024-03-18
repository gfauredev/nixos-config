{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Languages
    languagetool # Advanced spell checking
    ltex-ls # LSP between languagetool and pure text
    hunspell # Standard spell checker
    hunspellDicts.fr-any # French
    hunspellDicts.en_US # American
    # hunspellDicts.en_GB-ise # British
    hunspellDicts.es_ES # Spanish
    typst # Advanced document processor
    typst-lsp # Typst LSP
    typstfmt # Typst formatter
    marksman # Smart Markdown links
    # quarto # Scientific and technical publishing system

    # Text & Document
    libreoffice-fresh # Office suite
    # libreoffice-qt # Office suite
    # libreoffice # Office suite
    # libreoffice-fresh-unwrapped # Office suite
    # libreoffice-still # Office suite
    masterpdfeditor4 # PDF editor
    xournalpp # Notetaking with draw
    poppler_utils # Read PDF metadata
    qpdf # PDF manipulation
    # mupdf # Minimalist PDF reader
    # sioyek # Minimalist PDF reader
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner

    # Audio & Music
    spotify # PROPRIETARY music streaming
    playerctl # MPRIS media players control

    # Image & Video # TODO find better image viewer
    imv # Image viewer
    # swayimg # Image viewer that can integrate with terminals
    # sxiv # Image viewer
    imagemagick # CLI image edition
    ffmpeg # media conversion
    mediainfo # info about audio or video
    yt-dlp # download videos from internet
    # youtube-dl # download videos from internet

    # Emulation
    wine # Execute Window$ programs
    winetricks # Execute Window$ programs
  ];

  fonts.fontconfig.enable = true;

  services = {
    playerctld.enable = true;
    mpris-proxy.enable = true;
    # easyeffects = {
    #   enable = true;
    #   # preset = lib.readFile ../easyeffectsPreset.json; FIXME
    # };
  };

  programs = {
    mpv = { enable = true; };
    zathura = {
      enable = true;
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
      '';
    };
  };

  xdg.dataFile = {
    typst-lib = {
      target = "typst/packages/local";
      source = ../../misc/typst-lib;
    };
  };
}
