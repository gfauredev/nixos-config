#!/bin/sh
# @vicinae.schemaVersion 1
# @vicinae.title inhib
# @vicinae.mode fullOutput
# @vicinae.exec ["/bin/sh"]
# @vicinae.argument1 { "type": "text", "placeholder": "30m (optional)", "optional": true }

DEFAULT_DURATION="30m"
KILLED_ANY=0

# Kill any existing sleep inhibitors
PIDS="$(pgrep -f "systemd-inhibit.*sleep" 2>/dev/null)"
if [ -n "$PIDS" ]; then
  kill $PIDS 2>/dev/null
  KILLED_ANY=1
  notify-send -u low "Inhibition cancelled" "Terminated active sleep inhibitor(s)"
fi

# - If an argument: inhibit for the provided duration
# - If no argument and no prior inhibitor: inhibit for 30 minutes
# - If no argument and prior inhibitors (killed): stop inhibition
DURATION="$1"
if [ -z "$DURATION" ]; then
  if [ "$KILLED_ANY" -eq 1 ]; then
    exit 0
  fi
  DURATION="$DEFAULT_DURATION"
fi

# Spawn inhibitor in background
(
  notify-send "Inhibiting Sleep & Idle" "Will be disabled for ${DURATION}"

  if ! systemd-inhibit \
    --what="sleep:idle" \
    --who="inhib.sh" \
    --why="Inhibit sleep (often used by Vicinae launcher)" \
    --mode="block" \
    sleep "$DURATION"; then
    notify-send -u critical "Failed to inhibit" "Check system permissions"
  fi
) &
