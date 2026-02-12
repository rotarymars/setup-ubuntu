#!/usr/bin/env bash
set -e

WIFI_IFACE="wlp2s0"
HOTSPOT_NAME="rotarymars"
HOTSPOT_PASS="rotarymars"

GW="192.168.50.1"
SUBNET="192.168.50.0/24"

WPA="/run/wpa_supplicant/$WIFI_IFACE"

start() {
    echo "[+] Using NetworkManager wpa_supplicant socket $WPA"

    if [ ! -S "$WPA" ]; then
        echo "❌ wpa_supplicant socket not found: $WPA"
        exit 1
    fi

    echo "[+] Creating Intel P2P-GO hotspot"
    sudo wpa_cli -p /run/wpa_supplicant -i "$WIFI_IFACE" p2p_set ssid_postfix "_$HOTSPOT_NAME"
    sudo wpa_cli -p /run/wpa_supplicant -i "$WIFI_IFACE" p2p_set passphrase "$HOTSPOT_PASS"
    sudo wpa_cli -p /run/wpa_supplicant -i "$WIFI_IFACE" p2p_group_add

    sleep 3

    HOTSPOT_IFACE=$(iw dev | awk '/p2p-/{print $2; exit}')
    if [ -z "$HOTSPOT_IFACE" ]; then
        echo "❌ P2P interface not created"
        exit 1
    fi

    echo "[+] Hotspot interface: $HOTSPOT_IFACE"

    sudo ip addr add "$GW/24" dev "$HOTSPOT_IFACE" || true
    sudo ip link set "$HOTSPOT_IFACE" up

    echo "[+] Enabling IP forwarding"
    sudo sysctl -w net.ipv4.ip_forward=1 >/dev/null

    echo "[+] Enabling NAT"
    sudo iptables -t nat -A POSTROUTING -o "$WIFI_IFACE" -j MASQUERADE
    sudo iptables -A FORWARD -i "$HOTSPOT_IFACE" -o "$WIFI_IFACE" -j ACCEPT
    sudo iptables -A FORWARD -i "$WIFI_IFACE" -o "$HOTSPOT_IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT

    echo "[+] Starting DHCP"
    sudo dnsmasq --interface="$HOTSPOT_IFACE" --bind-interfaces \
        --dhcp-range=192.168.50.10,192.168.50.100,12h

    echo "🔥 Hotspot running: DIRECT-$HOTSPOT_NAME"
}

stop() {
    echo "[+] Stopping DHCP"
    sudo pkill dnsmasq || true

    HOTSPOT_IFACE=$(iw dev | awk '/p2p-/{print $2; exit}')

    if [ -n "$HOTSPOT_IFACE" ]; then
        echo "[+] Removing NAT"
        sudo iptables -t nat -D POSTROUTING -o "$WIFI_IFACE" -j MASQUERADE || true
        sudo iptables -D FORWARD -i "$HOTSPOT_IFACE" -o "$WIFI_IFACE" || true
        sudo iptables -D FORWARD -i "$WIFI_IFACE" -o "$HOTSPOT_IFACE" -m state --state RELATED,ESTABLISHED || true

        echo "[+] Removing P2P group"
        sudo wpa_cli -p /run/wpa_supplicant -i "$WIFI_IFACE" p2p_group_remove "$HOTSPOT_IFACE" || true
    fi

    echo "✅ Hotspot stopped"
}

case "$1" in
    start) start ;;
    stop) stop ;;
    *) echo "Usage: $0 {start|stop}" ;;
esac

