{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki-bin # Memorisation
    siyuan # Modern knowledge management TEST
    affine # Next-gen knowledge base TEST
    anytype # General productivity app TEST
    appflowy # Notion alternative TEST
    logseq # Outliner note taking TEST
    silverbullet # Knowledge management TEST
    # mindforger # Outliner note taking
    grocy # Household management TODO make it work
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
