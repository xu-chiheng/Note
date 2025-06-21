#!/usr/bin/env -S bash -i

# Works on Debian 12, Ubuntu 24.04 LTS, Fedora 41, Almalinux 9, Rocky Linux 9 at 2025-05-15

# VMess
# https://guide.v2fly.org/basics/vmess.html

# WebSocket + TLS + Web
# https://guide.v2fly.org/advanced/wss_and_web.html

# Xray core
# Xray, Penetrates Everything. Also the best v2ray-core. Where the magic happens. An open platform for various uses.
# https://github.com/XTLS/Xray-core
# https://xtls.github.io

# v2fly core
# A platform for building proxies to bypass network restrictions.
# https://github.com/v2fly/v2ray-core
# https://www.v2fly.org
# https://www.v2ray.com

# sing-box
# The universal proxy platform.
# https://sing-box.sagernet.org/
# https://github.com/SagerNet/sing-box

# Caddy
# Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS
# https://github.com/caddyserver/caddy
# https://caddyserver.com

# Nginx NGINX nginx
# nginx ("engine x") is an HTTP web server, reverse proxy, content cache, load balancer, TCP/UDP proxy server, and mail proxy server.
# https://github.com/nginx/nginx
# https://nginx.org

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

# v2rayN 7.12.5 Settings

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

# Xray 25.1.1 (Xray, Penetrates Everything.) e80ca67 (go1.23.4 windows/amd64)
# A unified platform for anti-censorship.
# 2025/04/10 04:32:48 [Info] infra/conf/serial: Reading config: &{Name:configTest5633101108505334439.json Format:json}
# 2025/04/10 04:32:48 [Warning] common/errors: This feature WebSocket transport (with ALPN http/1.1, etc.) is deprecated and being migrated to XHTTP H2 & H3. Please update your config(s) according to release note and documentation before removal.
# 2025/04/10 04:32:48 [Warning] core: Xray 25.1.1 started
# 2025/04/10 04:32:48 [Warning] common/errors: This feature "host" in "headers" is deprecated and being migrated to independent "host". Please update your config(s) according to release note and documentation before removal.
# 2025/04/10 04:32:48 from tcp:127.0.0.1:50192 accepted tcp:www.google.com:443 [socks10829 >> proxy]
# 2025/04/10 04:32:50 from tcp:127.0.0.1:50195 accepted tcp:cachefly.cachefly.net:443 [socks10829 >> proxy]
# 2025/04/10 04:32:51 from tcp:127.0.0.1:50197 accepted tcp:cachefly.cachefly.net:443 [socks10829 >> proxy]

# ChatGPT Claude Gemini       Xray为什么要deprecate WebSocket ?
# Xray 核心团队计划或已经逐步弃用（deprecate）WebSocket（WS）协议，主要出于以下几个技术和现实层面的原因：

# ---

# ### 🔧 1. **协议特性与劣势**

# * **WebSocket 本质上并不“隐匿”**：虽然 WS 和 WSS（加密版）看起来像是普通的浏览器通信，但实际上，在网络行为上依然容易被检测和区分。
# * **易于特征识别**：一些防火墙和审查机制（如 GFW）可以识别 Xray 或 V2Ray over WS 的行为特征，即使通过 CDN 也不完全安全。
# * **连接建立过程较复杂**：WebSocket 需要先通过 HTTP/HTTPS 发起握手，然后升级协议。这一过程相较于 HTTP/2、QUIC 等新协议开销更大，连接时间也较长。

# ---

# ### 🚧 2. **现实部署中遇到的问题**

# * **过度依赖 CDN 伪装**：很多用户为了伪装 WS 流量使用了 Cloudflare 等 CDN，这种方式虽然短期有效，但长期来看一旦某些 IP 污染或被识别，会导致大批用户受影响。
# * **维护复杂性高**：为了部署 WS+TLS+CDN，很多用户需要手动配置 Nginx、Caddy 等反向代理，还要处理证书问题。相比之下，VLESS + Reality 或 H2 的方案更为简洁。

# ---

# ### 🚀 3. **新协议（如 Reality）的优势**

# * **Reality 更加隐匿**：Reality（一个新一代的 XTLS 协议）通过伪装成真实的 HTTPS 请求，更难被识别或封锁。
# * **HTTP/2 / QUIC 更现代化**：它们比 WS 更适合长期维持连接，并且已经广泛应用于现代互联网，混淆性更强。
# * **简化部署**：使用 Reality 或 XTLS-RPRX 的配置比传统 WS+TLS 更少依赖外部组件（如 Nginx），降低了部署和维护难度。

# ---

# ### 🛑 总结：为什么弃用 WebSocket？

# | 原因      | 说明                       |
# | ------- | ------------------------ |
# | 🔍 安全性  | 容易被识别，特征明显               |
# | ⚙️ 性能   | 握手过程复杂，效率低于 H2/QUIC      |
# | 🧱 稳定性  | 容易受 CDN 或墙影响             |
# | 🔧 维护难度 | 需要额外反代配置和证书管理            |
# | 🔄 替代方案 | Reality、H2 等更先进、隐匿、部署更简单 |

# ---

# 如果你正在使用 WS 方案，可以考虑逐步迁移到以下任一方向：

# * VLESS + Reality（推荐）
# * Trojan + H2 / gRPC
# * XTLS-RPRX（如无需 CDN，可选）

# 如果你有现成配置，我可以帮你改成更现代的协议。需要的话直接贴出配置内容。





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

____how_to_use_this_script____() {
	# VPS SSH login as root
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
unset -f ____how_to_use_this_script____

getData() {
	echo
	echo "Xray一键脚本，运行之前请确认如下条件已经具备："
	echo "1. 一个伪装域名"
	echo "2. 伪装域名DNS解析指向当前服务器ip（${IP}）"
	echo
	while true
	do
		read -p "请输入伪装域名：" DOMAIN
		if [ -z "${DOMAIN}" ]; then
			echo "域名输入错误，请重新输入！"
		else
			break
		fi
	done
	DOMAIN="${DOMAIN,,}"

	# 在开启Cloudflare CDN DNS代理（小云朵）的情况下，下面的条件无法满足
	# if [ "$(linux_resolve_hostname "${DOMAIN}")" != "${IP}" ]; then
	# 	echo "伪装域名${DOMAIN}不指向${IP}"
	# 	exit 1
	# fi
	echo "伪装域名(host)：${DOMAIN}"
}

# 查看 ACME 添加的 cron 条目
# crontab -l
# 0 0 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null

# 删除 ACME 自动添加的 cron 条目   编辑当前用户的 crontab
# crontab -e

# 更彻底的做法（如果你不打算使用 acme.sh）
# ~/.acme.sh/acme.sh --uninstall
# 它会自动移除安装目录、环境变量、cron 等相关内容。


# 证书有效期：Let's Encrypt证书仅90天，建议每60天续期。

# 使用 --force 参数测试续签流程：
# systemctl stop nginx; ~/.acme.sh/acme.sh --renew-all --force; systemctl start nginx
# systemctl stop nginx; ~/.acme.sh/acme.sh --renew -d example.com --force; systemctl start nginx
# 临时关闭 nginx，再执行续签，否则
# root@server0:~# ~/.acme.sh/acme.sh --renew -d example.com --force
# [Fri May 16 01:29:02 PM CST 2025] The domain 'example.com' seems to already have an ECC cert, let's use it.
# [Fri May 16 01:29:02 PM CST 2025] Renewing: 'example.com'
# [Fri May 16 01:29:02 PM CST 2025] Renewing using Le_API=https://acme-v02.api.letsencrypt.org/directory
# [Fri May 16 01:29:02 PM CST 2025] Using CA: https://acme-v02.api.letsencrypt.org/directory
# [Fri May 16 01:29:02 PM CST 2025] Standalone mode.
# [Fri May 16 01:29:02 PM CST 2025] LISTEN 0      511          0.0.0.0:80         0.0.0.0:*    users:(("nginx",pid=789,fd=7),("nginx",pid=788,fd=7))
# LISTEN 0      511             [::]:80            [::]:*    users:(("nginx",pid=789,fd=8),("nginx",pid=788,fd=8))
# [Fri May 16 01:29:02 PM CST 2025] tcp port 80 is already used by (("nginx",pid=789,fd=7),("nginx",pid=788,fd=7))
# 80            [
# [Fri May 16 01:29:02 PM CST 2025] Please stop it first
# [Fri May 16 01:29:02 PM CST 2025] _on_before_issue.
# root@server0:~#
# 这是因为你在使用 --standalone 模式续期证书，但该模式要求 acme.sh 自己临时监听 80 端口，而现在你的 nginx 已经占用了 80 端口。
# ACME 协议的 HTTP 验证（http-01 challenge）必须使用 80 端口，这是 Let's Encrypt 和其他 CA 强制的安全标准。

# 查看证书信息：
# ~/.acme.sh/acme.sh --list
# 自动部署到 nginx/apache/postfix 等服务都可以通过设置 --reloadcmd 自动刷新配置。

# 续签证书时，不需要关闭域名的Cloudflare CDN DNS代理模式，就可以通过DNS验证域名

# ChatGPT Claude Gemini       使用ACME脚本如何保证自动更新SSL/TLS证书？
getCert() {
	if [ ! -d ~/.acme.sh ]; then
		rm -rf ~/.acme.sh

		curl https://get.acme.sh | sh
		# git clone https://github.com/acmesh-official/acme.sh.git ~/.acme.sh
		# ~/.acme.sh/acme.sh --install

		cat >~/.acme.sh/acme_renew.sh <<EOF
#!/usr/bin/env bash

# 停止 Nginx
systemctl stop nginx

# 执行证书续期
~/.acme.sh/acme.sh --cron --home ~/.acme.sh

# 启动 Nginx
systemctl start nginx
EOF
		chmod +x ~/.acme.sh/acme_renew.sh
	fi

	time_command ~/.acme.sh/acme.sh --upgrade --auto-upgrade
	time_command ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt

	# example.com  a.example.com  b.example.com
	# --issue -d "${DOMAIN}" -d '*'"${DOMAIN}" 
	# DNS @ record(@ for root)
	# 对于一个域名example.com的所有下级域名a.example.com  b.example.com都在一个IP上的网站可能有用，但是对于翻墙梯子没有用

	# ~/.acme.sh/example.com_ecc/
	# ca.cer          ← CA 证书（中间证书）
	# example.com.cer ← 你的域名证书
	# example.com.key ← 私钥
	# fullchain.cer   ← 完整链（你最常使用的）
	if [ ! -f ~/.acme.sh/"${DOMAIN}_ecc"/fullchain.cer ]; then
		if ! time_command ~/.acme.sh/acme.sh --issue -d "${DOMAIN}" --keylength ec-256 --standalone; then
			echo "获取证书失败，请到 Github Issues 反馈"
			exit 1
		fi
	fi

	# 自动续期的触发条件是证书 有效期少于 30 天，acme.sh 会自动续签并运行 --reloadcmd 里的服务重载命令。
	if [ ! -f "${KEY_FILE}" ] || [ ! -f "${CERT_FILE}" ]; then
		rm -rf "${KEY_FILE}" "${CERT_FILE}"
		if ! time_command ~/.acme.sh/acme.sh --install-cert -d "${DOMAIN}" --ecc \
			--key-file       "${KEY_FILE}" \
			--fullchain-file "${CERT_FILE}" \
			--reloadcmd 'if systemctl is-active --quiet nginx; then systemctl reload nginx; fi'; then
			echo "安装证书失败，请到 Github Issues 反馈"
			exit 1
		fi
	fi

	time_command crontab -l
	echo "增加crontab中的acme_renew.sh项，并删除acme.sh项"
	{
		crontab -l 2>/dev/null | grep -Ev 'acme.sh|acme_renew.sh'
		echo '0 0 * * * sh -c "bash ~/.acme.sh/acme_renew.sh >/dev/null 2>&1"'
	} | crontab -
	time_command crontab -l
}

putCert() {
	time_command ~/.acme.sh/acme.sh --uninstall
	time_command rm -rf ~/{.acme.sh,*.{key,crt}}
	time_command crontab -l
	echo "删除crontab中的acme_renew.sh项"
	crontab -l 2>/dev/null | grep -Ev 'acme.sh|acme_renew.sh' | crontab -
	time_command crontab -l
}

# https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
installNginx() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		time_command apt install -y nginx
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		time_command dnf install -y nginx
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		time_command pacman -Sy --noconfirm nginx
	fi
}

# On Ubuntu, Nginx reinstalled after an uninstall, miss the "/etc/nginx/nginx.conf" file
# root@server0:~# systemctl status nginx
# × nginx.service - A high performance web server and a reverse proxy server
#      Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
#      Active: failed (Result: exit-code) since Fri 2025-05-16 00:56:46 CST; 12min ago
#        Docs: man:nginx(8)
#     Process: 771 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=1/FAILURE)
#         CPU: 18ms

# May 16 00:56:46 server0 systemd[1]: Starting nginx.service - A high performance web server and a reverse proxy server...
# May 16 00:56:46 server0 nginx[771]: 2025/05/15 16:56:46 [emerg] 771#771: open() "/etc/nginx/nginx.conf" failed (2: No such file or directory)
# May 16 00:56:46 server0 nginx[771]: nginx: configuration file /etc/nginx/nginx.conf test failed
# May 16 00:56:46 server0 systemd[1]: nginx.service: Control process exited, code=exited, status=1/FAILURE
# May 16 00:56:46 server0 systemd[1]: nginx.service: Failed with result 'exit-code'.
# May 16 00:56:46 server0 systemd[1]: Failed to start nginx.service - A high performance web server and a reverse proxy server.
# root@server0:~#

uninstallNginx() {
	if quiet_command which apt; then
		# Debian, Ubuntu, Raspbian
		time_command apt remove -y nginx
	elif quiet_command which dnf; then
		# Fedora, RedHat, CentOS
		time_command dnf remove -y nginx
	elif quiet_command which pacman; then
		# Arch Linux, Manjaro, Parabola
		time_command pacman -Rns --noconfirm nginx
	fi
}

configNginx() {
	if ! time_command backup_or_restore_file_or_dir "${NGINX_CONF_PATH}" \
		|| ! time_command backup_or_restore_file_or_dir "${NGINX_HTDOC_PATH}"; then
		echo "无法备份或恢复Nginx配置文件"
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
  location ${WSPATH} { # 与Xray配置中的${WSPATH}保持一致
    if (\$http_upgrade != "websocket") { # WebSocket协商失败时返回404
        return 404;
    }
    proxy_redirect off;
    proxy_pass http://127.0.0.1:${XPORT}; # 假设WebSocket监听在环回地址的${XPORT}端口上
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
	curl -L "${XRAY_INSTALL_SCRIPT}" | bash -s install
}

uninstallXray() {
	curl -L "${XRAY_INSTALL_SCRIPT}" | bash -s remove
}

configXray() {
	if ! time_command backup_or_restore_file_or_dir "${XRAY_CONF_PATH}"; then
		echo "无法备份或恢复Xray配置文件"
		exit 1
	fi

	cat >"${XRAY_CONF_PATH}/config.json" <<EOF
{
  "inbounds": [
    {
      "port": ${XPORT},
      "listen":"127.0.0.1",//只监听127.0.0.1，避免除本机外的机器探测到开放的${XPORT}端口
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
	time_command uninstall

	IP="$(linux_print_ipv4_address)"

	time_command getData

	KEY_FILE=~/"${DOMAIN}.key"
	CERT_FILE=~/"${DOMAIN}.crt"

	UUID="$(linux_xray_uuid_generate)"
	PORT="$(port_number_generate)"
	XPORT="$(port_number_generate)"
	WSPATH="/$(password_generate_one)"

	time_command linux_disable_ipv6
	time_command linux_enable_bbr
	time_command linux_disable_selinux
	time_command linux_uninstall_firewall
	time_command linux_install_server_tools
	time_command linux_configure_sshd_keepalive

	# 必须在启动Nginx之前，因为 --standalone 证书模式会临时使用80端口，通过HTTP协议，验证域名${DOMAIN}指向${IP}
	time_command getCert

	time_command installNginx
	time_command configNginx
	time_command linux_start_and_enable_service nginx

	time_command installXray
	time_command configXray
	time_command linux_start_and_enable_service xray

	time_command outputVmessWS

	reboot
}

uninstall() {
	time_command linux_stop_and_disable_service nginx
	# time_command uninstallNginx

	time_command linux_stop_and_disable_service xray
	# time_command uninstallXray

	time_command putCert
	time_command git reset --hard HEAD
}

outputVmessWS() {
	local link="vmess://$(base64 -w0 <<EOF
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
)"

	echo  
	echo  
	echo "IP(address)           : ${IP}"
	echo "端口(port)            : ${PORT}"
	echo "id(uuid)              : ${UUID}"
	echo "额外id(alterid)       : 0"
	echo "加密方式(security)    : none"
	echo "传输协议(network)     : ws" 
	echo "伪装类型(type)        : none"
	echo "伪装域名/主机名(host) : ${DOMAIN}"
	echo "路径(path)            : ${WSPATH}"
	echo "底层安全传输(tls)     : tls"
	echo  
	echo "vmess链接 : ${link}"
	echo
	echo
}

menu() {
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
	echo "4. 安装Xray-VMESS+WS+TLS(推荐)"
	echo "-------------"
	echo "12. 卸载Xray"
	echo "-------------"
	echo "0. 退出"
	echo 

	XRAY_INSTALL_SCRIPT="https://github.com/XTLS/Xray-install/raw/main/install-release.sh"
	XRAY_CONF_PATH="/usr/local/etc/xray"
	NGINX_CONF_PATH="/etc/nginx"
	NGINX_HTDOC_PATH="/usr/share/nginx/html"

	read -p "请选择操作[0-17]：" answer
	case "${answer}" in
		4)
			time_command install
			;;
		12)
			time_command uninstall
			;;
		*)
			echo "请选择正确的操作！"
			exit 1
			;;
	esac
}

menu


