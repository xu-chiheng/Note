

# https://www.wireguard.com/install/
install_wireguard() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt update \
		&& apt install -y wireguard
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache \
		&& dnf install -y wireguard-tools
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu wireguard-tools
	fi
}

