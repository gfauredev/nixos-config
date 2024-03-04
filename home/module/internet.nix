{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Web browsing
    brave # Blink based secure and private web browser
    nyxt # Keyboard driven lightweight web browser

    # P2P & VPN
    qbittorrent-nox # Bittorrent client (web interface)
    calyx-vpn # Free VPN service with bitmask client
    riseup-vpn # Free VPN service with bitmask client
    protonvpn-cli_2 # Free VPN service (Python rewrite)
    # protonvpn-cli # Free VPN service

    # Monitoring & Analysis
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
    };
    # browserpass.enable = true; # TEST relevance
  };
}
