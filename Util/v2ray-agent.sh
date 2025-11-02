#!/usr/bin/env -S bash -i

# Xray、Tuic、hysteria2、sing-box 八合一一键脚本
# https://github.com/mack-a/v2ray-agent

# 2024年9月 科学上网部署八合一一键脚本 Sing-box Hysteria2 Tuic naive 总有一款适合你
# https://www.youtube.com/watch?v=6adWz-rNd9M

# 史上最强 8协议合1 一键脚本 想用哪个就用哪个 搭建节点 科学上网 Sing-box Hysteria2 Tuic Naive
# https://www.youtube.com/watch?v=9pQzYyY3yy8

# sing box一键安装脚本，一键搭建，支持vless、vmess、hysteria2、tuic协议，功能完善、搭建简单，对刚接触的小伙伴也非常友好，脚本稳定性也特别高，值得了解#一瓶奶油
# https://www.youtube.com/watch?v=NBsPCRTr76A

setup() {
	local install_script="https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh"
	bash <(wget -qO- "${install_script}")
	# bash <(curl -Ls "${install_script}")
}

setup
