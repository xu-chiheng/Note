#!/usr/bin/env -S bash -i

# This script has not been tested yet at 2025-05-19 .

# https://teddysun.com/554.html
# https://github.com/teddysun/across
# https://github.com/hwdsl2/wireguard-install
# https://github.com/atrandys/wireguard

# https://www.wireguard.com/quickstart/
# https://www.wireguard.com/install/


install_wireguard() {
	echo "Attempting to install WireGuard..."
	if check_command_existence apt; then
		echo "Detected APT-based system (Debian/Ubuntu)"
		apt update \
		&& apt install -y wireguard
	elif check_command_existence dnf; then
		echo "Detected DNF-based system (Fedora/RedHat/CentOS)"
		dnf install -y wireguard-tools
	elif check_command_existence pacman; then
		echo "Detected Pacman-based system (Arch/Manjaro)"
		pacman -Syu --noconfirm wireguard-tools
	else
		echo "Unsupported package manager"
		return 1
	fi
	echo "WireGuard installation completed."
}

# Create server interface
create_server_if() {
	SERVER_PRIVATE_KEY="$(wg genkey)"
	SERVER_PUBLIC_KEY="$(echo ${SERVER_PRIVATE_KEY} | wg pubkey)"
	CLIENT_PRIVATE_KEY="$(wg genkey)"
	CLIENT_PUBLIC_KEY="$(echo ${CLIENT_PRIVATE_KEY} | wg pubkey)"
	CLIENT_PRE_SHARED_KEY="$( wg genpsk )"
	echo "Create server interface: /etc/wireguard/${SERVER_WG_NIC}.conf"
	[ ! -d "/etc/wireguard" ] && mkdir -p "/etc/wireguard"
	cat > /etc/wireguard/${SERVER_WG_NIC}.conf <<EOF
[Interface]
Address = ${SERVER_WG_IPV4}/24
ListenPort = ${SERVER_WG_PORT}
PrivateKey = ${SERVER_PRIVATE_KEY}

[Peer]
PublicKey = ${CLIENT_PUBLIC_KEY}
AllowedIPs = ${CLIENT_WG_IPV4}/32
PresharedKey = ${CLIENT_PRE_SHARED_KEY}
PersistentKeepalive = 25
EOF

	chmod 600 /etc/wireguard/${SERVER_WG_NIC}.conf
}

# Create client interface
create_client_if() {
	echo "Create client interface: /etc/wireguard/${SERVER_WG_NIC}_client"
	cat > /etc/wireguard/${SERVER_WG_NIC}_client <<EOF
[Interface]
PrivateKey = ${CLIENT_PRIVATE_KEY}
Address = ${CLIENT_WG_IPV4}/24
DNS = ${CLIENT_DNS_1},${CLIENT_DNS_2}

[Peer]
PublicKey = ${SERVER_PUBLIC_KEY}
PresharedKey = ${CLIENT_PRE_SHARED_KEY}
AllowedIPs = 0.0.0.0/0
Endpoint = ${SERVER_PUB_IPV4}:${SERVER_WG_PORT}
EOF

	chmod 600 /etc/wireguard/${SERVER_WG_NIC}_client
}


install() {
	SERVER_PUB_IPV4="$(linux_print_ipv4_address)"
	SERVER_PUB_NIC="$(linux_print_default_nic)"
	SERVER_WG_NIC="wg0"
	SERVER_WG_IPV4="10.88.88.1"
	SERVER_WG_PORT="$(port_number_generate)"
	CLIENT_WG_IPV4="10.88.88.2"
	CLIENT_DNS_1="1.1.1.1"
	CLIENT_DNS_2="8.8.8.8"


	linux_uninstall_firewall
	linux_install_server_tools
	linux_configure_sshd_keepalive
	linux_enable_ip_forward
	install_wireguard

	create_server_if
	create_client_if
	wg-quick down ${SERVER_WG_NIC}
	wg-quick up ${SERVER_WG_NIC}

	echo
	cat /etc/wireguard/${SERVER_WG_NIC}_client
	echo
}

install



