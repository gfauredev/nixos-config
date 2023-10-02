{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    # Text & Document
    libreoffice-fresh # Office suite
    # libreoffice-qt # Office suite
    # libreoffice # Office suite
    # libreoffice-fresh-unwrapped # Office suite
    # libreoffice-still # Office suite
    masterpdfeditor4 # PDF editor
    xournalpp # Notetaking with draw
    # write_stylus
    # markdown-anki-decks
    # marktext # Markdown editor
    # calibre # Ebook management
    # zathura # Minimalist PDF reader
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner

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

    # Audio & Music
    spotify # PROPRIETARY music streaming
    playerctl # MPRIS media players control

    # Image & Video # TODO find better image viewer
    imv # Image viewer
    swayimg # Image viewer that can integrate with terminals
    # sxiv # Image viewer

    # Utilities & Software # TODO refile more precisely
    qbittorrent-nox # CLI Bittorrent client
    # fontforge # Font editor
    # languagetool # Grammar checking, now using the LSP version
    # qbittorrent # Bittorrent client
    # transmission-qt # Bittorrent client
    # filezilla # FTP client
    # xdg-utils # Mime type based file oppening # TEST if relevant
    # handlr # Default app launcher # TEST if relevant
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
