



# https://stackoverflow.com/questions/2556190/random-number-from-a-range-in-a-bash-script
port_number_generate() {
	local start="$1"
	if [ -z "${start}" ]; then
		start=10000
	fi 
	shuf -i "${start}"-65535 -n 1
}

xray_uuid_generate() {
	cat '/proc/sys/kernel/random/uuid'
}

upate_system_and_install_download_tools() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt update -y
		apt upgrade -y
		apt install -y git curl wget
		reboot
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache
		dnf update -y
		dnf upgrade -y
		dnf install -y git curl wget
		reboot
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu git curl wget
		reboot
	fi
}

install_base_tools() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt update
		apt install -y socat openssl cron curl iproute2
		apt remove -y iptables firewalld ufw
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache
		dnf install -y socat openssl curl iproute
		dnf remove -y iptables firewalld ufw
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu socat openssl cron curl iproute
	fi
}

start_and_enable_service() {
	local service="$1"

	systemctl start "${service}"
	systemctl enable "${service}"
}

stop_and_disable_service() {
	local service="$1"

	systemctl stop "${service}"
	systemctl disable "${service}"
}

print_default_nic() {
	ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1
}

print_ipv4_address() {
	# curl ifconfig.me
	ip addr show "$(print_default_nic)" | grep 'inet ' | awk '{print $2}' | sed -E 's,/.*$,,'
}

# https://teddysun.com/489.html
# https://github.com/teddysun/across/raw/master/bbr.sh
# https://v2rayssr.com/bbr.html
# https://www.437r.com/archives/64
# https://bbr.me/bbr.html
# https://www.qinyuanyang.com/post/360.html
enable_bbr() {
	sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
	echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
	sysctl -p
	lsmod | grep bbr
}

# https://www.techrepublic.com/article/how-to-disable-ipv6-on-linux/
# https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/network-flow-analysis/23-3/installing/system-recommendations-and-requirements/linux-servers/disable-ipv6-networking-on-linux-servers.html
# https://www.geeksforgeeks.org/how-to-disable-ipv6-in-linux/
disable_ipv6() {
	sed -i '/net.ipv6.conf.all.disable_ipv6/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.default.disable_ipv6/d' /etc/sysctl.conf
	sed -i '/net.ipv6.conf.lo.disable_ipv6/d' /etc/sysctl.conf
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
	sysctl -p
	ip a | grep inet6
}

# Enable IP forwarding
enable_ip_forward() {
    echo "Enable IP forward"
    sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    sed -i '/net.ipv6.conf.all.forwarding/d' /etc/sysctl.conf
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    echo "net.ipv6.conf.all.forwarding = 1" >> /etc/sysctl.conf
    sysctl -p
}

# https://www.cyberciti.biz/faq/linux-disable-firewall-command/
# https://www.tecmint.com/start-stop-disable-enable-firewalld-iptables-firewall/
disable_firwall() {
	if which firewalld; then
		stop_and_disable_service firewalld
	elif which ufw; then
		stop_and_disable_service ufw
	elif which iptables; then
		stop_and_disable_service iptables
	fi
}

# https://docs.aws.amazon.com/linux/al2023/ug/disable-option-selinux.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux
disable_selinux() {
	if [ -f /etc/selinux/config ]; then
		sed -i -E 's/^SELINUX=.*$/SELINUX=disabled/g' /etc/selinux/config
		# after reboot
		# getenforce
	fi
}
