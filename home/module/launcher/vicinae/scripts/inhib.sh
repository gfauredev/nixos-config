#!/bin/sh
# @vicinae.schemaVersion 1
# @vicinae.title inhib
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/sh"]

notify-send "Trying to inhibit sleep for $1"
(systemd-inhibit --why="inhib.sh, notably used by Vicinae launcher" sleep "$1" || notify-send "Failed to inhibit sleep") &
