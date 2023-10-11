# Accept all traffic
# sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Delete every rules
sudo iptables -F
sudo iptables -X
# Flush all counters
sudo iptables -Z
