#!/bin/bash


# https://www.geeksforgeeks.org/create-a-password-generator-using-shell-scripting/
# https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
# https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
password_generate() {
	# openssl rand -help
	# openssl rand -base64 48
	# openssl rand -hex 64
	tr -cd '[:alnum:]' < /dev/urandom | fold -w100 | head -n1
}

# https://stackoverflow.com/questions/2556190/random-number-from-a-range-in-a-bash-script
port_number_generate() {
	shuf -i 2000-65000 -n 1
}

ray_uuid_generate() {
	cat '/proc/sys/kernel/random/uuid'
}

install_base_tools() {
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt update \
		&& apt install -y openssl cron socat curl
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf makecache \
		&& dnf install -y openssl cron socat curl
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu openssl cron socat curl
	fi
}

start_and_enable_service() {
	local service="$1"

	systemctl start "${service}" \
	&& systemctl enable "${service}"
}

stop_and_disable_service() {
	local service="$1"

	systemctl stop "${service}" \
	&& systemctl disable "${service}"
}

print_ipv4_address() {
	curl ifconfig.me
}

# https://github.com/teddysun/across/raw/master/bbr.sh
enable_bbr() {
    sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
    sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
    echo "net.core.default_qdisc = fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control = bbr" >> /etc/sysctl.conf
    sysctl -p >/dev/null 2>&1
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
		if [[ -z "${DOMAIN}" ]]; then
			echo " 域名输入错误，请重新输入！"
		else
			break
		fi
	done
	DOMAIN=${DOMAIN,,}
	echo " 伪装域名(host)：${DOMAIN}"
}

# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
# /etc/nginx/nginx.conf
install_nginx() {
	if which nginx; then
		return 0
	fi
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt install -y nginx
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf install -y nginx
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu nginx
	fi
}

getCert() {
	mkdir -p /usr/local/etc/xray \
	&& curl https://get.acme.sh | sh \
	&& source ~/.bashrc \
	&& ~/.acme.sh/acme.sh --upgrade  --auto-upgrade \
	&& ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt \
	&& if ! [[ -f ~/.acme.sh/${DOMAIN}_ecc/ca.cer ]]; then
		~/.acme.sh/acme.sh --issue -d "${DOMAIN}" --keylength ec-256 --standalone
	fi \
	&& ~/.acme.sh/acme.sh --install-cert -d "${DOMAIN}" --ecc \
		--key-file       "${KEY_FILE}"  \
		--fullchain-file "${CERT_FILE}" \
	&& if ! [[ -f "${CERT_FILE}" && -f "${KEY_FILE}" ]]; then
		echo " 获取证书失败，请到 Github Issues 反馈"
		exit 1
	fi
}

configNginx() {
	rm -rf "${NGINX_CONF_PATH}"
	mkdir -p /usr/share/nginx/html;
cat > /usr/share/nginx/html/robots.txt <<EOF
User-Agent: *
Disallow: /
EOF

	if [[ ! -f /etc/nginx/nginx.conf.bak ]]; then
		mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
	fi
	if ! id nginx 2>/dev/null; then
		user="www-data"
	else
		user="nginx"
	fi
	cat > /etc/nginx/nginx.conf<<EOF
user $user;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    server_tokens off;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    gzip                on;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
}
EOF

	mkdir -p ${NGINX_CONF_PATH}
	# VMESS+WS+TLS
	cat > ${NGINX_CONF_PATH}/${DOMAIN}.conf<<EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN};
    return 301 https://\$server_name:${PORT}\$request_uri;
}

server {
    listen       ${PORT} ssl http2;
    listen       [::]:${PORT} ssl http2;
    server_name ${DOMAIN};
    charset utf-8;

    # ssl配置
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_ecdh_curve secp384r1;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    ssl_certificate ${CERT_FILE};
    ssl_certificate_key ${KEY_FILE};

    root /usr/share/nginx/html;
    location / {

    }
    location = /robots.txt {}

    location ${WSPATH} {
      proxy_redirect off;
      proxy_pass http://127.0.0.1:${XPORT};
      proxy_http_version 1.1;
      proxy_set_header Upgrade \$http_upgrade;
      proxy_set_header Connection "upgrade";
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

}

setSelinux() {
	if [[ -f /etc/selinux/config ]] && grep 'SELINUX=enforcing' /etc/selinux/config; then
		sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
		setenforce 0
	fi
}

setFirewall() {
	if which firewall-cmd 2>/dev/null; then
		if systemctl status firewalld >/dev/null 2>&1; then
			firewall-cmd --permanent --add-service=http
			firewall-cmd --permanent --add-service=https
			if [[ "$PORT" != "443" ]]; then
				firewall-cmd --permanent --add-port=${PORT}/tcp
				firewall-cmd --permanent --add-port=${PORT}/udp
			fi
			firewall-cmd --reload
		else
			if [[ "$(iptables -nL | nl | grep FORWARD | awk '{print $1}')" != "3" ]]; then
				iptables -I INPUT -p tcp --dport 80 -j ACCEPT
				iptables -I INPUT -p tcp --dport 443 -j ACCEPT
				if [[ "$PORT" != "443" ]]; then
					iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
					iptables -I INPUT -p udp --dport ${PORT} -j ACCEPT
				fi
			fi
		fi
	elif which iptables 2>/dev/null; then
		if [[ "$(iptables -nL | nl | grep FORWARD | awk '{print $1}')" != "3" ]]; then
			iptables -I INPUT -p tcp --dport 80 -j ACCEPT
			iptables -I INPUT -p tcp --dport 443 -j ACCEPT
			if [[ "$PORT" != "443" ]]; then
				iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
				iptables -I INPUT -p udp --dport ${PORT} -j ACCEPT
			fi
		fi
	elif which ufw 2>/dev/null; then
		res="$(ufw status | grep -i inactive)"
		if [[ "$res" = "" ]]; then
			ufw allow http/tcp
			ufw allow https/tcp
			if [[ "$PORT" != "443" ]]; then
				ufw allow ${PORT}/tcp
				ufw allow ${PORT}/udp
			fi
		fi
	fi
}

installXray() {
	bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
}

vmessWSConfig() {
	cat > $CONFIG_FILE<<EOF
{
  "inbounds": [{
    "port": $XPORT,
    "listen": "127.0.0.1",
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "$UUID",
          "level": 1,
          "alterId": 0
        }
      ],
      "disableInsecureEncryption": false
    },
    "streamSettings": {
        "network": "ws",
        "wsSettings": {
            "path": "$WSPATH",
            "headers": {
                "Host": "$DOMAIN"
            }
        }
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }]
}
EOF
}

configXray() {
	mkdir -p /usr/local/xray
	vmessWSConfig
}

install() {
	IP="$(print_ipv4_address)"

	getData

	CONFIG_FILE="/usr/local/etc/xray/config.json"
	NGINX_CONF_PATH="/etc/nginx/conf.d"
	CERT_FILE="/usr/local/etc/xray/${DOMAIN}.pem"
	KEY_FILE="/usr/local/etc/xray/${DOMAIN}.key"
	UUID="$(ray_uuid_generate)"
	PORT="$(port_number_generate)"
	XPORT="$(port_number_generate)"
	WSPATH="/$(password_generate)"

	uninstall
	install_base_tools
	enable_bbr
	setSelinux
	setFirewall
	getCert

	install_nginx
	configNginx
	start_and_enable_service nginx

	installXray
	configXray
	start_and_enable_service xray

	outputVmessWS
}

uninstall() {
	if which nginx >/dev/null 2>&1 && systemctl status nginx >/dev/null 2>&1; then
		stop_and_disable_service nginx
	fi
	if which xray >/dev/null 2>&1 && systemctl status xray >/dev/null 2>&1; then
		stop_and_disable_service xray
	fi
}

outputVmessWS() {
	local raw="{
  \"v\":\"2\",
  \"ps\":\"\",
  \"add\":\"${IP}\",
  \"port\":\"${PORT}\",
  \"id\":\"${UUID}\",
  \"aid\":\"0\",
  \"net\":\"ws\",
  \"type\":\"none\",
  \"host\":\"${DOMAIN}\",
  \"path\":\"${WSPATH}\",
  \"tls\":\"tls\"
}"

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
