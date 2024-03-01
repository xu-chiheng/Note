#!/usr/bin/env -S bash -i

# VMess
# https://guide.v2fly.org/basics/vmess.html
# WebSocket + TLS + Web
# https://guide.v2fly.org/advanced/wss_and_web.html

# Works on Debian 12, Ubuntu 22.04 LTS, Fedora 38-39, Rocky Linux 8-9 at 2024-02-07

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
	echo "# GitHub 项目: https://github.com/Misaka-blog               #"
	echo "# GitLab 项目: https://gitlab.com/Misaka-blog               #"
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


