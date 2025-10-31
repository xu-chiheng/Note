#!/usr/bin/env -S bash -i

# Sing-box精装桶四合一协议VPS专用脚本：三大独家功能！自签/acme双证书切换、Argo固定临时双隧道（可共存）、Psiphon赛风VPN（30个国家）分流功能。Hostuno三合一代理脚本
# https://github.com/yonggekkk/sing-box-yg

____how_to_use_this_script____() {
	# VPS SSH login as root
	cd ~
	rm -rf .git Note .bashrc.d Util
	git clone https://github.com/xu-chiheng/Note -b main
	mv Note/.git ./
	rm -rf Note
	git reset --hard HEAD
	Util/sing-box-yg.sh
}
unset -f ____how_to_use_this_script____

setup() {
	time_command linux_enable_bbr
	time_command linux_disable_selinux
	time_command linux_uninstall_firewall
	time_command linux_install_server_tools
	time_command linux_configure_sshd_keepalive

	local install_script="https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh"
	wget -qO- "${install_script}" | bash
	# curl -Ls "${install_script}" | bash
}

setup
