{ pkgs, ... }: {
  home.packages = with pkgs; [
    memos # Atomic memo hub
    appflowy # Notion alternative
    affine # Next-gen knowledge base
    anytype # General productivity app
    anki-bin # Memorisation
    # logseq # Outliner note taking
    # emacsPackages.org-roam-ui
    # emanote # Structured view text notes
    # rnote # Note tool
    # markdown-anki-decks
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
