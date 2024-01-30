

install_base_tools() {
	if which apt; then
		# Debian/Ubuntu:
		apt update \
		&& apt install curl
	elif which yum; then
		# CentOS/RedHat :
		yum makecache \
		&& yum install curl
	elif which dnf; then
		# Fedora:
		dnf makecache \
		&& dnf install curl
	elif which refresh; then
		# openSUSE/SUSE:
		zypper refresh \
		&& zypper install curl
	fi
}

# https://guide.v2fly.org/prep/install.html
install_v2ray() {
	curl https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh | bash \
	&& systemctl start v2ray \
	&& systemctl enable v2ray
}

# https://github.com/XTLS/Xray-install
install_xray() {
	bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install \
	&& systemctl start xray \
	&& systemctl enable xray
}


install_nginx() {
	true
}

install_caddy() {
	true
}

install_apache() {
	true
}

install_wireguard() {
	true
}

print_ssl_certificate_file_location() {
	echo "/etc/v2ray/v2ray.crt"
}

print_ssl_certificate_key_file_location() {
	echo "/etc/v2ray/v2ray.key"
}

# https://guide.v2fly.org/advanced/wss_and_web.html

print_v2ray_config() {
	local server_name="$1"
	local uuid="$2"
	local ws_path="$3"
	local ws_port="$4"

	# server_name is not needed here

	cat <<EOF
{
  "inbounds": [
    {
      "port": ${ws_port},
      "listen":"127.0.0.1",//只监听 127.0.0.1，避免除本机外的机器探测到开放了 10000 端口
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "${uuid}",
            "alterId": 0
          }
        ]
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "${ws_path}"
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

print_nginx_config() {
	local server_name="$1"
	local port="$2"
	local document_root="$3"
	local certificate="$4"
	local certificate_key="$5"
	local ws_path="$6"
	local ws_port="$7"

	cat <<EOF
server {
  listen ${port} ssl;
  listen [::]:${port} ssl;
  
  ssl_certificate       ${certificate};
  ssl_certificate_key   ${certificate_key};
  ssl_session_timeout 1d;
  ssl_session_cache shared:MozSSL:10m;
  ssl_session_tickets off;
  
  ssl_protocols         TLSv1.2 TLSv1.3;
  ssl_ciphers           ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
  ssl_prefer_server_ciphers off;
  
  server_name           ${server_name};
  location ${ws_path} { # 与 V2Ray 配置中的 path 保持一致
    if (\$http_upgrade != "websocket") { # WebSocket协商失败时返回404
        return 404;
    }
    proxy_redirect off;
    proxy_pass http://127.0.0.1:${ws_port}; # 假设WebSocket监听在环回地址的10000端口上
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

print_caddy_config() {
	local server_name="$1"
	local port="$2"
	local document_root="$3"
	local certificate="$4"
	local certificate_key="$5"
	local ws_path="$6"
	local ws_port="$7"

	# port must be 443
	# certificate and certificate_key are not needed

	cat <<EOF
# Caddy v2 (recommended)
${server_name} {
    log {
        output file /etc/caddy/caddy.log
    }
    tls {
        protocols tls1.2 tls1.3
        ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
        curves x25519
    }
    @v2ray_websocket {
        path ${ws_path}
        header Connection Upgrade
        header Upgrade websocket
    }
    reverse_proxy @v2ray_websocket localhost:${ws_port}
}
EOF
}

print_apache_config() {
	local server_name="$1"
	local port="$2"
	local document_root="$3"
	local certificate="$4"
	local certificate_key="$5"
	local ws_path="$6"
	local ws_port="$7"

	cat <<EOF
<VirtualHost *:${port}>
  DocumentRoot "${document_root}"
  ServerName ${server_name}

  SSLEngine on
  
  SSLCertificateFile ${certificate}
  SSLCertificateKeyFile ${certificate_key}
  
  SSLProtocol             all -SSLv3 -TLSv1 -TLSv1.1
  SSLCipherSuite          ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
  SSLHonorCipherOrder     off
  SSLSessionTickets       off
  
  <Location "${ws_path}/">
    ProxyPass ws://127.0.0.1:${ws_port}${ws_path}/ upgrade=WebSocket
    ProxyAddHeaders Off
    ProxyPreserveHost On
    RequestHeader append X-Forwarded-For %{REMOTE_ADDR}s
  </Location>
</VirtualHost>
EOF
}


