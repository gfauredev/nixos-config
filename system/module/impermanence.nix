{ ... }: # TODO configure Impermanence, see https://github.com/nix-community/impermanence?tab=readme-ov-file#system-setup
{
  persistence."/persist" = {
    hideMounts = true;
    directories = [
      # "/home"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
      "/var/lib/bluetooth"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];
    # TODO ensure users homes are always persistent
  };
}
