{ pkgs, lib, ... }:
{
  imports = [
    ./internet+communication.nix
    ./organization.nix
    ./audio.nix
    ./photo.nix
    ./video.nix
    ./gaming.nix
    ./science.nix
    ./3d.nix
    ./typst.nix
    ./qimgv
  ];

  options.media.favorite = lib.mkOption {
    default = "spotify"; # Preferred media app
    description = "favorite media app";
  };

  config = {
    home.packages = with pkgs; [
      # Document & Spreadsheet & Presentation & Note
      xournalpp # Handwriting notetaking
      # onlyoffice-bin # Full office suite
      onlyoffice-bin_latest # Full office suite
      libreoffice-fresh # Office suite
      # libreoffice-qt # Office suite
      # libreoffice # Office suite
      # libreoffice-fresh-unwrapped # Office suite
      # libreoffice-still # Office suite
      # PDF reading & editing
      # mupdf # Minimalist PDF reader
      # sioyek # Minimalist PDF reader
      poppler_utils # PDF metadata reading/editing
      # pdftk # CLI PDF manipulation
      qpdf # More modern CLI PDF manipulation
      pdfrip # PDF password cracking
      # pdf4qt # PDF edition
      # xpdf # PDF reader
      # pdf4qt # PDF editor
      pdf-sign # Automated PDF signing TODO config
      # pdfmixtool # Simple GUI to edit PDFs structure
      # naps2 # Scan PDFs FIX
      ocrmypdf # Add a layer of text on scanned PDFs
      # tesseract # OCR on PDF or images
      # gnome.simple-scan # Document scanner
      # Audio & Music
      spotify # PROPRIETARY music streaming
      playerctl # MPRIS media players control
      # Image & Video
      viu # CLI image viewer
      qimgv # Another image viewer
      imagemagick # CLI image edition
      ffmpeg # media conversion
      mediainfo # info about audio or video
      yt-dlp # download videos from YouTube or other video site
      spotdl # download music and playlists from Spotify
      # mplayer # Video viewer TEST me
      # vlc # Video viewer TEST me
      # Emulation
      # wine # Execute Window$ programs
      # wineWowPackages.stable # Execute Window$ programs (32 and 64 bits)
      wineWowPackages.waylandFull # Execute Window$ programs (32 and 64 bits)
      winetricks # Execute Window$ programs (config tool)
      # bottles # Wine prefixes management TEST me
      # Misc
      # localsend # Share files on local network
      # exercism # CLI for the programming exercises website
    ];

    services = {
      playerctld.enable = true;
      mpris-proxy.enable = true;
    };

    programs = {
      zathura.enable = true; # Minimal PDF reader
      mpv.enable = true; # Audio and video player
      imv.enable = true; # BUG Minimal image viewer
      zathura = {
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

          map D set "first-page-column 1"
          map <A-d> set "first-page-column 2"

          map [fullscreen] D set "first-page-column 1"
          map [fullscreen] <A-d> set "first-page-column 2"
        '';
      };
    };
  };
}
