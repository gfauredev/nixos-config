{ pkgs, ... }:
{
  imports = [ ./firefox ];

  home.packages = with pkgs; [
    # Web browsing
    # nyxt # Keyboard driven lightweight web browser
    # browsh # CLI web browser (added to default home)
    # brave # Blink based secure and private web browser
    # servo # New modular embeddable web engine

    # P2P & VPN & Web3
    # nym # Super-anonymous routing protocol FIXME lacks desktop apps
    # mullvad # Anonymous VPN service
    transmission_4 # Bittorrent client
    qbittorrent # Bittorrent client
    # iroh # Efficient IPFS, p2p file sharing
    # calyx-vpn # (bitmask client) Free VPN service FIXME
    # riseup-vpn # (bitmask client) Free VPN service FIXME
    protonvpn-gui # Swiss VPN service (Python rewrite)
    wayback # Web archiving tool
    # bitcoin # Bitcoin Core
    lnd # Lightning Network Daemon
    monero-gui # Private cryptocurrency
    # monero-cli # Monero CLI
    electrum # Light Bitcoin Wallet
    # sparrow # Bitcoin wallet
    # ord # Ordinals CLI
    # cointop # Cryptocurrencies monitor
    go-ethereum # Ethereum CLI

    # Messaging
    simplex-chat-desktop # Super secure messaging
    element-desktop # Secure group messaging and calls
    # element-web # Secure messaging and calls
    signal-desktop # Secure messaging
    # signal-cli # Secure messaging
    # olvid # French secure messaging
    discord # PROPRIETARY messaging and general communication

    # Social networks
    # nak # Nostr CLI
    # gossip # Nostr GUI
    # nostr-rs-relay # Rust Nostr relay

    # Misc
    lpac # Manage eSIMs in a chip (eUICC LPA)
    sherlock # Search social media accounts
  ];

  programs = {
    chromium = {
      enable = true; # Web browser
      package = pkgs.brave; # Better privacy, security
    };
  };
}
