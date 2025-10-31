#!/usr/bin/env -S bash -i

# Sing-box 全家桶 --- 一键多协议脚本
# https://github.com/fscarmen/sing-box

# Get the latest version of scripts
# bash <(wget -qO- "https://raw.githubusercontent.com/xu-chiheng/Note/main/get-latest.sh")

setup() {
	time_command linux_server_common_setup

	local install_script="https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
