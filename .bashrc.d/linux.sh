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

linux_xray_uuid_generate() {
	cat '/proc/sys/kernel/random/uuid'
}

linux_uninstall_firewall() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		apt remove -y iptables firewalld ufw
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		dnf remove -y iptables firewalld ufw
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Ry iptables firewalld ufw
	fi
}

linux_install_vps_basic_tools() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		apt install -y tar socat openssl iproute2
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		dnf install -y tar socat openssl iproute
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu tar socat openssl iproute
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
	ip -4 route ls | grep default | head -1 | awk '{print $5}'
}

linux_print_ipv4_address() {
	# curl ifconfig.me
	ip addr show "$(linux_print_default_nic)" | grep 'inet ' | head -1 | awk '{print $2}' | sed -E -e 's,/.*$,,'
}

# https://unix.stackexchange.com/questions/20784/how-can-i-resolve-a-hostname-to-an-ip-address-in-a-bash-script
# https://www.baeldung.com/linux/bash-script-resolve-hostname
linux_resolve_hostname() {
	local hostname="$1"
	ping -c 1 "${hostname}" | head -1 | awk '{print $3}' | sed -E -e 's/^\(//' | sed -E -e 's/\).*$//'
}

# https://phoenixnap.com/kb/sysctl
# https://man7.org/linux/man-pages/man8/sysctl.8.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/working_with_sysctl_and_kernel_tunables
linux_sysctl_one_line() {
	local variable="$1"
	local value="$2"

	sed -i -e "/${variable}/d" /etc/sysctl.conf
	echo "${variable} = ${value}" >> /etc/sysctl.conf
	sysctl -w "${variable}=${value}"
}

# https://teddysun.com/489.html
# https://github.com/teddysun/across/raw/master/bbr.sh
# https://v2rayssr.com/bbr.html
# https://www.437r.com/archives/64
# https://bbr.me/bbr.html
# https://www.qinyuanyang.com/post/360.html
# https://www.techrepublic.com/article/how-to-enable-tcp-bbr-to-improve-network-speed-on-linux/
# https://wiki.crowncloud.net/?How_to_enable_BBR_on_Ubuntu_20_04
# https://www.hostwinds.com/tutorials/how-to-enable-googles-tcp-bbr-linux-cloud-vps
# https://www.linuxbabe.com/ubuntu/enable-google-tcp-bbr-ubuntu
# https://serverfault.com/questions/867056/tcp-congestion-control-for-ipv6-under-linux
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
# 	if quiet_command which firewalld; then
# 		linux_stop_and_disable_service firewalld
# 	elif quiet_command which ufw; then
# 		linux_stop_and_disable_service ufw
# 	elif quiet_command which iptables; then
# 		linux_stop_and_disable_service iptables
# 	fi
# }

# https://docs.aws.amazon.com/linux/al2023/ug/disable-option-selinux.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux
linux_disable_selinux() {
	if [ -f /etc/selinux/config ]; then
		sed -i -E -e 's/^(SELINUX=).*$/\1disabled/g' /etc/selinux/config
		# after reboot
		# getenforce
	fi
}
