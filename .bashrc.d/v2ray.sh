

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

# https://guide.v2fly.org/advanced/tls.html
install_acme_sh() {
	rm -rf ~/.acme.sh \
	&& curl  https://get.acme.sh | sh \
	&& source ~/.bashrc \
	&& ~/.acme.sh/acme.sh  --upgrade  --auto-upgrade \
	&& ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
}

ssl_certificate_issue() {
	local web_server_name="$1"
	~/.acme.sh/acme.sh --issue -d "${web_server_name}" --standalone --keylength ec-256 --force
}

ssl_certificate_renew() {
	local web_server_name="$1"
	~/.acme.sh/acme.sh --renew -d "${web_server_name}" --force --ecc
}

ssl_certificate_install() {
	local web_server_name="$1"
	local ssl_certificate_file_location="$2"
	local ssl_certificate_key_file_location="$3"
	~/.acme.sh/acme.sh --installcert -d "${web_server_name}" --ecc \
                          --fullchain-file "${ssl_certificate_file_location}" \
                          --key-file "${ssl_certificate_key_file_location}"
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

# https://guide.v2fly.org/prep/install.html
# /usr/local/bin/v2ray run -config /usr/local/etc/v2ray/config.json
install_v2ray() {
	if which v2ray; then
		return 0
	fi
	curl https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh | bash
}

# https://github.com/XTLS/Xray-install
# /usr/local/bin/xray run -config /usr/local/etc/xray/config.json
install_xray() {
	if which xray; then
		return 0
	fi
	bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
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

# https://caddyserver.com/docs/install
# /usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
install_caddy() {
	if which caddy; then
		return 0
	fi
	if which apt; then
		# Debian, Ubuntu, Raspbian
		apt install -y debian-keyring debian-archive-keyring apt-transport-https curl \
		&& curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
		&& curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
		&& apt update \
		&& apt install -y caddy
	elif which dnf; then
		# Fedora, RedHat, CentOS
		dnf install -y 'dnf-command(copr)' \
		&& dnf copr enable @caddy/caddy \
		&& dnf install -y caddy
	elif which pacman; then
		# Arch Linux, Manjaro, Parabola
		pacman -Syu caddy
	fi
}

install_wireguard() {
	true
}

print_caddy_config() {
	local web_server_name="$1"
	local web_server_port="$2"
	local web_server_document_root="$3"
	local ssl_certificate="$4"
	local ssl_certificate_key="$5"
	local ray_path="$6"
	local ray_port="$7"

	# web_server_port must be 443
	# ssl_certificate and ssl_certificate_key are not needed

	cat <<EOF

EOF
}

install_v2ray_websocket_tls_web_proxy_1() {
	install_base_tools
	install_acme_sh
	install_${ray_core_type}
	install_${web_server_type}
}

print_vmess_info_in_verbose() {
	local web_server_name="$1"
	local web_server_port="$2"
	local ray_path="$3"
	local ray_uuid="$4"

	local raw="{
  \"v\":\"2\",
  \"ps\":\"\",
  \"add\":\"0.0.0.0\",
  \"port\":\"${web_server_port}\",
  \"id\":\"${ray_uuid}\",
  \"aid\":\"0\",
  \"net\":\"ws\",
  \"type\":\"none\",
  \"host\":\"${web_server_name}\",
  \"path\":\"${ray_path}\",
  \"tls\":\"tls\"
}"

	local link="vmess://$(echo -n "${raw}" | base64 -w 0)"
	echo "web_server_name : ${web_server_name}"
	echo "web_server_port : ${web_server_port}"
	echo "ray_path        : ${ray_path}"
	echo "ray_uuid        : ${ray_uuid}"
	echo
	echo "vmess link      : ${link}"

}

install_v2ray_websocket_tls_web_proxy() {
	local web_server_name="$1"
	if [ -z "${web_server_name}" ]; then
		echo "must provide a web server name"
		return 1;
	fi

    local ray_uuid="$(ray_uuid_generate)"

	local ssl_certificate="/usr/local/etc/xray/${web_server_name}.pem"
	local ssl_certificate_key="/usr/local/etc/xray/${web_server_name}.key"
	local ray_core_type=xray # v2ray
	local web_server_type=nginx # caddy

	local ray_path="/$(password_generate)"
	local ray_port="$(port_number_generate)"


	local ray_config_file=
	case "${ray_core_type}" in
		xray )
			ray_config_file=/usr/local/etc/xray/config.json
			;;
		v2ray )
			ray_config_file=/usr/local/etc/v2ray/config.json
			;;
	esac

	local web_server_config_file=
	local web_server_port=
	case "${web_server_type}" in
		nginx )
			web_server_port="$(port_number_generate)"
			;;
		caddy )
			# must be 443
			web_server_port=443
			;;
	esac

	# install_v2ray_websocket_tls_web_proxy_1

	# mkdir -p "${web_server_document_root}"

	# case "${web_server_type}" in
	# 	nginx )
	# 		ssl_certificate_issue "${web_server_name}"
	# 		ssl_certificate_install "${web_server_name}" "${ssl_certificate}" "${ssl_certificate_key}"
	# 		;;
	# 	caddy )
	# 		# not needed
	# 		true
	# 		;;
	# esac


	print_nginx_main_config | tee /etc/nginx/nginx.conf

	print_nginx_web_server_config "${web_server_name}" "${web_server_port}" "${web_server_document_root}" \
		"${ssl_certificate}" "${ssl_certificate_key}" "${ray_path}" "${ray_port}" | tee "/etc/nginx/conf.d/${web_server_name}.conf"

	print_ray_config "${web_server_name}" "${ray_uuid}" "${ray_path}" "${ray_port}" | tee "${ray_config_file}"

	print_vmess_info_in_verbose "${web_server_name}" "${web_server_port}" "${ray_path}" "${ray_uuid}"

}

# /etc/nginx/nginx.conf
print_nginx_main_config(){
	local user=
	if id nginx; then
		user="nginx"
	else
		user="www-data"
	fi
	cat <<EOF
user ${user};
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
}

# /etc/nginx/conf.d/${web_server_name}.conf
print_nginx_web_server_config(){
	local web_server_name="$1"
	local web_server_port="$2"
	local web_server_document_root="$3"
	local ssl_certificate="$4"
	local ssl_certificate_key="$5"
	local ray_path="$6"
	local ray_port="$7"

	cat <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${web_server_name};
    return 301 https://\$server_name:${web_server_port}\$request_uri;
}

server {
    listen       ${web_server_port} ssl http2;
    listen       [::]:${web_server_port} ssl http2;
    server_name ${web_server_name};
    charset utf-8;

    # ssl配置
    ssl_protocols TLSv1.1 TLSv1.2;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
    ssl_ecdh_curve secp384r1;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    ssl_certificate ${ssl_certificate};
    ssl_certificate_key ${ssl_certificate_key};

    root ${web_server_document_root};
    location / {
        proxy_ssl_server_name on;
        proxy_pass https://maimai.sega.jp;
        proxy_set_header Accept-Encoding '';
        sub_filter "maimai.sega.jp" "${web_server_name}";
        sub_filter_once off;
    }
        location = /robots.txt {}

    location ${ray_path} {
      proxy_redirect off;
      proxy_pass http://127.0.0.1:${ray_port};
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

print_ray_config_2() {
	local web_server_name="$1"
	local ray_uuid="$2"
	local ray_path="$3"
	local ray_port="$4"

	cat <<EOF
{
  "inbounds": [{
    "port": ${ray_port},
    "listen": "127.0.0.1",
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "${ray_uuid}",
          "level": 1,
          "alterId": 0
        }
      ],
      "disableInsecureEncryption": false
    },
    "streamSettings": {
        "network": "ws",
        "wsSettings": {
            "path": "${ray_path}",
            "headers": {
                "Host": "${web_server_name}"
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
