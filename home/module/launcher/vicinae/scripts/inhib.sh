#!/bin/sh
# @vicinae.schemaVersion 1
# @vicinae.title inhib
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/sh"]
# @vicinae.argument1 { "type": "text", "placeholder": "1h" }

(if systemd-inhibit --why="inhib.sh, notably used by Vicinae launcher" sleep "$1"; then
  notify-send "Inhibiting sleep" "For $1"
else
  notify-send "Failed to inhibit sleep" "$(systemd-inhibit)"
fi) &
