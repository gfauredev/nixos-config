#!/bin/sh
# @vicinae.schemaVersion 1
# @vicinae.title inhib
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/sh"]
# @vicinae.argument1 { "type": "text", "placeholder": "30m", "optional": true }

DURATION="${1:-30m}"

(
  # Check if sleep is already being inhibited across the system
  # Matches any active systemd-inhibit line containing the 'sleep' operation
  EXISTING_PIDS=$(systemd-inhibit --list | awk -F '|' '$4 ~ /sleep/ { gsub(/[[:space:]]/, "", $3); if ($3 ~ /^[0-9]+$/) print $3 }')

  if [ -z "$1" ] && [ -n "$EXISTING_PIDS" ]; then
    for pid in $EXISTING_PIDS; do
      kill "$pid" 2>/dev/null
    done
    notify-send "Sleep inhibition stopped" "Terminated active sleep inhibitor process(es)."
    exit 0
  fi

  notify-send "Inhibiting sleep" "For $DURATION"
  if ! systemd-inhibit --why="inhib.sh, notably used by Vicinae launcher" sleep "$DURATION"; then
    notify-send "Failed to inhibit sleep" "$(systemd-inhibit --list)"
  fi
) &
