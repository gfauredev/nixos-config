{ pkgs, ... }: {
  home.packages = with pkgs; [
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
    # write_stylus
    # markdown-anki-decks
    # marktext # Markdown editor
    # calibre # Ebook management
    # mupdf # Minimalist PDF reader
    # sioyek # Minimalist PDF reader
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner
    # anytype # General productivity app

    # Note & Organization
    anki-bin # Memorisation
    plantuml-c4 # UML diagrams from text
    # emacsPackages.org-roam-ui
    # hovercraft # impress.js presentations
    # emanote # Structured view text notes
    # logseq # Outliner note taking
    # rnote
    # appflowy
    pdfpc # PDF Presentator Console
    weylus # Phone as graphic tablet
    quarto # Scientific and technical publishing system

    # Audio & Music
    spotify # PROPRIETARY music streaming
    playerctl # MPRIS media players control
    # spotify-tui

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

    # Languages
    ltex-ls # Grammar language server
    hunspell # Natural language spell checker
    hunspellDicts.fr-any # For french
    hunspellDicts.en_US # For english
    hunspellDicts.en_GB-ise # For english
    hunspellDicts.es_ES # For spanish
    typst # Document processor
    typst-lsp # Document processor LSP
    typstfmt # Typst formatter
    marksman # Markdown

    # Misc
    # fontforge # Font editor
    # languagetool # Grammar checking, now using the LSP version
    # qbittorrent # Bittorrent client
    # transmission-qt # Bittorrent client
    # filezilla # FTP client
    # xdg-utils # Mime type based file oppening # TEST if relevant
    # handlr # Default app launcher # TEST if relevant
    # jot # Notes-graph manager
    # zk # Zettelkasten
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
    mpv = {
      enable = true;
    };
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
}
