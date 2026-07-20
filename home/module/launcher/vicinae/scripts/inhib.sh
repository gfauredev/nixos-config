#!/bin/bash
# @vicinae.schemaVersion 1
# @vicinae.title inhib
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/bash"]

notify-send "Inhibiting sleep for $1"
systemd-inhibt sleep "$1" &
