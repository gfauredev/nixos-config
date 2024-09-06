{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki-bin # Memorisation
    appflowy # Notion alternative
    # affine # Next-gen knowledge base
    anytype # General productivity app
    grocy # Household management
    # logseq # Outliner note taking
    # emacsPackages.org-roam-ui
    # emanote # Structured view text notes
    # rnote # Note tool
    # markdown-anki-decks
    # calibre # Ebook management
    # memos # Atomic memo hub

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
