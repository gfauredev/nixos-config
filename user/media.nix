{ inputs, lib, config, pkgs, ... }: {
  home.packages = with pkgs; [
    # TODO use specific options when possible
    # Text & Document
    zathura # Minimalist PDF reader
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
}
