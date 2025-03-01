{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Web browsing
    # nyxt # Keyboard driven lightweight web browser
    # browsh # CLI web browser (added to default home)
    # brave # Blink based secure and private web browser
    # servo # New modular embeddable web engine

    # P2P & VPN & Web3
    nym # Super-anonymous routing protocol FIXME lacks desktop apps
    # mullvad # Anonymous VPN service
    transmission_4 # Bittorrent client
    qbittorrent # Bittorrent client
    iroh # Efficient IPFS, p2p file sharing
    # calyx-vpn # (bitmask client) Free VPN service FIXME
    riseup-vpn # (bitmask client) Free VPN service
    protonvpn-cli_2 # Swiss VPN service (Python rewrite)
    # protonvpn-cli # Swiss VPN service
    wayback # Web archiving tool
    # bitcoin # Bitcoin Core
    lnd # Lightning Network Daemon
    monero-gui # Private cryptocurrency
    monero-cli # Monero CLI
    electrum # Light Bitcoin Wallet
    sparrow # Bitcoin wallet
    ord # Ordinals CLI
    cointop # Cryptocurrencies monitor
    go-ethereum # Ethereum CLI

    # Monitoring & Analysis
    sherlock # Search social media accounts
    nmap # scan ports
    # rustscan # scan networks
    xh # User-friendly HTTP client similar to HTTPie
    # curl # Mythic HTTP client TEST xh only
    # thc-hydra # Pentesting tool
    # tshark # Wireshark CLI
    wireshark # Wireshark GUI
    # termshark # Wireshark TUI
    # iperf # IP bandwidth measuring
    # hping # Network monitoring tool
    # kismet # Wireless network sniffer
  ];

  programs = {
    firefox = {
      enable = true; # Web browser
    };
    chromium = {
      enable = true; # Web browser
      package = pkgs.brave; # Better privacy, security
    };
  };
}
