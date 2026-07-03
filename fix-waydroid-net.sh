#!/usr/bin/env bash
# Fix Waydroid "no internet" on a host running ufw + Docker, which both
# default the netfilter FORWARD chain to DROP and thus kill Android's
# routed traffic. This opens forwarding ONLY for the waydroid0 bridge.
set -euo pipefail

BRIDGE=waydroid0
SUBNET=192.168.240.0/24
WAN="$(ip route show default | awk '/default/{print $5; exit}')"
echo ">> WAN interface detected: ${WAN:-<none>}"
[ -n "$WAN" ] || { echo "No default route found; are you online?"; exit 1; }

echo ">> ufw: allow DNS/DHCP to host + allow forwarding across the bridge"
sudo ufw allow in on "$BRIDGE"                           # DNS/DHCP from Android to host
sudo ufw route allow in on "$BRIDGE" out on "$WAN"       # Android -> internet (stateful)
sudo ufw reload

echo ">> Docker: whitelist the bridge in DOCKER-USER (evaluated before Docker's DROP)"
sudo iptables -C DOCKER-USER -i "$BRIDGE" -j ACCEPT 2>/dev/null \
  || sudo iptables -I DOCKER-USER -i "$BRIDGE" -j ACCEPT
sudo iptables -C DOCKER-USER -o "$BRIDGE" -j ACCEPT 2>/dev/null \
  || sudo iptables -I DOCKER-USER -o "$BRIDGE" -j ACCEPT

echo ">> Ensure NAT masquerade for the waydroid subnet"
sudo iptables -t nat -C POSTROUTING -s "$SUBNET" ! -o "$BRIDGE" -j MASQUERADE 2>/dev/null \
  || sudo iptables -t nat -A POSTROUTING -s "$SUBNET" ! -o "$BRIDGE" -j MASQUERADE

echo ">> Restarting the Waydroid container"
sudo systemctl restart waydroid-container
sleep 8

echo ">> Testing connectivity inside Android"
echo "--- raw IP (tests forwarding/NAT) ---"
sudo waydroid shell -- ping -c3 8.8.8.8 || true
echo "--- hostname (tests DNS) ---"
sudo waydroid shell -- ping -c3 google.com || true

cat <<'EOF'

If "raw IP" works but "hostname" fails, it's just DNS -- set a resolver:
  sudo waydroid shell -- su -c "setprop net.dns1 8.8.8.8"

Once both work, let Android sit ~2 min so Play Services checks in, then
re-read the device id and register it at google.com/android/uncertified.
EOF
