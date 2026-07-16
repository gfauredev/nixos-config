#!/bin/sh

# Find active default network interface (e.g., wlan0, wlp1s0)
IFACE=$(ip route show default | awk '{print $5}' | head -n 1)

if [ -z "$IFACE" ]; then
  echo "Error: No active network interface found."
  exit 1
fi

# Extract unencrypted DNS server provided by the Wi-Fi router's DHCP
DHCP_DNS=$(nmcli -g IP4.DNS device show "$IFACE" | head -n 1 | awk '{print $1}')

# Fallback to the default gateway IP if NM didn't capture a DNS server
if [ -z "$DHCP_DNS" ]; then
  DHCP_DNS=$(ip route show default | awk '{print $3}' | head -n 1)
fi

echo "Bypassing encrypted DNS."
echo "Routing interface $IFACE to local DHCP DNS: $DHCP_DNS"

# Stop local DNSCrypt service
sudo systemctl stop dnscrypt-proxy

# Force systemd-resolved to use DHCP DNS for this specific interface
sudo resolvectl dns "$IFACE" "$DHCP_DNS"

# Route all system-wide DNS queries strictly to this interface (overrides the 127.0.0.1 global rule)
sudo resolvectl domain "$IFACE" "~."

# Clear cache to ensure the browser doesn't try to use old encrypted routes
sudo resolvectl flush-caches

echo "Done. You can now log into the captive portal."
