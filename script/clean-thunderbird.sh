pgrep thunderbird && kill $(pgrep thunderbird) # Ensure Thunderbird is stopped

trash "$HOME/.cache/thunderbird" # Remove Thunderbird’s general cache

trash "$HOME/.thunderbird/pmptthhg.default/calendar-data" # Remove Calendar cache
