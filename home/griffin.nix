{ pkgs, ... }: # Main laptop Griffin
{
  imports = [
    ./. # Default home
    ./module/wayland/griffin.nix # Windows, Colors, Futile stuff
    ./module/web # Browsers
    ./module/organization.nix # Email, Calendar, Task, Contact, Note
    ./module/document.nix # Document, Spreadsheet, Presentation, PDF
    ./module/audio.nix # Audio Production & Creation
    ./module/qimgv # Fully-featured image and video viewer
    ./module/photo.nix # Photo & Image Edition
  ];

  home.packages = with pkgs; [
    # playerctl # MPRIS media players control TEST needed with playerctld?
    # streamrip # Download music
    # spotdl # Download music and playlists from Spotify
    spotube # Open source Spotify and more client
    klick # Metronome
    viu # CLI image viewer
    imagemagick # CLI image edition
    cheese # Webcam capture
    # meld # Graphical merge tool
    # f3d # Minimalist 3D viewer
    # lpac # Manage eSIMs in a chip (eUICC LPA)
    sherlock # Search people on social media accounts
    # wayback # Web archiving tool
    qgis # Maps TODO https://www.mypermagarden.app/fr/download
    # guile # Scheme compiler and runtime
    pre-commit # Git hook manager
    # pre-pre-commit-hook-ensure-sops # Ensure sops is used for secrets
    # Electronics
    dfu-util # Device Firmware Upgrade USB utility
    # rpi-imager # Raspberry Pi OS imager
    # horizon-eda # Modern EDA to develop printed circuit boards
    kicad # Electronics (EDA) software BUG building
    # librepcb # Modern EDA software
    # fritzing # Elecronics (EDA) software
    # xschem # Schematic editor TODO imperative install
    # xyce # -parallel # Analog circuit simulator TODO imperative install
    # gnucap-full # Circuit analysis
    # ngspice # Electronic circuit simulator
    # scilab-bin # Scientific computations TODO install imperatively
    # stm32flash # Open source flash program for the STM32 ARM processors
    # stm32cubemx # Graphical tool for configuring STM32 microcontrollers
    # 3D CAD
    freecad-wayland # Popular parametric 3D CAD
    openscad-unstable # Code CAD
    openscad-lsp # LSP
    # dune3d # New simple parametric CAD
    # solvespace # Simple parametric 3D CAD
    # brlcad # Combinatorial solid modeling system
    # 3D Artistic
    # blender # Most popular 3D, animation & video editor
    # blenderWithPySlvs # Patched popular 3D, animation & video editor
    # meshlab # 3D mesh processing tool
    # Slicing
    orca-slicer # G-code generator for 3D printers…
    # cura # Popular 3D printer slicer
    # super-slicer # Popular 3D printer slicer, fork of prusa-slicer
    # VPN
    # amnezia-vpn # Anonymous VPN service
    protonvpn-gui # Swiss VPN service (Python GUI)
    # calyx-vpn # (bitmask client) Free VPN service
    # riseup-vpn # (bitmask client) Free VPN service
    # nym # Super-anonymous routing protocol FIXME lacks desktop apps
    # mullvad # Anonymous VPN service
    # Messaging & Social
    signal-desktop # Secure messaging
    # signal-cli # Secure messaging
    # simplex-chat-desktop # Anonymous secure messaging
    # olvid # French anonymous secure messaging
    # element-desktop # Secure group messaging and calls
    # element-web # Secure messaging and calls
    # telegram-desktop # "Secure" messaging
    # nak # Nostr CLI
    # gossip # Nostr GUI
    # nostr-rs-relay # Rust Nostr relay
    # P2P & Web3
    qbittorrent # Bittorrent client
    # transmission_4 # Bittorrent client
    # iroh # Efficient IPFS, p2p file sharing
    # bitcoin # Bitcoin Core
    lnd # Lightning Network Daemon
    # monero-gui # Private cryptocurrency
    # monero-cli # Monero CLI
    # electrum # Light Bitcoin Wallet
    # sparrow # Bitcoin wallet
    # ord # Ordinals CLI
    # cointop # Cryptocurrencies monitor
    go-ethereum # Ethereum CLI
  ];
}
