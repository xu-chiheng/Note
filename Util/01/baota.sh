

# https://www.bt.cn/new/download.html


install_base_tools() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt update \
		&& apt install -y curl wget
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache \
		&& dnf install -y curl wget
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu curl wget
	fi
}

install_baota() {
	if [ -f /usr/bin/curl ]; then 
		curl -sSO https://download.bt.cn/install/install_panel.sh
	else
		wget -O install_panel.sh https://download.bt.cn/install/install_panel.sh
	fi

	bash install_panel.sh ed8484bec
}

install() {
	install_base_tools
	install_baota
}


install
