#!/usr/bin/env -S bash -i

# Works on Debian 12, Ubuntu 22.04 LTS, Fedora 38-41, Rocky Linux 8-9 at 2025-04-11

# VMess
# https://guide.v2fly.org/basics/vmess.html

# WebSocket + TLS + Web
# https://guide.v2fly.org/advanced/wss_and_web.html

# Xray core
# https://github.com/XTLS/Xray-core
# https://xtls.github.io

# v2fly core
# https://github.com/v2fly/v2ray-core
# https://www.v2fly.org
# https://www.v2ray.com

# sing-box
# The universal proxy platform.
# https://sing-box.sagernet.org/
# https://github.com/SagerNet/sing-box

# Caddy
# https://github.com/caddyserver/caddy

# NGINX
# https://github.com/nginx/nginx

# v2rayN
# A V2Ray client for Windows, support Xray core and v2fly core
# https://github.com/2dust/v2rayN

# v2rayNG
# A V2Ray client for Android, support Xray core and v2fly core
# https://github.com/2dust/v2rayNG

# An ACME Shell script: acme.sh
# https://github.com/acmesh-official/acme.sh

# Automatic Certificate Management Environment
# https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment

# What is ACME protocol and how does it work?
# https://www.keyfactor.com/blog/what-is-acme-protocol-and-how-does-it-work/

# Automated Certificate Management Environment (ACME) Explained
# https://sectigo.com/resource-library/what-is-acme-protocol


# 节点搭建系列(5)：最稳定的翻墙方式？深入浅出VMESS+WS+TLS+WEB原理与搭建，Vmess节点还推荐吗？vmess和v2ray是什么关系？为什么vmess和系统时间有关？额外ID是个啥？
# https://www.youtube.com/watch?v=y8s5UivMNcE

# 节点搭建系列(6)：XTLS性能之王被精准识别？VLESS+XTLS+回落原理与搭建，V2Ray和Xray为何分家？VLESS、V2Ray、Xray、XTLS之间的关系，VLESS和trojan的关系
# https://www.youtube.com/watch?v=7GHh91AYAmM

# 节点搭建系列(8)：如何不花钱提升你的节点速度？使用CF的免费CDN服务提升节点速度，bbr拥塞控制优化链路速度，CDN的原理、CF优选IP的原理，vless+ws+tls+web+cdn节点组合搭建
# https://www.youtube.com/watch?v=Azj8-1rdF-o

# 【零基础】最新保姆级纯小白节点搭建教程，人人都能学会，目前最简单、最安全、最稳定的专属节点搭建方法，手把手自建节点搭建教学，晚高峰高速稳定，4K秒开的科学上网线路体验
# https://www.youtube.com/watch?v=SpxTFes1B8U

# 【进阶•代理模式篇】看懂就能解决99%的代理问题，详解系统代理、TUN/TAP代理、真VPN代理，clash/v2ray/singbox 虚拟网卡怎么接管系统全局流量？什么是真正的VPN？看完就知道了
# https://www.youtube.com/watch?v=qItL005LUik&t=785s

# V2Ray保姆级小白进阶教程 Websocket + TLS + Cloudflare CDN 免费中转拯救被墙IP
# https://www.youtube.com/watch?v=TWJZ30L1NRk

# 自建永不被墙的节点！给节点套上CDN中转、开启超强防护！Vless+WS+TLS+CDN科学上网、翻墙节点搭建保姆级教程/借助CloudFlare给节点套上CDN
# https://www.youtube.com/watch?v=eqYL6P6T9sU

# 2023年自用稳定 v2ray vless+ws+tls+nginx+website #v2ray #vless #v2ray节点
# https://www.youtube.com/watch?v=Xbou8S70W0w

# 官方脚本手动搭建 v2ray 节点 websocket + tls + web 科学上网
# https://www.youtube.com/watch?v=KKf-3R4Hxvg

# V2ray官方搭建V2ray+WS+TLS+Nginx+web前端, 特殊时期为你网络保驾护航！目前安全系数最高的配置方法，告别来路不明一键安装脚本
# https://www.youtube.com/watch?v=JQWaZp-UbIc

# V2ray官方搭建 V2ray+WS+TCP+TLS底层传输加密，谷歌云搭建纯净官方V2ray，告别一键安装脚本
# https://www.youtube.com/watch?v=dt8Ngw2vz-g



# v2rayN has Tun mode(using sing-box as virtual NIC), using which, all non-browser apps(SSH git curl wget FileZilla WinSCP),
# having different ways to setting Socks/HTTP proxy, do not need to set Socks/HTTP proxy in config files or by some GUI configuration.
# Tun mode is not as stable as Socks/HTTP proxy mode, "Turn on Sniffing" must be ON
# But Tor Browser require "Turn on Sniffing" to be OFF, this conflicts with Tun mode.
# The solution is setting "Turn on Sniffing" to be OFF only when using Tor Browser.

# v2rayN 7.10.5 2025-03 Settings

# Settings --> Option Setting --> Core basic settings
# Turn on Sniffing       ON or OFF       ON to make "Tun mode" work, OFF to make "Tor Browser" to connect, no way to let them both work.

# Settings --> Option Setting --> v2rayN settings
# Start on boot          ON
# Auto hide startup      ON

# Toolbar at bottom
# Enable Tun             ON or OFF
# System proxy           Set system proxy
# Routing                V3 Global

# Tor Browser
# "Tor Network Settings", check "I use a proxy to connect to the Internet",
# Proxy Type "HTTP/HTTPS", Address "127.0.0.1", Port "10809".

# 通过v2rayN不能使用TOR浏览器 #360
# https://github.com/2dust/v2rayN/issues/360
# 这是sniffing的问题，关闭sniffing即可。
# v2ray有一个sniffing功能，它可以检测http和tls流量中的域名并把它提取出来交给vps解析，然后把这些流量的数据包的目的地址重写为解析所得的地址。其本意是解决dns污染的问题，但因为tor连接用了一些不寻常的方式(比如域名和ip不匹配等)，所以此功能反而会使连接失败。



# 多个地点Ping服务器,网站测速 - 站长工具
# https://ping.chinaz.com

# The trusted source for IP address data
# https://ipinfo.io


# Pixelscan - Revealing the Web's Data Harvest
# https://pixelscan.net
# What personal information do websites collect - alternative Pixelscan
# https://gologin.com/pixelscan
# My Fingerprint- Am I Unique ?
# https://amiunique.org/fingerprint

# IP Reputation Check
# https://www.ipqualityscore.com/ip-reputation-check
# Scamalytics provide security products to businesses, to help them detect and prevent fraud.
# https://scamalytics.com

# https://www.ip123.in
# https://whoer.net

# VPS need to disable ipv6 ?

how_to_use_this_script() {
	# VPS SSH login as root
	# git remote set-url origin git@github.com:xu-chiheng/Note.git
	cd ~
	rm -rf .git Note .bashrc.d Util
	git clone https://github.com/xu-chiheng/Note -b main
	mv Note/.git ./
	rm -rf Note
	git reset --hard HEAD
	Util/xray-nginx.sh

	# 4. 安装Xray-VMESS+WS+TLS(推荐)
	# 12. 卸载Xray
}


getData() {
	echo
	echo " Xray一键脚本，运行之前请确认如下条件已经具备："
	echo "  1. 一个伪装域名"
	echo "  2. 伪装域名DNS解析指向当前服务器ip（${IP}）"
	echo
	while true
	do
		read -p " 请输入伪装域名：" DOMAIN
		if [ -z "${DOMAIN}" ]; then
			echo " 域名输入错误，请重新输入！"
		else
			break
		fi
	done
	DOMAIN="${DOMAIN,,}"

	if [ "$(linux_resolve_hostname "${DOMAIN}")" != "${IP}" ]; then
		echo "伪装域名${DOMAIN}不指向${IP}"
		exit 1
	fi
	echo " 伪装域名(host)：${DOMAIN}"
}

# DeepSeek-R1 使用ACME脚本如何保证自动更新SSL/TLS证书？
getCert() {
	curl https://get.acme.sh | sh
	source ~/.bashrc
	~/.acme.sh/acme.sh --upgrade --auto-upgrade
	~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

	if ! [ -f ~/.acme.sh/${DOMAIN}_ecc/ca.cer ]; then
		~/.acme.sh/acme.sh --issue -d "${DOMAIN}" --keylength ec-256 --standalone
	fi

	rm -rf "${CERT_FILE}" "${KEY_FILE}"
	~/.acme.sh/acme.sh --install-cert -d "${DOMAIN}" --ecc \
		--key-file       "${KEY_FILE}" \
		--fullchain-file "${CERT_FILE}" \
		--reloadcmd "systemctl reload nginx"

	if [ ! -f "${CERT_FILE}" ] || [ ! -f "${KEY_FILE}" ]; then
		echo " 获取证书失败，请到 Github Issues 反馈"
		exit 1
	fi
}

# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
installNginx() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		apt install -y nginx
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		dnf install -y nginx
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu nginx
	fi
}

configNginx() {
	if ! backup_or_restore_file_or_dir "${NGINX_HTDOC_PATH}" \
		|| ! backup_or_restore_file_or_dir "${NGINX_CONF_PATH}"; then
		exit 1
	fi
	cat >"${NGINX_HTDOC_PATH}/robots.txt" <<EOF
User-Agent: *
Disallow: /
EOF

	# VMESS+WS+TLS
	cat >"${NGINX_CONF_PATH}/conf.d/${DOMAIN}.conf" <<EOF
server {
  listen ${PORT} ssl;
  listen [::]:${PORT} ssl;
  
  ssl_certificate       ${CERT_FILE};
  ssl_certificate_key   ${KEY_FILE};
  ssl_session_timeout 1d;
  ssl_session_cache shared:MozSSL:10m;
  ssl_session_tickets off;
  
  ssl_protocols         TLSv1.2 TLSv1.3;
  ssl_ciphers           ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
  ssl_prefer_server_ciphers off;
  
  server_name           ${DOMAIN};
  location ${WSPATH} { # 与 V2Ray 配置中的 path 保持一致
    if (\$http_upgrade != "websocket") { # WebSocket协商失败时返回404
        return 404;
    }
    proxy_redirect off;
    proxy_pass http://127.0.0.1:${XPORT}; # 假设WebSocket监听在环回地址的10000端口上
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host \$host;
    # Show real IP in v2ray access.log
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
  }
}
EOF

}

# https://github.com/XTLS/Xray-install
installXray() {
	bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
}

configXray() {
	if ! backup_or_restore_file_or_dir "${XRAY_CONF_PATH}"; then
		exit 1
	fi
	cat >"${XRAY_CONF_PATH}/config.json" <<EOF
{
  "inbounds": [
    {
      "port": ${XPORT},
      "listen":"127.0.0.1",//只监听 127.0.0.1，避免除本机外的机器探测到开放了 10000 端口
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${UUID}",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
        "path": "${WSPATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    }
  ]
}
EOF
}

install() {
	IP="$(linux_print_ipv4_address)"

	getData

	CERT_FILE=~/"${DOMAIN}.pem"
	KEY_FILE=~/"${DOMAIN}.key"

	UUID="$(linux_xray_uuid_generate)"
	PORT="$(port_number_generate)"
	XPORT="$(port_number_generate)"
	WSPATH="/$(password_generate_one)"

	linux_disable_ipv6
	linux_enable_bbr
	linux_disable_selinux
	linux_uninstall_firewall
	linux_install_vps_basic_tools

	uninstall

	getCert

	installNginx
	configNginx
	linux_start_and_enable_service nginx

	installXray
	configXray
	linux_start_and_enable_service xray

	outputVmessWS

	reboot
}

uninstall() {
	linux_stop_and_disable_service nginx
	linux_stop_and_disable_service xray
	rm -rf ~/*.pem ~/*.key
	rm -rf ~/.acme.sh
	git reset --hard HEAD
}

outputVmessWS() {
	local raw=$(cat <<EOF
{
  "v": "2",
  "ps": "",
  "add": "${IP}",
  "port": "${PORT}",
  "id": "${UUID}",
  "aid": "0",
  "net": "ws",
  "type": "none",
  "host": "${DOMAIN}",
  "path": "${WSPATH}",
  "tls": "tls"
}
EOF
)
	local link="vmess://$(echo -n ${raw} | base64 -w 0)"

	echo  
	echo  
	echo "   IP(address)           : ${IP}"
	echo "   端口(port)            : ${PORT}"
	echo "   id(uuid)              : ${UUID}"
	echo "   额外id(alterid)       : 0"
	echo "   加密方式(security)    : none"
	echo "   传输协议(network)     : ws" 
	echo "   伪装类型(type)        : none"
	echo "   伪装域名/主机名(host) : ${DOMAIN}"
	echo "   路径(path)            : ${WSPATH}"
	echo "   底层安全传输(tls)     : tls"
	echo  
	echo "   vmess链接 : $link"
	echo
	echo
}

menu() {
	clear
	echo "#############################################################"
	echo "#                    Xray 一键安装脚本                      #"
	echo "# 作者: MisakaNo の 小破站                                  #"
	echo "# 博客: https://blog.misaka.rest                            #"
	echo "# GitHub 项目: https://github.com/Misaka-blog/xray-script   #"
	echo "# GitLab 项目: https://gitlab.com/Misaka-blog/xray-script   #"
	echo "# Telegram 频道: https://t.me/misakanocchannel              #"
	echo "# Telegram 群组: https://t.me/misakanoc                     #"
	echo "# YouTube 频道: https://www.youtube.com/@misaka-blog        #"
	echo "#############################################################"
	echo ""
	echo " 4. 安装Xray-VMESS+WS+TLS(推荐)"
	echo " -------------"
	echo " 12. 卸载Xray"
	echo " -------------"
	echo " 0. 退出"
	echo 

	XRAY_CONF_PATH="/usr/local/etc/xray"
	NGINX_CONF_PATH="/etc/nginx"
	NGINX_HTDOC_PATH="/usr/share/nginx/html"

	read -p " 请选择操作[0-17]：" answer
	case "${answer}" in
		4)
			install
			;;
		12)
			uninstall
			;;
		*)
			echo " 请选择正确的操作！"
			exit 1
			;;
	esac
}

menu


