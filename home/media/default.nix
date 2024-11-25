{ pkgs, ... }: {
  imports = [
    ./internet.nix
    ./organization.nix
    ./audio.nix
    ./photo.nix
    ./video.nix
    ./social.nix
    ./gaming.nix
    ./science.nix
  ];

  home.packages = with pkgs; [
    # Document & Spreadsheet & Presentation & Note
    typst # Advanced document processor
    # onlyoffice-bin # Full office suite
    onlyoffice-bin_latest # Full office suite
    # libreoffice-fresh # Office suite
    # libreoffice-qt # Office suite
    # libreoffice # Office suite
    # libreoffice-fresh-unwrapped # Office suite
    # libreoffice-still # Office suite
    # xournalpp # Notetaking with draw

    # PDF reading & editing
    # mupdf # Minimalist PDF reader
    # sioyek # Minimalist PDF reader
    poppler_utils # PDF metadata reading
    qpdf # PDF manipulation
    # pdf4qt # PDF edition
    # xpdf # PDF reader
    pdf4qt # PDF editor TODO hm module
    pdf-sign # PDF signing
    naps2 # Scan PDFs
    # tesseract # OCR on PDF or images
    # gnome.simple-scan # Document scanner

    # Audio & Music
    spotify # PROPRIETARY music streaming
    playerctl # MPRIS media players control

    # Image & Video
    viu # CLI image viewer
    # vpv # Advanced light image viewer
    qimgv # Another image viewer
    # oculante # Image viewer with some advanced features
    imagemagick # CLI image edition
    ffmpeg # media conversion
    mediainfo # info about audio or video
    yt-dlp # download videos from internet
    # youtube-dl # download videos from internet

    # Emulation
    # wine # Execute Window$ programs TODO reenable
    # winetricks # Execute Window$ programs TODO reenable
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
    zathura = {
      enable = true; # Minimal PDF reader
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
    mpv.enable = true; # Audio and video player
    imv.enable = true; # BUG Minimal image viewer
    # pqiv.enable = true; # Light image viewer
    # feh.enable = true; # Light X11 image viewer
  };
}
