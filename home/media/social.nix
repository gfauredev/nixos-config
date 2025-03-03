{ pkgs, ... }: {
  home.packages = with pkgs; [
    simplex-chat-desktop # Super secure messaging
    element-desktop # Secure group messaging and calls
    # element-web # Secure messaging and calls
    signal-desktop # Secure messaging
    # signal-cli # Secure messaging
    olvid # French secure messaging

    nak # Nostr CLI
    gossip # Nostr GUI
    # nostr-rs-relay # Rust Nostr relay

    lpac # Manage eSIMs in a chip (eUICC LPA)

    discord # PROPRIETARY messaging and general communication
  ];
}
