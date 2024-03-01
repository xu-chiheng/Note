#!/usr/bin/env -S bash -i

# MIT License

# Copyright (c) 2023 徐持恒 Xu Chiheng

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cd "$(dirname "$0")"


# Kubuntu 20.04.3 21.04
# Fedora KDE 28-1.1 34-1.2
# CentOSStream 8
# Rocky Linux 9
# Debian 12

# https://unix.stackexchange.com/questions/189777/how-to-launch-shell-script-with-double-click-in-centos-7
# https://unix.stackexchange.com/questions/80822/ubuntu-unity-attach-script-to-launcher


# https://askubuntu.com/questions/1237042/desktop-files-not-launching-from-desktop-in-ubuntu-20-04-lts#comment2217892_1304189


# https://askubuntu.com/questions/138908/how-to-execute-a-script-just-by-double-clicking-like-exe-files-in-windows
# https://stackoverflow.com/questions/42044798/how-do-i-run-a-script-on-linux-just-by-double-clicking-it

# gsettings set org.gnome.nautilus.preferences executable-text-activation 'launch'


# 安装git redhat-lsb-core
# https://stackoverflow.com/questions/16842014/redirect-all-output-to-file-using-bash-on-linux
if quiet_command which apt; then
	# Debian, Ubuntu, Raspbian
	true
elif quiet_command which dnf; then
	# Fedora, RedHat, CentOS
	dnf install -y lsb_release
elif quiet_command which pacman; then
	# Arch Linux, Manjaro, Parabola
	true
else
	echo "Unkown system $(uname -a)"
	exit 1
fi

if ! quiet_command which lsb_release; then
	echo "No lsb_release command"
	exit 1
fi

OS_NAME="$(lsb_release -si)"
OS_VERSION="$(lsb_release -sr)"
# https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script

check_os_and_version() {
	case "${OS_NAME}" in
		Ubuntu | Debian | Fedora | CentOSStream | RockyLinux | Arch | Manjaro )
			true
			;;
		* )
			echo "Unknown Linux distribution ${OS_NAME} ${OS_VERSION}"
			exit 1
			;;
	esac
}

check_os_and_version

set_fastest_mirror_and_update() {
	case "${OS_NAME}" in
		Ubuntu )
			# Kubuntu/Ubuntu中apt设置国内最快的mirror       https://mirrors.ustc.edu.cn/ubuntu
			# 这种方法有问题
			# https://linuxconfig.org/how-to-select-the-fastest-apt-mirror-on-ubuntu-linux
			# https://www.gnu.org/software/sed/manual/html_node/Regular-Expressions.html
			# https://developer.aliyun.com/mirror/ubuntu

			# This software is not part of Ubuntu, but is offered by Canonical and the
			# respective vendors as a service to Ubuntu users.
			# deb http://archive.canonical.com/ubuntu focal partner
			# deb-src http://archive.canonical.com/ubuntu focal partner
			#			-e 's,http://archive.canonical.com,https://mirrors.ustc.edu.cn,g'

			# https://alt.os.linux.ubuntu.narkive.com/aew4nPfQ/archive-canonical-com-very-slow-mirror

			backup_or_restore_file_or_dir /etc/apt \
			&& sed /etc/apt/sources.list -i \
						-e 's,http://\([a-z]\+.\)\?archive.ubuntu.com,https://mirrors.ustc.edu.cn,g' \
						-e 's,http://security.ubuntu.com,https://mirrors.ustc.edu.cn,g' \
						-e 's,^# \(\(deb \)\(.\+\)\( partner\)\)$,\1,g' \
						-e 's,^# \(deb-src .\+\)$,\1,g' \
			&& apt -y update \
			&& apt -y upgrade
			;;
		Debian )
			# TODO
			true
			;;
		Fedora )
			# Fedora中dnf设置国内最快的mirror        https://mirrors.ustc.edu.cn/fedora
			# baseurl更改为上面的url开始。
			# https://superuser.com/questions/1035780/how-can-i-use-a-specific-mirror-server-in-fedora
			# https://www.reddit.com/r/Fedora/comments/3vbht4/select_specific_dnf_mirror/

			# Error: Cannot find a valid baseurl for repo: fedora-cisco-openh264
			# Ignoring repositories: fedora-cisco-openh264

			# https://stackoverflow.com/questions/18668556/how-can-i-compare-numbers-in-bash
			# https://tldp.org/LDP/abs/html/comparison-ops.html
			backup_or_restore_file_or_dir /etc/yum.repos.d \
			&& if [ "${OS_VERSION}" -le "31" ]; then
				# https://admin.fedoraproject.org/mirrormanager/
				# https://archives.fedoraproject.org/pub/archive/fedora/linux
				# http://mirrors.kernel.org/fedora-buffet/archive/fedora/linux
				# https://mirror.math.princeton.edu/pub/fedora-archive/fedora/linux
				# https://dl.fedoraproject.org/pub/archive//fedora/linux

				# https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-20&arch=x86_64

				# 不要注释metalink行
				find /etc/yum.repos.d -type f -print0 | xargs -0 sed -i \
							-e 's,^#baseurl=,baseurl=,g' \
							-e 's,http://download.fedoraproject.org/pub/fedora/linux,http://mirrors.kernel.org/fedora-buffet/archive/fedora/linux,g' \
				&& dnf -y update \
				&& dnf -y upgrade
			else
				find /etc/yum.repos.d -type f -print0 | xargs -0 sed -i \
							-e 's,^#baseurl=,baseurl=,g' \
							-e 's,^metalink=,#metalink=,g' \
							-e 's,http://download.example/pub/fedora/linux,https://mirrors.ustc.edu.cn/fedora,g' \
				&& dnf -y update \
				&& dnf -y upgrade
			fi
			;;
		# CentOS )

		#     #配置YUM使用国内快速mirror  http://ftp.sjtu.edu.cn/   http://mirrors.ustc.edu.cn/

		#     find /etc/yum.conf /etc/yum.repos.d -type f
		#     find /etc/yum.conf /etc/yum.repos.d -type f -print0 | xargs -0 cat


		#     find /etc/yum.conf /etc/yum.repos.d -type f -print0 | xargs -0 sed -i \
		#                 -e 's/^#baseurl=/baseurl=/g'   -e 's/^mirrorlist=/#mirrorlist=/g'  \
		#                 -e 's,http://download.fedoraproject.org/pub/fedora/linux,http://ftp.sjtu.edu.cn/fedora/linux,g'  \
		#                 -e 's,http://mirror.centos.org/centos,http://ftp.sjtu.edu.cn/centos,g'  \
		#                 -e 's,http://vault.centos.org,http://ftp.sjtu.edu.cn/centos,g'  \
		#                 -e 's,^metalink=,#metalink=,g'

		#     find /etc/yum.conf /etc/yum.repos.d -type f -print0 | xargs -0 sed -i \
		#                 -e 's/^#baseurl=/baseurl=/g'   -e 's/^mirrorlist=/#mirrorlist=/g'  \
		#                 -e 's,http://download.fedoraproject.org/pub/fedora/linux,http://mirrors.ustc.edu.cn/fedora/linux,g'  \
		#                 -e 's,http://mirror.centos.org/centos,http://mirrors.ustc.edu.cn/centos,g'  \
		#                 -e 's,http://vault.centos.org,http://mirrors.ustc.edu.cn/centos,g'  \
		#                 -e 's,^metalink=,#metalink=,g'


		#     find /etc/yum.conf /etc/yum.repos.d -type f -print0 | xargs -0 cat
		# 	;;
		CentOSStream )
			# CentOS中设置国内最快的mirror           https://mirrors.ustc.edu.cn/centos
			backup_or_restore_file_or_dir /etc/yum.repos.d \
			&& find /etc/yum.repos.d -type f -print0 | xargs -0 sed -i \
						-e 's,^#baseurl=,baseurl=,g' \
						-e 's,^mirrorlist=,#mirrorlist=,g' \
						-e 's,http://mirror.centos.org,https://mirrors.ustc.edu.cn,g' \
			&& dnf -y update \
			&& dnf -y upgrade
			;;
		RockyLinux )
			# should be similar to CentOSStream
			backup_or_restore_file_or_dir /etc/yum.repos.d \
			&& find /etc/yum.repos.d -type f -print0 | xargs -0 sed -i \
						-e 's,^#baseurl=,baseurl=,g' \
						-e 's,^mirrorlist=,#mirrorlist=,g' \
						-e 's,http://dl.rockylinux.org/$contentdir,https://mirrors.ustc.edu.cn/rocky,g' \
			&& dnf -y update \
			&& dnf -y upgrade
			;;
		Arch )
			true
			;;
		Manjaro )
			# Manjaro中packman设置国内最快的mirror
			backup_or_restore_file_or_dir /etc/pacman.d \
			&& cat <<EOF | tee /etc/pacman.d/mirrorlist
Server = https://mirrors.ustc.edu.cn/manjaro/stable/\$repo/\$arch
Server = https://mirrors.aliyun.com/manjaro/stable/\$repo/\$arch
Server = https://mirrors.tuna.tsinghua.edu.cn/manjaro/stable/\$repo/\$arch
EOF
			;;
	esac
}

install_basic_packages() {
	local packages=()

	packages+=( open-vm-tools git gitk nano emacs texinfo )
	case "${OS_NAME}" in
		Ubuntu | Debian | Fedora | Arch | Manjaro )
			# newer packages are available
			packages+=( htop neofetch astyle )
			;;
		CentOSStream | RockyLinux )
			packages+=()
			;;
	esac
	case "${OS_NAME}" in
		Ubuntu | Debian | Fedora | Arch | Manjaro )
			# KDE packages are available
			packages+=( dolphin konsole ksysguard kwrite )
			;;
		CentOSStream | RockyLinux )
			# GNOME only
			packages+=()
			;;
	esac

	packages+=( gcc gdb clang lldb make cmake perl python3 expect bison flex m4 gettext graphviz )
	case "${OS_NAME}" in
		Fedora )
			if [ "${OS_VERSION}" -le "31" ]; then
				packages+=( gcc-c++ )
			else
				packages+=( g++ )
			fi
			;;
		Ubuntu | Debian )
			packages+=( g++ )
			;;
		CentOSStream | RockyLinux )
			packages+=( gcc-c++ )
			;;
		Arch | Manjaro )
			# TODO : what is name of g++ package ?
			packages+=()
			;;
	esac

	case "${OS_NAME}" in
		Ubuntu | Debian | Fedora )
			packages+=( dejagnu autogen texinfo sharutils doxygen )
			;;
		CentOSStream | RockyLinux )
			packages+=()
			;;
		Arch | Manjaro )
			packages+=()
			;;
	esac

	case "${OS_NAME}" in
		Ubuntu | Debian )
			packages+=( libgmp-dev libmpfr-dev libmpc-dev libzip-dev libppl-dev )
			;;
		Fedora | CentOSStream | RockyLinux )
			packages+=( gmp gmp-devel mpfr mpfr-devel libmpc libzip libzip-devel )
			case "${OS_NAME}" in
				Fedora | CentOSStream )
					packages+=( libmpc-devel )
					;;
			esac
			case "${OS_NAME}" in
				Fedora )
					packages+=( ppl ppl-devel )
					;;
			esac
			;;
		Arch | Manjaro )
			packages+=()
			;;
	esac

	case "${OS_NAME}" in
		Ubuntu | Debian )
			apt install -y "${packages[@]}"
			;;
		Fedora | CentOSStream | RockyLinux )
			dnf install -y "${packages[@]}"
			;;
		Arch | Manjaro )
			pacman -Sy --noconfirm "${packages[@]}"
			;;
	esac
}

install_vs_code() {
	case "${OS_NAME}" in
		Ubuntu | Debian )
			snap install --classic code
			;;
		Fedora | CentOSStream | RockyLinux )
			# https://computingforgeeks.com/install-visual-studio-code-on-fedora/
			rpm --import https://packages.microsoft.com/keys/microsoft.asc \
			&& { cat <<EOF | tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
} \
			&& dnf check-update \
			&& dnf install -y code \
			&& rpm -qi code
			;;
		Arch | Manjaro )
			pacman -S code
			;;
	esac
}

install_google_chrome() {
	case "${OS_NAME}" in
		Ubuntu | Debian )
			rm -rf google-chrome-stable_current_amd64.deb \
			&& wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
			&& apt install -y ./google-chrome-stable_current_amd64.deb \
			&& rm -rf google-chrome-stable_current_amd64.deb
			;;
		Fedora | CentOSStream | RockyLinux )
			dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
			;;
		Arch | Manjaro )
			# How to Install Google Chrome in Arch-based Linux Distributions
			# https://itsfoss.com/install-chrome-arch-linux/
			pacman -S --needed base-devel git \
			&& git clone https://aur.archlinux.org/google-chrome.git \
			&& cd google-chrome \
			&& makepkg -si

			# upgrade
			# git pull
			# makepkg -si
			;;
	esac
}

install_openjdk() {
	case "${OS_NAME}" in
		Ubuntu | Debian )
			# apt install -y default-jdk
			# apt install -y openjdk-8-jdk
			# apt install -y openjdk-11-jdk
			apt install -y openjdk-17-jdk
			;;
		Fedora )
			# dnf install -y java-11-openjdk
			dnf install -y java-17-openjdk
			# dnf install -y java-1.8.0-openjdk
			# dnf install -y java-latest-openjdk
			;;
		CentOSStream | RockyLinux )
			# dnf install -y java-11-openjdk-devel
			dnf install -y java-17-openjdk-devel
			# alternatives --config java
			;;
		Arch | Manjaro )
			true
			;;
	esac
}

install_qemu() {
	case "${OS_NAME}" in
		Ubuntu | Debian )
			# https://www.unixmen.com/how-to-install-and-configure-qemu-in-ubuntu/
			# https://ubuntu.com/server/docs/virtualization-qemu
			# https://www.tecmint.com/install-kvm-on-ubuntu/
			# https://phoenixnap.com/kb/ubuntu-install-kvm
			apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
			;;
		Fedora )
			dnf install -y qemu qemu-kvm libvirt-daemon libvirt bridge-utils virt-manager
			;;
		CentOSStream | RockyLinux )
			dnf install -y qemu-kvm libvirt-daemon libvirt virt-manager
			;;
		Arch | Manjaro )
			true
			;;
	esac
}

install_qemu_build_requirements() {
	# https://wiki.qemu.org/Hosts/Linux
	case "${OS_NAME}" in
		Ubuntu | Debian )
			apt install -y git ninja-build python3 '*libsdl2*' '*libgtk-3*' \
						   git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
						   git-email \
						   libaio-dev libbluetooth-dev libbrlapi-dev libbz2-dev \
						   libcap-dev libcap-ng-dev libcurl4-gnutls-dev libgtk-3-dev \
						   libibverbs-dev libjpeg8-dev libncurses5-dev libnuma-dev \
						   librbd-dev librdmacm-dev \
						   libsasl2-dev libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev \
						   libvde-dev libvdeplug-dev libvte-dev libxen-dev liblzo2-dev \
						   valgrind xfslibs-dev \
						   libnfs-dev libiscsi-dev
			;;
		Fedora )
			dnf install -y git glib2-devel libfdt-devel pixman-devel zlib-devel bzip2 ninja-build python3 'SDL2*' 'gtk3*'
			;;
		CentOSStream | RockyLinux )
			# no ninja-build and SDL2, QEMU cant't be built
			dnf install -y git glib2-devel pixman-devel zlib-devel bzip2 python3 'gtk3*'
			;;
		Arch | Manjaro )
			true
			;;
	esac
}

disable_kde_wallet() {
	case "${DESKTOP_SESSION}" in
		*plasma* )
			# https://unix.stackexchange.com/questions/450731/disable-kde-wallet-from-the-command-line
			pkill kwallet
			kwriteconfig5 --file kwalletrc --group 'Wallet' --key 'Enabled' 'false' \
			&& kwriteconfig5 --file kwalletrc --group 'Wallet' --key 'First Use' 'false'
			;;
		gnome | ubuntu )
			true
			;;
		* )
			true
			;;
	esac
}

disable_kde_suspend_and_lock() {
	case "${DESKTOP_SESSION}" in
		*plasma* )
			# # kwriteconfig5 --file powermanagementprofilesrc --group '[Battery][SuspendSession]' --key 'suspendType' '1'
			# # https://askubuntu.com/questions/803629/how-do-i-programmatically-disable-the-kde-screen-locker
			# kwriteconfig5 --file kscreenlockerrc --group 'Daemon' --key 'Autolock' 'false'
			# # qdbus org.freedesktop.ScreenSaver /ScreenSaver configure
			true
			;;
		gnome | ubuntu )
			true
			;;
		* )
			true
			;;
	esac
}

set_hostname() {
	# Linux samba设置时,需要将Linux放在与Windows相同的组,workgroup通常为"workgroup",而不能使用默认的"mygroup".
	# 同时,Linux的hostname不能使用默认的"localhost.localdomain",
	# 需要通过下面的命令,设置新的hostname,需要重新启动.
	case "${OS_NAME}" in
		Fedora )
			echo "fedora" >/etc/hostname
			;;
		CentOSStream )
			echo "centos" >/etc/hostname
			;;
		RockyLinux )
			echo "rocky" >/etc/hostname
			;;
		Ubuntu )
			echo "ubuntu" >/etc/hostname
			;;
		Debian )
			echo "debian" >/etc/hostname
			;;
		Arch )
			echo "arch" >/etc/hostname
			;;
		Manjaro )
			echo "manjaro" >/etc/hostname
			;;
	esac
}

samba_write_config_file() {
	# https://unix.stackexchange.com/questions/5120/how-do-you-make-samba-follow-symlink-outside-the-shared-path

	cat >/etc/samba/smb.conf <<EOF
[global]
	workgroup = WORKGROUP
	server string = Samba Server Version %v

	log file = /var/log/samba/log.%m
	max log size = 50

	security = user
	passdb backend = tdbsam

	load printers = yes
	cups options = raw

	allow insecure wide links = yes
[work]
	comment = Working Directory
	path = /mnt/work
	public = yes
	writable = yes
	valid users = user guest

	follow symlinks = yes
	wide links = yes
EOF
}

install_samba() {
	# CentOS 6.3下Samba服务器的安装与配置
	# http://www.cnblogs.com/mchina/archive/2012/12/18/2816717.html
	case "${OS_NAME}" in
		Fedora | CentOSStream | RockyLinux )
			dnf -v -y install samba samba-client \
			&& systemctl start smb \
			&& systemctl start nmb \
			&& systemctl enable smb \
			&& systemctl enable nmb \
			&& backup_or_restore_file_or_dir /etc/samba \
			&& samba_write_config_file \
			&& { echo 1; echo 1; } | pdbedit -a -u user \
			&& { useradd guest; true;} \
			&& { echo ; echo ; } | pdbedit -a -u guest \
			&& echo | testparm \
			&& systemctl reload smb \
			&& systemctl reload nmb
			;;
		Ubuntu | Debian )
			apt install -y samba \
			&& ufw allow samba \
			&& systemctl start smbd \
			&& systemctl enable smbd \
			&& backup_or_restore_file_or_dir /etc/samba \
			&& samba_write_config_file \
			&& { echo 1; echo 1; } | smbpasswd -a user \
			&& { useradd guest; true;} \
			&& { echo ; echo ; } | smbpasswd -a guest \
			&& echo | testparm \
			&& systemctl reload smbd
			;;
		Arch )
			echo "don't known how to install samba"
			exit 1
			;;
		Manjaro )
			echo "don't known how to install samba"
			exit 1
			;;
	esac
}

time_command set_fastest_mirror_and_update \
&& time_command linux_uninstall_firewall \
&& time_command linux_disable_selinux \
&& time_command install_basic_packages \
&& time_command install_vs_code \
&& time_command install_google_chrome \
&& time_command install_qemu \
&& time_command install_qemu_build_requirements \
&& time_command install_openjdk \
&& time_command disable_kde_wallet \
&& time_command disable_kde_suspend_and_lock \
&& time_command set_hostname \
&& time_command install_samba \
&& echo "Completed!"
