{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Web browsing
    brave # Blink based secure and private web browser
    nyxt # Keyboard driven lightweight web browser

    # Misc
    qbittorrent-nox # Bittorrent client (web interface)
    calyx-vpn # Free VPN service with bitmask client
    riseup-vpn # Free VPN service with bitmask client
    # protonvpn-cli # Free VPN service
    protonvpn-cli_2 # Free VPN service (Python rewrite)
  ];
}
