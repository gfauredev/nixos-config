{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki-bin # Memorisation
    # markdown-anki-decks
    anytype # Knowledge base TEST
    # logseq # Knowledge base TEST
    appflowy # Notion alternative TEST
    # siyuan # Knowledge management # No p2p sync
    # silverbullet # Knowledge management # No p2p sync
    # affine # Knowledge base # No Android app
    # mindforger # Outliner note taking
    # emacsPackages.org-roam-ui
    # emanote # Structured view text notes
    # rnote # Note tool
    # memos # Atomic memo hub
    # calibre # Ebook management

    # Rendering & Presentation
    pdfpc # PDF Presentator Console
    mermaid-cli # Markdown-like diagrams
    plantuml-c4 # UML diagrams from text
    # quarto # Scientific and technical publishing system
    # hovercraft # impress.js presentations

    # Misc
    gpxsee # GPS track viewer
    # archi # Archimate modeling tool
  ];
}
