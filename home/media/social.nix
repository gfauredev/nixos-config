{ pkgs, ... }: {
  home.packages = with pkgs; [
    # thunderbird # Popular desktop email and calendar client TODO configure it
    # evolution # Desktop email and calendar client
    # himalaya # CLI mail client # Configure via home manager module
    # mailspring # Email client WARNING security issue

    simplex-chat-desktop # Super secure messaging
    element-desktop # Secure group messaging and calls
    # element-web # Secure messaging and calls
    signal-desktop # Secure messaging
    # signal-cli # Secure messaging
    olvid # French secure messaging

    nak # Nostr CLI
    gossip # Nostr GUI
    # nostr-rs-relay # Rust Nostr relay

    discord # PROPRIETARY messaging and general communication
  ];
}
