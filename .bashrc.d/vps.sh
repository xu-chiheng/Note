# MIT License

# Copyright (c) 2024 徐持恒 Xu Chiheng

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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

linux_update_and_upgrade_system() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		apt update -y
		apt upgrade -y
		reboot
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache
		dnf update -y
		dnf upgrade -y
		reboot
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu
		reboot
	fi
}

linux_install_base_tools() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		apt install -y socat openssl iproute2
		apt remove -y iptables firewalld ufw
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		dnf install -y socat openssl iproute
		dnf remove -y iptables firewalld ufw
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu socat openssl iproute
		pacman -Ry iptables firewalld ufw
	fi
}

linux_start_and_enable_service() {
	local service="$1"

	systemctl start "${service}"
	systemctl enable "${service}"
}

linux_stop_and_disable_service() {
	local service="$1"

	systemctl stop "${service}"
	systemctl disable "${service}"
}

linux_print_default_nic() {
	ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)' | head -1
}

linux_print_ipv4_address() {
	# curl ifconfig.me
	ip addr show "$(linux_print_default_nic)" | grep 'inet ' | awk '{print $2}' | sed -E 's,/.*$,,'
}

# https://phoenixnap.com/kb/sysctl
# https://man7.org/linux/man-pages/man8/sysctl.8.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/working_with_sysctl_and_kernel_tunables
linux_sysctl_one_line() {
	local variable="$1"
	local value="$2"

	sed -i "/${variable}/d" /etc/sysctl.conf
	echo "${variable} = ${value}" >> /etc/sysctl.conf
	sysctl -w "${variable}=${value}"
}

# https://teddysun.com/489.html
# https://github.com/teddysun/across/raw/master/bbr.sh
# https://v2rayssr.com/bbr.html
# https://www.437r.com/archives/64
# https://bbr.me/bbr.html
# https://www.qinyuanyang.com/post/360.html
linux_enable_bbr() {
	linux_sysctl_one_line net.core.default_qdisc fq
	linux_sysctl_one_line net.ipv4.tcp_congestion_control bbr
	lsmod | grep bbr
}

# https://www.techrepublic.com/article/how-to-disable-ipv6-on-linux/
# https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/network-flow-analysis/23-3/installing/system-recommendations-and-requirements/linux-servers/disable-ipv6-networking-on-linux-servers.html
# https://www.geeksforgeeks.org/how-to-disable-ipv6-in-linux/
linux_disable_ipv6() {
	linux_sysctl_one_line net.ipv6.conf.all.disable_ipv6 1
	linux_sysctl_one_line net.ipv6.conf.default.disable_ipv6 1
	linux_sysctl_one_line net.ipv6.conf.lo.disable_ipv6 1
	ip a | grep inet6
}

# Enable IP forwarding
linux_enable_ip_forward() {
	linux_sysctl_one_line net.ipv4.ip_forward 1
	linux_sysctl_one_line net.ipv6.conf.all.forwarding 1
}

# https://www.cyberciti.biz/faq/linux-disable-firewall-command/
# https://www.tecmint.com/start-stop-disable-enable-firewalld-iptables-firewall/
# disable_firwall() {
# 	if which firewalld; then
# 		linux_stop_and_disable_service firewalld
# 	elif which ufw; then
# 		linux_stop_and_disable_service ufw
# 	elif which iptables; then
# 		linux_stop_and_disable_service iptables
# 	fi
# }

# https://docs.aws.amazon.com/linux/al2023/ug/disable-option-selinux.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux
linux_disable_selinux() {
	if [ -f /etc/selinux/config ]; then
		sed -i -E 's/^SELINUX=.*$/SELINUX=disabled/g' /etc/selinux/config
		# after reboot
		# getenforce
	fi
}
