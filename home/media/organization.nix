{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki-bin # Memorisation
    appflowy # Notion alternative
    anytype # General productivity app
    # logseq # Outliner note taking
    # affine # Next-gen knowledge base
    # emacsPackages.org-roam-ui
    # emanote # Structured view text notes
    # rnote # Note tool
    # markdown-anki-decks
    # calibre # Ebook management

    # Rendering & Presentation
    # pdfpc # PDF Presentator Console
    plantuml-c4 # UML diagrams from text
    # hovercraft # impress.js presentations

    # Misc
    gpxsee # GPS track viewer
    # archi # Archimate modeling tool
  ];
}
