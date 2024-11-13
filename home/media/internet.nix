{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Web browsing
    brave # Blink based secure and private web browser
    # nyxt # Keyboard driven lightweight web browser

    # P2P & VPN & Web3
    nym # A new mixnet, anonymous routing protocol
    mullvad # VPN service
    qbittorrent-nox # Bittorrent client (web interface)
    # calyx-vpn # (bitmask client) Free VPN service FIXME
    riseup-vpn # (bitmask client) Free VPN service
    protonvpn-cli_2 # Free VPN service (Python rewrite)
    # protonvpn-cli # Free VPN service

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
      enable = true; # Web browser TODO configure brave with sops
      # package = pkgs.brave; # Web browser
      # See: https://support.brave.com/hc/en-us/articles/360044860011-How-Do-I-Use-Command-Line-Flags-in-Brave
      # See: https://chromium.googlesource.com/chromium/src/+/refs/heads/main/chrome/common/chrome_switches.cc
      # commandLineArgs = [ ];
      # dictionaries = [ ];
      # extensions = [{ id = "idididididididid"; }];
    };
  };
}
