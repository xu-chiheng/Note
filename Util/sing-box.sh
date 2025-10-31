#!/usr/bin/env -S bash -i

# Sing-box 全家桶 --- 一键多协议脚本
# https://github.com/fscarmen/sing-box

____how_to_use_this_script____() {
	# VPS SSH login as root
	cd ~
	rm -rf .git Note .bashrc.d Util
	git clone https://github.com/xu-chiheng/Note -b main
	mv Note/.git ./
	rm -rf Note
	git reset --hard HEAD
	Util/sing-box.sh
}
unset -f ____how_to_use_this_script____

setup() {
	time_command linux_server_common_setup

	local install_script="https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
