{ pkgs, ... }: # Could be sorted better
{
  # TODO sort better
  home.packages = with pkgs; [
    # f3d # Minimalist 3D viewer
    # Electronics
    horizon-eda # Modern EDA to develop printed circuit boards
    # quartus-prime-lite # Intel FPGA design software
    # kicad # Electronics (EDA) software BUG building
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
    dune3d # New simple parametric CAD
    # solvespace # Simple parametric 3D CAD
    # brlcad # Combinatorial solid modeling system
    # 3D Artistic
    # blender # Most popular 3D, animation & video editor
    # blenderWithPySlvs # Patched popular 3D, animation & video editor
    # meshlab # 3D mesh processing tool
    # Slicing
    bambu-studio # Bambu 3D printers’ slicer
    # cura # Popular 3D printer slicer
    # super-slicer # Popular 3D printer slicer, fork of prusa-slicer
    # Misc
    # lpac # Manage eSIMs in a chip (eUICC LPA)
    # sherlock # Search people on social media accounts
    # wayback # Web archiving tool
    qgis # Maps TODO https://www.mypermagarden.app/fr/download
    # VPN
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
    electrum # Light Bitcoin Wallet
    # sparrow # Bitcoin wallet
    # ord # Ordinals CLI
    # cointop # Cryptocurrencies monitor
    go-ethereum # Ethereum CLI
  ];
}
