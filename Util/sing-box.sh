#!/usr/bin/env -S bash -i

# Sing-box 全家桶 --- 一键多协议脚本
# https://github.com/fscarmen/sing-box
# https://www.youtube.com/@fscarmen

setup() {
	local install_script="https://raw.githubusercontent.com/fscarmen/sing-box/main/sing-box.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
