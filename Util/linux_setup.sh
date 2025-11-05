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

# GPT(GUID Partition Table)
# /dev/sda1      /boot/efi        EFI System        500M      FAT32/ESP(EFI System Partition)  (flags=boot hidden)
# /dev/sda2      /                Linux Root        400G      xfs or ext4
# /dev/sda3      /mnt/work        Work Partition    100G      btrfs       (Windows 10+ has driver of btrfs, but some Linux distro does not support btrfs)
# /dev/sda4      /mnt/work2       Work Partition    25G       fat32/vfat  (optional, only for Linux distro that does not support btrfs)

# user name | password
# root        1
# user        1

# Debian on VMware Workstation 17
# Debian 12中只能使用启动菜单中的“Start Installer”安装，不要使用KDE Live中的“Install Debian”程序(Calamares Installer)安装。
# “Install Debian”这种安装方式，Partition时，只能选择Erase disk，这样虽然可以成功安装，但是无法设置/mnt/work mount point，如果Partition时，选择Manual partitioning的话，会导致无法启动，root用户被lock。
# “Start Installer”这种安装方式，安装过程中，必须首先删除硬盘上的已有所有分区，否则，安装之后系统无法启动。
# 启动到固件，Boot Manager -> Enter setup -> Boot from a file -> first item -> EFI -> debian -> grub64.efi

# Fedora on VMware Workstation 17
# 启动到固件，Boot Manager -> Enter setup -> Boot from a file -> first item -> EFI -> fedora -> grub64.efi


# How to enable root login?
# https://askubuntu.com/questions/44418/how-to-enable-root-login
# Configuring Kubuntu For Root Logons
# https://www.rcomputer.eu/index.php/blog/8-clanky/linux/52-configuring-kubuntu-for-root-logons
# How to allow root logins?
# https://www.kubuntuforums.net/forum/archives/eol-releases/-19-10/post-installation-av/70490-how-to-allow-root-logins
# HOW TO ENABLE GUI ROOT LOGIN IN DEBIAN 9 – KDE5 PLASMA
# https://economictheoryblog.com/2017/08/30/how-to-enable-gui-root-login-in-debian-9-kde5-plasma/

# 1. execute "sudo passwd root" to set the root password.
# 2. execute "sudo passwd -u root" to unlock the account.
# 3. execute "kwrite /etc/pam.d/sddm", comment out the line "auth required pam_success_if.so user != root quiet_success".
# 4. logout and login as root




# https://unix.stackexchange.com/questions/189777/how-to-launch-shell-script-with-double-click-in-centos-7
# https://unix.stackexchange.com/questions/80822/ubuntu-unity-attach-script-to-launcher


# https://askubuntu.com/questions/1237042/desktop-files-not-launching-from-desktop-in-ubuntu-20-04-lts#comment2217892_1304189


# https://askubuntu.com/questions/138908/how-to-execute-a-script-just-by-double-clicking-like-exe-files-in-windows
# https://stackoverflow.com/questions/42044798/how-do-i-run-a-script-on-linux-just-by-double-clicking-it

# gsettings set org.gnome.nautilus.preferences executable-text-activation 'launch'

# https://stackoverflow.com/questions/16842014/redirect-all-output-to-file-using-bash-on-linux

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
			&& sed -Ei /etc/apt/sources.list \
						-e 's,http://([a-z]+\.)?archive.ubuntu.com,https://mirrors.ustc.edu.cn,g' \
						-e 's,http://security.ubuntu.com,https://mirrors.ustc.edu.cn,g' \
						-e 's,^# (deb .+ partner)$,\1,g' \
						-e 's,^# (deb-src .+)$,\1,g' \
			&& apt -y update \
			&& apt -y upgrade
			;;
		Debian )
			# https://wiki.debian.org/SourcesList
			backup_or_restore_file_or_dir /etc/apt \
			&& sed -Ei /etc/apt/sources.list \
						-e 's,cdrom:\[.*\](/| ),https://mirrors.ustc.edu.cn/debian\1,g' \
						-e 's,http://deb.debian.org/debian(/| ),https://mirrors.ustc.edu.cn/debian\1,g' \
			&& apt -y update \
			&& apt -y upgrade
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
			&& find /etc/yum.repos.d -type f -name 'fedora*' -a ! -name 'fedora-cisco*' -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(metalink=),#\1,g' \
						-e 's,http://download.example/pub/fedora/linux/,https://mirrors.ustc.edu.cn/fedora/,g' \
			&& find /etc/yum.repos.d -type f -name 'fedora-cisco*' -print0 | xargs -0 sed -Ei \
						-e 's,^(metalink=),#\1,g' \
						-e 's,^(enabled=)1,\10,g' \
			&& find /etc/yum.repos.d -type f -name 'rpmfusion*' -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(metalink=),#\1,g' \
						-e 's,http://download1.rpmfusion.org/,https://mirrors.ustc.edu.cn/rpmfusion/,g' \
			&& dnf -y update \
			&& dnf -y upgrade
			;;
		CentOSStream )
			# CentOS中设置国内最快的mirror           https://mirrors.ustc.edu.cn/centos
			backup_or_restore_file_or_dir /etc/yum.repos.d \
			&& find /etc/yum.repos.d -type f -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(mirrorlist=),#\1,g' \
						-e 's,http://mirror.centos.org,https://mirrors.ustc.edu.cn,g' \
			&& dnf -y update \
			&& dnf -y upgrade
			;;
		RockyLinux )
			# should be similar to CentOSStream
			backup_or_restore_file_or_dir /etc/yum.repos.d \
			&& find /etc/yum.repos.d -type f -name 'rocky*' -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(mirrorlist=),#\1,g' \
						-e 's,http://dl.rockylinux.org/$contentdir/,https://mirrors.ustc.edu.cn/rocky/,g' \
			&& find /etc/yum.repos.d -type f -name elrepo.repo -print0 | xargs -0 sed -Ei \
						-e 's,http://elrepo.org/linux/,https://mirrors.ustc.edu.cn/elrepo/,g' \
			&& find /etc/yum.repos.d -type f -name 'epel*' -a ! -name 'epel-cisco*' -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(metalink=),#\1,g' \
						-e 's,https://download.example/pub/epel/,https://mirrors.ustc.edu.cn/epel/,g' \
			&& find /etc/yum.repos.d -type f -name 'epel-cisco*' -print0 | xargs -0 sed -Ei \
						-e 's,^(metalink=),#\1,g' \
						-e 's,^(enabled=)1,\10,g' \
			&& dnf -y update \
			&& dnf -y upgrade
			;;
		AlmaLinux )
			# should be similar to CentOSStream
			backup_or_restore_file_or_dir /etc/yum.repos.d \
			&& find /etc/yum.repos.d -type f -name 'almalinux*' -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(mirrorlist=),#\1,g' \
						-e 's,https://repo.almalinux.org/vault/,https://mirrors.cloud.tencent.com/almalinux/,g' \
						-e 's,https://repo.almalinux.org/almalinux/,https://mirrors.cloud.tencent.com/almalinux/,g' \
			&& find /etc/yum.repos.d -type f -name 'epel*' -a ! -name 'epel-cisco*' -print0 | xargs -0 sed -Ei \
						-e 's,^#\s*(baseurl=),\1,g' \
						-e 's,^(metalink=),#\1,g' \
						-e 's,https://download.example/pub/epel/,https://mirrors.ustc.edu.cn/epel/,g' \
			&& find /etc/yum.repos.d -type f -name 'epel-cisco*' -print0 | xargs -0 sed -Ei \
						-e 's,^(metalink=),#\1,g' \
						-e 's,^(enabled=)1,\10,g' \
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
		CentOSStream | RockyLinux | AlmaLinux )
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
		CentOSStream | RockyLinux | AlmaLinux )
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
		CentOSStream | RockyLinux | AlmaLinux )
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
		Fedora | CentOSStream | RockyLinux | AlmaLinux )
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
		Fedora | CentOSStream | RockyLinux | AlmaLinux )
			dnf install -y "${packages[@]}"
			;;
		Arch | Manjaro )
			pacman -Sy --noconfirm "${packages[@]}"
			;;
	esac
}

# https://code.visualstudio.com/docs/setup/linux
install_vs_code() {
	case "${OS_NAME}" in
		Ubuntu | Debian )
			apt install -y wget gpg \
			&& wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg \
			&& install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg \
			&& sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list' \
			&& rm -f packages.microsoft.gpg \
			&& apt install -y apt-transport-https \
			&& apt update -y \
			&& apt install -y code
			;;
		Fedora | CentOSStream | RockyLinux | AlmaLinux )
			# https://computingforgeeks.com/install-visual-studio-code-on-fedora/
			rpm --import https://packages.microsoft.com/keys/microsoft.asc \
			&& sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' \
			&& dnf check-update \
			&& dnf install -y code \
			&& rpm -qi code
			;;
		Arch | Manjaro )
			pacman -S code
			;;
	esac
}

# https://linuxconfig.org/how-to-install-google-chrome-browser-on-linux
install_google_chrome() {
	case "${OS_NAME}" in
		Ubuntu | Debian )
			rm -rf google-chrome-stable_current_amd64.deb \
			&& wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
			&& apt install -y ./google-chrome-stable_current_amd64.deb \
			&& rm -rf google-chrome-stable_current_amd64.deb
			;;
		Fedora | CentOSStream | RockyLinux | AlmaLinux )
			dnf install -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
			;;
		Arch | Manjaro )
			# How to Install Google Chrome in Arch-based Linux Distributions
			# https://itsfoss.com/install-chrome-arch-linux/
			pacman -S --needed base-devel git \
			&& rm -rf google-chrome \
			&& git clone https://aur.archlinux.org/google-chrome.git \
			&& ( cd google-chrome && makepkg -si )
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
		CentOSStream | RockyLinux | AlmaLinux )
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
		Debian )
			apt install -y 'qemu-system-*'
			;;
		Ubuntu )
			# https://www.unixmen.com/how-to-install-and-configure-qemu-in-ubuntu/
			# https://ubuntu.com/server/docs/virtualization-qemu
			# https://www.tecmint.com/install-kvm-on-ubuntu/
			# https://phoenixnap.com/kb/ubuntu-install-kvm
			apt install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
			;;
		Fedora )
			dnf install -y qemu qemu-kvm libvirt-daemon libvirt bridge-utils virt-manager
			;;
		CentOSStream | RockyLinux | AlmaLinux )
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
		Debian )
			apt install -y git ninja-build python3 '*libsdl2*' '*libgtk-3*' \
						   git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev \
						   git-email \
						   libaio-dev libbluetooth-dev libbrlapi-dev libbz2-dev \
						   libcap-dev libcap-ng-dev libcurl4-gnutls-dev libgtk-3-dev \
						   libibverbs-dev libjpeg62-turbo-dev libncurses5-dev libnuma-dev \
						   librbd-dev librdmacm-dev \
						   libsasl2-dev libsdl1.2-dev libseccomp-dev libsnappy-dev libssh2-1-dev \
						   libvde-dev libvdeplug-dev libvte-dev libxen-dev liblzo2-dev \
						   valgrind xfslibs-dev \
						   libnfs-dev libiscsi-dev
			;;
		Ubuntu )
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
		CentOSStream | RockyLinux | AlmaLinux )
			# no ninja-build and SDL2, QEMU cant't be built
			dnf install -y git glib2-devel pixman-devel zlib-devel bzip2 python3 'gtk3*'
			;;
		Arch | Manjaro )
			true
			;;
	esac
}

set_hostname() {
	# Linux samba设置时,需要将Linux放在与Windows相同的组,workgroup通常为"workgroup",而不能使用默认的"mygroup".
	# 同时,Linux的hostname不能使用默认的"localhost.localdomain",
	# 需要通过下面的命令,设置新的hostname,需要重新启动.
	local hostname
	case "${OS_NAME}" in
		Fedora )
			hostname="fedora"
			;;
		CentOSStream )
			hostname="centos"
			;;
		RockyLinux )
			hostname="rocky"
			;;
		AlmaLinux )
			hostname="alma"
			;;
		Ubuntu )
			hostname="ubuntu"
			;;
		Debian )
			hostname="debian"
			;;
		Arch )
			hostname="arch"
			;;
		Manjaro )
			hostname="manjaro"
			;;
	esac
	echo "${hostname}" >/etc/hostname
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
		Fedora | CentOSStream | RockyLinux | AlmaLinux )
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
		Arch | Manjaro )
			echo "don't known how to install samba"
			;;
	esac
}

setup() {
	echo "Running setup..."
	if check_command_existence apt; then
		echo "Detected APT-based system"
		true
		# apt update && apt install -y lsb-release
	elif check_command_existence dnf; then
		echo "Detected DNF-based system"
		if ! check_command_existence lsb_release; then
			dnf install -y lsb_release
		fi
	elif check_command_existence pacman; then
		echo "Detected Pacman-based system"
		true
	else
		echo "Unsupported package manager"
		echo "Unkown system $(uname -a)"
		exit 1
	fi

	if ! check_command_existence lsb_release; then
		echo "No lsb_release command"
		exit 1
	fi

	OS_NAME="$(lsb_release -si)"
	OS_VERSION="$(lsb_release -sr)"
	# https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script

	case "${OS_NAME}" in
		Ubuntu | Debian | Fedora | CentOSStream | RockyLinux | AlmaLinux | Arch | Manjaro )
			true
			;;
		* )
			echo "Unknown Linux distribution ${OS_NAME} ${OS_VERSION}"
			exit 1
			;;
	esac

	time_command set_fastest_mirror_and_update \
	&& time_command linux_uninstall_firewall \
	&& time_command linux_disable_selinux \
	&& time_command install_basic_packages \
	&& time_command install_vs_code \
	&& time_command install_google_chrome \
	&& time_command install_qemu \
	&& time_command install_qemu_build_requirements \
	&& time_command install_openjdk \
	&& time_command set_hostname \
	&& time_command install_samba \
	&& echo "Completed!"
}

setup
