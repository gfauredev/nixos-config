# Inhib kills the (buggy) idle service for a given time
systemctl --user stop hypridle.service && systemd-inhibit sleep "$1"
systemctl --user start hypridle.service
