{ pkgs, lib, ... }:
{
  options.organization.pim = lib.mkOption {
    default = "thunderbird";
    description = "Main Personal Information Management app";
  };

  config.home.packages = with pkgs; [
    anki-bin # Memorisation
    # markdown-anki-decks
    # appflowy # Notion alternative
    # anytype # Knowledge base TEST
    # logseq # Knowledge base TEST
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
    # pdfpc # PDF Presentator Console
    # mermaid-cli # Markdown-like diagrams
    # plantuml-c4 # UML diagrams from text
    # quarto # Scientific and technical publishing system
    # hovercraft # impress.js presentations

    # Finance
    # gnucash # Double entry accounting TEST ME
    # homebank # Easy accounting TEST ME

    # Misc
    # gpxsee # GPS track viewer
    # archi # Archimate modeling tool
    # glib # GTK Tools, needed for logseq
  ];

  config.programs = {
    himalaya.enable = true;
    khal.enable = true;
  };
}
