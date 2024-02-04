
# https://github.com/teddysun/across
# https://github.com/hwdsl2/wireguard-install

# https://www.wireguard.com/quickstart/

print_ipv4_address() {
	curl ifconfig.me
}

print_default_nic() {
	ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1
}

port_number_generate() {
	shuf -i 10000-65535 -n 1
}

install_base_tools() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt update \
		&& apt install -y iproute2
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache \
		&& dnf install -y iproute
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu iproute
	fi
}

# https://www.wireguard.com/install/
install_wireguard() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt install -y wireguard
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf install -y wireguard-tools
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu wireguard-tools
	fi
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
	SERVER_PUB_IPV4="$(print_ipv4_address)"
	SERVER_PUB_NIC="$(print_default_nic)"
	SERVER_WG_NIC="wg0"
	SERVER_WG_IPV4="10.88.88.1"
	SERVER_WG_PORT="$(port_number_generate)"
	CLIENT_WG_IPV4="10.88.88.2"
	CLIENT_DNS_1="1.1.1.1"
	CLIENT_DNS_2="8.8.8.8"


	install_base_tools
	install_wireguard

	wg-quick down ${SERVER_WG_NIC}
	create_server_if
	create_client_if
	wg-quick up ${SERVER_WG_NIC}

	echo
	cat /etc/wireguard/${SERVER_WG_NIC}_client
	echo
}

install



