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

print_network_interface_name() {
	ip addr show | grep -E '^[0-9]+: ' | awk '{print $2}' | grep -v -E 'lo:' | tr -d ':'
}

print_ipv4_address() {
	local interface="$(print_network_interface_name)"
	ifconfig "${interface}" | grep 'inet '| awk '{print $2}'
}


RED="\033[31m"      # Error message
GREEN="\033[32m"    # Success message
YELLOW="\033[33m"   # Warning message
BLUE="\033[36m"     # Info message
PLAIN='\033[0m'

checkSystem() {
    res=`which yum 2>/dev/null`
    if which apt; then
        PMT="apt"
        CMD_INSTALL="apt install -y "
        CMD_REMOVE="apt remove -y "
        CMD_UPGRADE="apt update; apt upgrade -y; apt autoremove -y"
    elif which dnf; then
        PMT="dnf"
        CMD_INSTALL="dnf install -y "
        CMD_REMOVE="dnf remove -y "
        CMD_UPGRADE="dnf update -y"
    elif which yum; then
        PMT="yum"
        CMD_INSTALL="yum install -y "
        CMD_REMOVE="yum remove -y "
        CMD_UPGRADE="yum update -y"
    fi
}

colorEcho() {
    echo -e "${1}${@:2}${PLAIN}"
}

status() {
    if [[ ! -f /usr/local/bin/xray ]]; then
        echo 0
        return
    fi
    if [[ ! -f $CONFIG_FILE ]]; then
        echo 1
        return
    fi
    port="$(grep port $CONFIG_FILE | head -n 1 | cut -d: -f2| tr -d \",' ')"
    res="$(ss -nutlp | grep ${port} | grep -i xray)"
    if [[ -z "$res" ]]; then
        echo 2
        return
    fi

	echo 3
}

statusText() {
    res="$(status)"
    case $res in
        2)
            echo -e ${GREEN}已安装${PLAIN} ${RED}未运行${PLAIN}
            ;;
        3)
            echo -e ${GREEN}已安装${PLAIN} ${GREEN}Xray正在运行${PLAIN}
            ;;
        4)
            echo -e ${GREEN}已安装${PLAIN} ${GREEN}Xray正在运行${PLAIN}, ${RED}Nginx未运行${PLAIN}
            ;;
        5)
            echo -e ${GREEN}已安装${PLAIN} ${GREEN}Xray正在运行, Nginx正在运行${PLAIN}
            ;;
        *)
            echo -e ${RED}未安装${PLAIN}
            ;;
    esac
}

getData() {
    if true; then
        echo ""
        echo " Xray一键脚本，运行之前请确认如下条件已经具备："
        colorEcho ${YELLOW} "  1. 一个伪装域名"
        colorEcho ${YELLOW} "  2. 伪装域名DNS解析指向当前服务器ip（${IP}）"
        echo " "
        while true
        do
            read -p " 请输入伪装域名：" DOMAIN
            if [[ -z "${DOMAIN}" ]]; then
                colorEcho ${RED} " 域名输入错误，请重新输入！"
            else
                break
            fi
        done
        DOMAIN=${DOMAIN,,}
        colorEcho ${BLUE}  " 伪装域名(host)：$DOMAIN"

    fi

    echo ""
    read -p " 是否安装BBR(默认安装)?[y/n]:" NEED_BBR
    [[ -z "$NEED_BBR" ]] && NEED_BBR=y
    [[ "$NEED_BBR" = "Y" ]] && NEED_BBR=y
    colorEcho $BLUE " 安装BBR：$NEED_BBR"
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
    mkdir -p /usr/local/etc/xray

	curl  https://get.acme.sh | sh \
	&& source ~/.bashrc \
	&& ~/.acme.sh/acme.sh --upgrade  --auto-upgrade \
	&& ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

	if ! [[ -f ~/.acme.sh/${DOMAIN}_ecc/ca.cer ]]; then
		~/.acme.sh/acme.sh --issue -d "${DOMAIN}" --keylength ec-256 --standalone
	fi
	~/.acme.sh/acme.sh --install-cert -d "${DOMAIN}" --ecc \
		--key-file       "${KEY_FILE}"  \
		--fullchain-file "${CERT_FILE}"
	if ! [[ -f "${CERT_FILE}" && -f "${KEY_FILE}" ]]; then
		colorEcho $RED " 获取证书失败，请到 Github Issues 反馈"
		exit 1
	fi
}

configNginx() {
	rm -rf "${NGINX_CONF_PATH}"
    mkdir -p /usr/share/nginx/html;
	echo 'User-Agent: *' > /usr/share/nginx/html/robots.txt
	echo 'Disallow: /' >> /usr/share/nginx/html/robots.txt

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
        if systemctl status firewalld > /dev/null 2>&1;then
            firewall-cmd --permanent --add-service=http
            firewall-cmd --permanent --add-service=https
            if [[ "$PORT" != "443" ]]; then
                firewall-cmd --permanent --add-port=${PORT}/tcp
                firewall-cmd --permanent --add-port=${PORT}/udp
            fi
            firewall-cmd --reload
        else
            nl="$(iptables -nL | nl | grep FORWARD | awk '{print $1}')"
            if [[ "$nl" != "3" ]]; then
                iptables -I INPUT -p tcp --dport 80 -j ACCEPT
                iptables -I INPUT -p tcp --dport 443 -j ACCEPT
                if [[ "$PORT" != "443" ]]; then
                    iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
                    iptables -I INPUT -p udp --dport ${PORT} -j ACCEPT
                fi
            fi
        fi
    else
        if which iptables 2>/dev/null; then
            nl="$(iptables -nL | nl | grep FORWARD | awk '{print $1}')"
            if [[ "$nl" != "3" ]]; then
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
    fi
}

installBBR() {
    true
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

	# VMESS+WS+TLS
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
    setFirewall
    getCert

    install_nginx
    configNginx
	start_and_enable_service nginx

    installXray
    configXray
	start_and_enable_service xray

    setSelinux
    installBBR

    showInfo
}

uninstall() {
	stop_and_disable_service nginx
	stop_and_disable_service xray
}

getConfigFileInfo() {
    tls="false"
    ws="false"
    protocol="VMess"

    uid=`grep id $CONFIG_FILE | head -n1| cut -d: -f2 | tr -d \",' '`
    alterid=`grep alterId $CONFIG_FILE  | cut -d: -f2 | tr -d \",' '`
    network=`grep network $CONFIG_FILE  | tail -n1| cut -d: -f2 | tr -d \",' '`
    [[ -z "$network" ]] && network="tcp"
    domain=`grep serverName $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
    if [[ "$domain" = "" ]]; then
        domain=`grep Host $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
        if [[ "$domain" != "" ]]; then
            ws="true"
            tls="true"
            wspath=`grep path $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
        fi
    else
        tls="true"
    fi
    if [[ "$ws" = "true" ]]; then
        port=`grep -i ssl $NGINX_CONF_PATH/${domain}.conf| head -n1 | awk '{print $2}'`
    else
        port=`grep port $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
    fi
}

outputVmessWS() {
    raw="{
  \"v\":\"2\",
  \"ps\":\"\",
  \"add\":\"$IP\",
  \"port\":\"${port}\",
  \"id\":\"${uid}\",
  \"aid\":\"$alterid\",
  \"net\":\"${network}\",
  \"type\":\"none\",
  \"host\":\"${domain}\",
  \"path\":\"${wspath}\",
  \"tls\":\"tls\"
}"
    link=`echo -n ${raw} | base64 -w 0`
    link="vmess://${link}"

    echo -e "   ${BLUE}IP(address): ${PLAIN} ${RED}${IP}${PLAIN}"
    echo -e "   ${BLUE}端口(port)：${PLAIN}${RED}${port}${PLAIN}"
    echo -e "   ${BLUE}id(uuid)：${PLAIN}${RED}${uid}${PLAIN}"
    echo -e "   ${BLUE}额外id(alterid)：${PLAIN} ${RED}${alterid}${PLAIN}"
    echo -e "   ${BLUE}加密方式(security)：${PLAIN} ${RED}none${PLAIN}"
    echo -e "   ${BLUE}传输协议(network)：${PLAIN} ${RED}${network}${PLAIN}" 
    echo -e "   ${BLUE}伪装类型(type)：${PLAIN}${RED}none$PLAIN"
    echo -e "   ${BLUE}伪装域名/主机名(host)/SNI/peer名称：${PLAIN}${RED}${domain}${PLAIN}"
    echo -e "   ${BLUE}路径(path)：${PLAIN}${RED}${wspath}${PLAIN}"
    echo -e "   ${BLUE}底层安全传输(tls)：${PLAIN}${RED}TLS${PLAIN}"
    echo  
    echo -e "   ${BLUE}vmess链接:${PLAIN} $RED$link$PLAIN"
    echo  
    echo  
}

showInfo() {
    res="$(status)"
    if [[ $res -lt 2 ]]; then
        colorEcho $RED " Xray未安装，请先安装！"
        return
    fi
    
    echo ""
    echo -n -e " ${BLUE}Xray运行状态：${PLAIN}"
    statusText
    echo -e " ${BLUE}Xray配置文件: ${PLAIN} ${RED}${CONFIG_FILE}${PLAIN}"
    colorEcho $BLUE " Xray配置信息："

    getConfigFileInfo

    echo -e "   ${BLUE}协议: ${PLAIN} ${RED}${protocol}${PLAIN}"

	outputVmessWS
}

menu() {
    clear
    echo "#############################################################"
    echo -e "#                    ${RED}Xray 一键安装脚本${PLAIN}                     #"
    echo -e "# ${GREEN}作者${PLAIN}: MisakaNo の 小破站                                  #"
    echo -e "# ${GREEN}博客${PLAIN}: https://blog.misaka.rest                            #"
    echo -e "# ${GREEN}GitHub 项目${PLAIN}: https://github.com/Misaka-blog               #"
    echo -e "# ${GREEN}GitLab 项目${PLAIN}: https://gitlab.com/Misaka-blog               #"
    echo -e "# ${GREEN}Telegram 频道${PLAIN}: https://t.me/misakanocchannel              #"
    echo -e "# ${GREEN}Telegram 群组${PLAIN}: https://t.me/misakanoc                     #"
    echo -e "# ${GREEN}YouTube 频道${PLAIN}: https://www.youtube.com/@misaka-blog        #"
    echo "#############################################################"
    echo ""
    echo -e " ${GREEN}4.${PLAIN} 安装Xray-${BLUE}VMESS+WS+TLS${PLAIN}${RED}(推荐)${PLAIN}"
    echo " -------------"
    echo -e " ${GREEN}12. ${RED}卸载Xray${PLAIN}"
    echo " -------------"
    echo -e " ${GREEN}13.${PLAIN} 启动Xray"
    echo -e " ${GREEN}14.${PLAIN} 重启Xray"
    echo -e " ${GREEN}15.${PLAIN} 停止Xray"
    echo " -------------"
    echo -e " ${GREEN}16.${PLAIN} 查看Xray配置"
    echo -e " ${GREEN}17.${PLAIN} 查看Xray日志"
    echo " -------------"
    echo -e " ${GREEN}0.${PLAIN} 退出"
    echo -n " 当前状态："
    statusText
    echo 

    read -p " 请选择操作[0-17]：" answer
    case $answer in
        4)
            install
            ;;
        12)
            uninstall
            ;;
        16)
            showInfo
            ;;
        *)
            colorEcho $RED " 请选择正确的操作！"
            exit 1
            ;;
    esac
}

checkSystem

action=$1
[[ -z $1 ]] && action=menu

case "$action" in
    menu|uninstall|showInfo)
        ${action}
        ;;
    *)
        echo " 参数错误"
        echo " 用法: `basename $0` [menu|uninstall|showInfo]"
        ;;
esac
