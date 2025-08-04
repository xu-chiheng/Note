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
	echo "Attempting to uninstall common firewall tools..."
	if check_command_existence apt; then
		echo "Detected APT-based system (Debian/Ubuntu)"
		apt remove -y iptables firewalld ufw nftables
	elif check_command_existence dnf; then
		echo "Detected DNF-based system (Fedora/RHEL)"
		dnf remove -y iptables firewalld ufw nftables
	elif check_command_existence pacman; then
		echo "Detected Pacman-based system (Arch/Manjaro)"
		pacman -Rns --noconfirm iptables firewalld ufw nftables
	else
		echo "Unsupported package manager"
		return 1
	fi
	echo "Firewall tools uninstalled successfully."
}

linux_install_server_tools() {
	echo "Installing basic server tools..."
	if check_command_existence apt; then
		echo "Detected APT-based system (Debian/Ubuntu)"
		apt install -y tar socat openssl iproute2
	elif check_command_existence dnf; then
		echo "Detected DNF-based system (Fedora/RHEL)"
		dnf install -y tar socat openssl iproute
	elif check_command_existence pacman; then
		echo "Detected Pacman-based system (Arch/Manjaro)"
		pacman -Syu --noconfirm tar socat openssl iproute2
	else
		echo "Unsupported package manager"
		return 1
	fi
	echo "Basic server tools installed successfully."
}

linux_configure_sshd_keepalive() {
	local sshd_config="/etc/ssh/sshd_config"
	sed -Ei -e '/^\s*(ClientAliveInterval|ClientAliveCountMax)\s+.*$/d' "${sshd_config}"
	cat >>"${sshd_config}" <<EOF
ClientAliveInterval 60
ClientAliveCountMax 3
EOF
	# wait reboot
	# systemctl reload sshd
}

linux_start_and_enable_service() {
	local service="$1"

	if ! systemctl is-active --quiet "${service}"; then
		systemctl start "${service}"
	fi
	if ! systemctl is-enabled --quiet "${service}"; then
		systemctl enable "${service}"
	fi
}

linux_stop_and_disable_service() {
	local service="$1"

	if systemctl is-active --quiet "${service}"; then
		systemctl stop "${service}";
	fi
	if systemctl is-enabled --quiet "${service}"; then
		systemctl disable "${service}"
	fi
}

# Function to get the default network interface
linux_print_default_nic() {
	ip route show default | awk '{print $5}' | head -1
}

# Function to get the IPv4 address of the default network interface
linux_print_ipv4_address() {
	ip -4 addr show "$(linux_print_default_nic)" \
		| awk '/inet / {print $2}' \
		| cut -d/ -f1 \
		| head -1
}

# https://unix.stackexchange.com/questions/20784/how-can-i-resolve-a-hostname-to-an-ip-address-in-a-bash-script
# https://www.baeldung.com/linux/bash-script-resolve-hostname
linux_resolve_hostname() {
	local hostname="$1"
	getent ahosts "$hostname" | awk '/STREAM/ {print $1; exit}'
}

# https://phoenixnap.com/kb/sysctl
# https://man7.org/linux/man-pages/man8/sysctl.8.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/kernel_administration_guide/working_with_sysctl_and_kernel_tunables
linux_sysctl_one_line() {
	local variable="$1"
	local value="$2"
	local sysctl_config="/etc/sysctl.conf"

	# Validate inputs
	if [[ -z "$variable" || -z "$value" ]]; then
		echo "Usage: linux_sysctl_one_line <variable> <value>"
		return 1
	fi

	# Remove existing line for the variable (ignoring comments)
	sed -Ei "/^\s*${variable}\s*=.*$/d" "$sysctl_config"

	# Add the new setting
	echo "${variable} = ${value}" >> "$sysctl_config"

	# Apply it immediately
	if sysctl -w "${variable}=${value}"; then
		echo "Set ${variable} = ${value} successfully."
	else
		echo "Failed to set ${variable} at runtime."
		return 1
	fi
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
	lsmod | grep -E bbr
}

# https://www.techrepublic.com/article/how-to-disable-ipv6-on-linux/
# https://techdocs.broadcom.com/us/en/ca-enterprise-software/it-operations-management/network-flow-analysis/23-3/installing/system-recommendations-and-requirements/linux-servers/disable-ipv6-networking-on-linux-servers.html
# https://www.geeksforgeeks.org/how-to-disable-ipv6-in-linux/
# linux_disable_ipv6() {
# 	linux_sysctl_one_line net.ipv6.conf.all.disable_ipv6 1
# 	linux_sysctl_one_line net.ipv6.conf.default.disable_ipv6 1
# 	linux_sysctl_one_line net.ipv6.conf.lo.disable_ipv6 1
# 	ip a | grep -E inet6
# }

# Enable IP forwarding
linux_enable_ip_forward() {
	linux_sysctl_one_line net.ipv4.ip_forward 1
	linux_sysctl_one_line net.ipv6.conf.all.forwarding 1
}

# https://www.cyberciti.biz/faq/linux-disable-firewall-command/
# https://www.tecmint.com/start-stop-disable-enable-firewalld-iptables-firewall/
# linux_disable_firwall() {
# 	if check_command_existence firewalld; then
# 		linux_stop_and_disable_service firewalld
# 	elif check_command_existence ufw; then
# 		linux_stop_and_disable_service ufw
# 	elif check_command_existence iptables; then
# 		linux_stop_and_disable_service iptables
# 	fi
# }

# https://docs.aws.amazon.com/linux/al2023/ug/disable-option-selinux.html
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/using_selinux/changing-selinux-states-and-modes_using-selinux
linux_disable_selinux() {
	local selinux_config="/etc/selinux/config"
	if [ -f "${selinux_config}" ]; then
		sed -Ei -e 's/^(SELINUX=).*$/\1disabled/g' "${selinux_config}"
		# after reboot
		# getenforce
	fi
}
