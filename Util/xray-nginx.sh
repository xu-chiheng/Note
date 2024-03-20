#!/usr/bin/env -S bash -i

# Works on Debian 12, Ubuntu 22.04 LTS, Fedora 38-39, Rocky Linux 8-9 at 2024-02-07

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



# V2ray搭建教程，操作简单！支持伪装vmess+ws+tls和vless+tcp+xtls|vps服务器搭建v2ray节点|vpn搭建方式 2022
# https://www.youtube.com/watch?v=sovN5c7E8MY

# V2Ray进阶篇2：V2Ray+Websocket+TLS+Cloudflare拯救被墙的IP/复活你的VPS/隐藏真实IP/最安全的科学上网方式/V2Ray如何套上CDN加强安全性
# https://www.youtube.com/watch?v=-GH7DOlqe-M

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


# v2rayN 6.29 设置

# Core基础设置
# 开启UDP      OFF
# 开启流量探测  OFF

# v2rayN设置
# 开机启动      ON
# 启动后隐藏窗口 ON

# 启用Tun模式  ON  虚拟网卡


# Tor Browser双重代理配置（分别以v2rayN、无界、自由门作前置代理为例）
# https://www.youtube.com/watch?v=IKuRpKPTEHs

# 2022年最新暗网进入方法！什么是暗网暗网有什么如何使用科学上网工具访问暗网暗网怎么进2022丨暗网网址丨dark web 2022丨By工具大师i
# https://www.youtube.com/watch?v=qob8gqQ2_3k
# 1.打开v2rayN，在“参数设置”中关闭“开启流量探测”选项
# 2.打开Tor Browser，在“Tor Network Settings”，勾选“I use a proxy to connect to the Internet”, 
# Proxy Type选择“HTTP/HTTPS”，Address为“127.0.0.1”，Port为“10809”。点击Connect连接。

# 通过v2rayN不能使用TOR浏览器 #360
# https://github.com/2dust/v2rayN/issues/360
# 这是sniffing的问题，关闭sniffing即可。
# v2ray有一个sniffing功能，它可以检测http和tls流量中的域名并把它提取出来交给vps解析，然后把这些流量的数据包的目的地址重写为解析所得的地址。其本意是解决dns污染的问题，但因为tor连接用了一些不寻常的方式(比如域名和ip不匹配等)，所以此功能反而会使连接失败。
# 目前v2rayn还不能设置关闭sniffing,想关闭sniffing只能手动编辑配置文件。


# 多个地点Ping服务器,网站测速 - 站长工具
# https://ping.chinaz.com


# VPS 需要 disable ipv6
# "自定义反代站点"设置为 https://www.baidu.com

how_to_use_this_script() {
	# VPS SSH login as root
	# git remote set-url origin git@github.com:xu-chiheng/Note.git
	cd ~
	rm -rf .git Note
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
	DOMAIN=${DOMAIN,,}

	if [ "$(linux_resolve_hostname "${DOMAIN}")" != "${IP}" ]; then
		echo "伪装域名${DOMAIN}不指向${IP}"
		exit 1
	fi
	echo " 伪装域名(host)：${DOMAIN}"
}

getCert() {
	curl https://get.acme.sh | sh
	source ~/.bashrc
	~/.acme.sh/acme.sh --upgrade --auto-upgrade
	~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

	if ! [ -f ~/.acme.sh/${DOMAIN}_ecc/ca.cer ]; then
		~/.acme.sh/acme.sh --issue -d "${DOMAIN}" --keylength ec-256 --standalone
	fi

	mkdir -p /usr/local/etc/xray
	rm -rf "${CERT_FILE}" "${KEY_FILE}"
	~/.acme.sh/acme.sh --install-cert -d "${DOMAIN}" --ecc \
		--key-file       "${KEY_FILE}" \
		--fullchain-file "${CERT_FILE}"

	if ! { [ -f "${CERT_FILE}" ] && [ -f "${KEY_FILE}" ] ;}; then
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
	if ! backup_or_restore_file_or_dir /usr/share/nginx/html \
		|| ! backup_or_restore_file_or_dir /etc/nginx; then
		exit 1
	fi
	cat > /usr/share/nginx/html/robots.txt <<EOF
User-Agent: *
Disallow: /
EOF

	rm -rf "${NGINX_CONF_PATH}"
	mkdir -p "${NGINX_CONF_PATH}"
	# VMESS+WS+TLS
	cat >"${NGINX_CONF_PATH}/${DOMAIN}.conf" <<EOF
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

installXray() {
	bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
}

configXray() {
	mkdir -p /usr/local/etc/xray
	cat >"${CONFIG_FILE}" <<EOF
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

	CONFIG_FILE="/usr/local/etc/xray/config.json"
	NGINX_CONF_PATH="/etc/nginx/conf.d"
	CERT_FILE="/usr/local/etc/xray/${DOMAIN}.pem"
	KEY_FILE="/usr/local/etc/xray/${DOMAIN}.key"
	UUID="$(xray_uuid_generate)"
	PORT="$(port_number_generate)"
	XPORT="$(port_number_generate)"
	WSPATH="/$(password_generate_one)"

	linux_disable_ipv6
	linux_enable_bbr
	linux_disable_selinux

	uninstall
	linux_uninstall_firewall
	linux_install_vps_basic_tools
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
	rm -rf /usr/local/etc/xray
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

	read -p " 请选择操作[0-17]：" answer
	case $answer in
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


