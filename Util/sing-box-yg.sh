#!/usr/bin/env -S bash -i

# Works on Ubuntu 24.04 LTS at 2025-11-01

# Sing-box精装桶四合一协议VPS专用脚本：三大独家功能！自签/acme双证书切换、Argo固定临时双隧道（可共存）、Psiphon赛风VPN（30个国家）分流功能。Hostuno三合一代理脚本
# https://github.com/yonggekkk/sing-box-yg
# https://www.youtube.com/@ygkkk

setup() {
	local install_script="https://raw.githubusercontent.com/yonggekkk/sing-box-yg/main/sb.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
