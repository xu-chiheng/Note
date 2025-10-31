#!/usr/bin/env -S bash -i

# Xray、Tuic、hysteria2、sing-box 八合一一键脚本
# https://github.com/mack-a/v2ray-agent

setup() {
	time_command linux_server_common_setup

	local install_script="https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
