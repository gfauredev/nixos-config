{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    # Text & Document
    masterpdfeditor4 # PDF editor
    libreoffice-fresh # Office suite
    # libreoffice-qt # Office suite
    # libreoffice # Office suite
    # libreoffice-fresh-unwrapped # Office suite
    # libreoffice-still # Office suite
    anki-bin # Memorisation
    # languagetool # Grammar checking, now using the LSP version
    # appflowy
    # xournalpp
    # write_stylus
    # markdown-anki-decks
    # logseq # Outliner note taking
    # marktext # Markdown editor
    # calibre # Ebook management
    # zathura # Minimalist PDF reader

    # Audio & Music
    spotify # PROPRIETARY music streaming

    # Image & Video
    swayimg # image viewer
    # sxiv # image viewer
    mpv
    # imv

    # Utilities & Software # TODO refile more precisely
    xdg-utils # Mime type based file oppening
    tesseract # OCR on PDF or images
    qbittorrent-nox # CLI Bittorrent client
    fontforge # Font editor
    # qbittorrent # Bittorrent client
    # gnome.simple-scan # Document scanner
    # transmission-qt # Bittorrent client
    # filezilla # FTP client
    # emacsPackages.org-roam-ui
    # hovercraft # impress.js presentations
    # emanote # Structured view text notes
    # handlr # Default app launcher
    # obs-studio
    # obs-studio-plugins.wlrobs
    # obs-wlrobs
    # webtorrent_desktop
    # rnote
  ];

  services.mpris-proxy.enable = true;

  programs.zathura = {
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
}
