#!/usr/bin/env -S bash -i

# Xray、Tuic、hysteria2、sing-box 八合一一键脚本
# https://github.com/mack-a/v2ray-agent

____how_to_use_this_script____() {
	# VPS SSH login as root
	cd ~
	rm -rf .git Note .bashrc.d Util
	git clone https://github.com/xu-chiheng/Note -b main
	mv Note/.git ./
	rm -rf Note
	git reset --hard HEAD
	Util/v2ray-agent.sh
}
unset -f ____how_to_use_this_script____

setup() {
	time_command linux_enable_bbr
	time_command linux_disable_selinux
	time_command linux_uninstall_firewall
	time_command linux_install_server_tools
	time_command linux_configure_sshd_keepalive

	local install_script="https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
