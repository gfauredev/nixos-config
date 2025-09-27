{ pkgs, lib, ... }: # TODO find a better name for this module
{
  options.organization.pim = lib.mkOption {
    default = "thunderbird";
    description = "Main Personal Information Management app";
  };
  config.home.packages = with pkgs; [
    # lpac # Manage eSIMs in a chip (eUICC LPA)
    # sherlock # Search people on social media accounts
    # wayback # Web archiving tool
    qgis # Maps TODO https://www.mypermagarden.app/fr/download
    # Flashcards
    # anki-bin # Memorisation FIXME
    # markdown-anki-decks
    # Notes
    # xournalpp # Handwriting notetaking FIXME
    # appflowy # Notion alternative
    # anytype # Knowledge base TEST
    # logseq # Knowledge base TEST
    # siyuan # Knowledge management # No p2p sync
    # silverbullet # Knowledge management # No p2p sync
    # affine # Knowledge base # No Android app
    # mindforger # Outliner note taking
    # emanote # Structured view text notes
    # rnote # Note tool
    # memos # Atomic memo hub
    # emacsPackages.org-roam-ui
    # VPN
    protonvpn-gui # Swiss VPN service (Python GUI)
    # calyx-vpn # (bitmask client) Free VPN service
    # riseup-vpn # (bitmask client) Free VPN service
    # nym # Super-anonymous routing protocol FIXME lacks desktop apps
    # mullvad # Anonymous VPN service
    # Messaging & Social
    signal-desktop # Secure messaging
    # signal-cli # Secure messaging
    simplex-chat-desktop # Anonymous secure messaging
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
  config.programs = {
    anki.enable = false; # Temporary FIXME
    himalaya.enable = true; # TODO configure
    khal.enable = true; # TODO configure
  };
}
