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


# $ type umask
# umask is a shell builtin
# https://askubuntu.com/questions/44542/what-is-umask-and-how-does-it-work
# https://www.liquidweb.com/kb/what-is-umask-and-how-to-use-it-effectively/
# https://phoenixnap.com/kb/what-is-umask
# The umask setting is inherited by processes started from the same shell. For example, start the text editor GEdit by executing gedit in the terminal and save a file using gedit. You'll notice that the newly created file is affected by the same umask setting as in the terminal.

# umask 133
# new file mode is 644

# default umask is 022, default new file mode is 755


set_environment_variables_at_bash_startup() {
	export HOST_TRIPLE="$(~/config.guess)"
	export TZ=Asia/Shanghai
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export EDITOR=~/editor.sh
	export GPG_ENCRYPTION_RECIPIENT="chiheng.xu@gmail.com"

	case "${HOST_TRIPLE}" in
		# https://www.joshkel.com/2018/01/18/symlinks-in-windows/
		# https://www.cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks
		# https://stackoverflow.com/questions/32847697/windows-specific-git-configuration-settings-where-are-they-set/32849199#32849199

		# https://superuser.com/questions/550732/use-mklink-in-msys
		# https://superuser.com/questions/526736/how-to-run-internal-cmd-command-from-the-msys-shell

		x86_64-pc-cygwin )
			# For Cygwin, add an environment variable, CYGWIN, and make sure it contains winsymlinks:nativestrict. See the Cygwin manual for details. (If you don’t do this, then Cygwin defaults to emulating symlinks by using special file contents that it understands but non-Cygwin software doesn’t.)
			# default setting works
			# export CYGWIN=winsymlinks:nativestrict
			;;
		x86_64-pc-msys | x86_64-pc-mingw64 )
			# For MSYS / MinGW (this includes the command-line utilities that used in the git-bash shell), add an environment variable, MSYS, and make sure it contains winsymlinks:nativestrict. (If you don’t do this, then symlinks are “emulated” by copying files and directories. This can be surprising, to say the least.)
			export MSYS=winsymlinks:nativestrict
			;;
	esac

	local prepend_packages_bin_dirs_to_path=yes
	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			if [ -v VSINSTALLDIR ]; then
				# Visual Studio, MSVC bin dirs has been prepended to PATH
				# if prepend packages bin dirs to PATH, will shadow the MSVC bin dirs
				prepend_packages_bin_dirs_to_path=no
			fi
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-mingw64 | *-linux )
			local packages_dir="$(print_packages_dir "${HOST_TRIPLE}")"
			local packages=( gcc binutils gdb cross-gcc llvm cmake bash make )
			local bin_dirs=()
			local package
			for package in "${packages[@]}"; do
				bin_dirs+=( "${packages_dir}/${package}/bin" )
			done

			if [ "${prepend_packages_bin_dirs_to_path}" = yes ]; then
				export PATH="$(array_elements_join ':' "${bin_dirs[@]}" "${PATH}")"
			fi
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			local notepadpp_dir="$(cygpath -u 'C:\Program Files\Notepad++')"
			local youtube_dl_dir="$(cygpath -u 'D:\youtube-dl')"
			local ultraiso_dir="$(cygpath -u 'C:\Program Files (x86)\UltraISO')"
			local chrome_dir="$(cygpath -u 'C:\Program Files\Google\Chrome\Application')"
			export PATH="$(array_elements_join ':' "${PATH}" "${notepadpp_dir}" "${youtube_dl_dir}" "${ultraiso_dir}" "${chrome_dir}" )"
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			export BROWSER=chrome
			;;
	esac

	case "${HOST_TRIPLE}" in
		*-linux )
			# https://superuser.com/questions/96151/how-do-i-check-whether-i-am-using-kde-or-gnome
			case "${DESKTOP_SESSION}" in
				*plasma* )
					FILE_EXPLORER=dolphin
					TERMINAL_EMULATOR=konsole
					TASK_MANAGER=ksysguard
					;;
				gnome | ubuntu )
					FILE_EXPLORER=nautilus
					TERMINAL_EMULATOR=gnome-terminal
					TASK_MANAGER=gnome-system-monitor
					;;
				* )
					echo "Unknown Desktop Environment ${DESKTOP_SESSION}"
					;;
			esac
			# https://stackoverflow.com/questions/16842014/redirect-all-output-to-file-using-bash-on-linux
			export FILE_EXPLORER TERMINAL_EMULATOR TASK_MANAGER
			;;
	esac

	local packages_dir

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin )
			local qemu_dir=$(cygpath -u 'D:\qemu')
			export PATH="$(array_elements_join ':' "${PATH}" "${qemu_dir}" )"
			;;
		x86_64-pc-mingw64 )
			# local qemu_dir=$(cygpath -u 'D:\qemu')
			# no qemu
			;;
		*-linux )
			local qemu_dir="${packages_dir}/qemu"
			export PATH="$(array_elements_join ':' "${PATH}" "${qemu_dir}/bin" )"
			;;
	esac
}

fix_system_quirks_one_time() {
	case "${HOST_TRIPLE}" in
		x86_64-pc-mingw64 )
			mingw_gcc_check_or_create_directory_links
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin )
			# Cygwin has gpg and gpg2 commands, override gpg command to gpg2
			local usr_bin_gpg="/usr/bin/gpg.exe"
			local usr_bin_gpg2="/usr/bin/gpg2.exe"
			if [ -e "${usr_bin_gpg2}" ] \
				&& ! { [ -e "${usr_bin_gpg}" ] && [ "$(readlink -f "${usr_bin_gpg}")" = "$(readlink -f "${usr_bin_gpg2}")" ] ;}; then
				if [ -e "${usr_bin_gpg}" ] && [ ! -L "${usr_bin_gpg}" ] && [ -f "${usr_bin_gpg}" ] && [ ! -e "${usr_bin_gpg}".backup ]; then
					mv -f "${usr_bin_gpg}" "${usr_bin_gpg}".backup
				fi \
				&& rm -rf "${usr_bin_gpg}" \
				&& ln -s "${usr_bin_gpg2}" "${usr_bin_gpg}"
			fi
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys )
			# Cygwin and MSYS2 has no connect command, symbolic link to MinGW's
			local usr_bin_connect="/usr/bin/connect.exe"
			local mingw_vcrt_connect_path="/mingw64/bin/connect.exe"
			local mingw_ucrt_connect_path="/ucrt64/bin/connect.exe"
			case "${HOST_TRIPLE}" in
				x86_64-pc-cygwin )
					local msys2_dir_cygwin_path="$(cygpath -u "${MSYS2_DIR}")"
					mingw_vcrt_connect_path="${msys2_dir_cygwin_path}${mingw_vcrt_connect_path}"
					mingw_ucrt_connect_path="${msys2_dir_cygwin_path}${mingw_ucrt_connect_path}"
					;;
			esac
			if ! { [ -e "${usr_bin_connect}" ] && [ ! -L "${usr_bin_connect}" ] && [ -f "${usr_bin_connect}" ] ;}; then
				# a symlink
				if [ -e "${mingw_ucrt_connect_path}" ] || [ -e "${mingw_vcrt_connect_path}" ]; then
					local mingw_connect_path
					if [ -e "${mingw_ucrt_connect_path}" ]; then
						mingw_connect_path="${mingw_ucrt_connect_path}"
					else
						mingw_connect_path="${mingw_vcrt_connect_path}"
					fi
					if ! { [ -e "${usr_bin_connect}" ] && [ "$(readlink -f "${usr_bin_connect}")" = "$(readlink -f "${mingw_connect_path}")" ] ;}; then
						rm -rf "${usr_bin_connect}" \
						&& ln -s "${mingw_connect_path}" "${usr_bin_connect}"
					fi
				else
					echo "no MinGW connect command"
					rm -rf "${usr_bin_connect}"
				fi
			else
				# not a symlink, keep it 
				true
			fi
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			# ssh uses wrong home directory in Cygwin - Server Fault
			# https://serverfault.com/questions/95750/ssh-uses-wrong-home-directory-in-cygwin
			# If your $HOME variable is set, but ssh isn't recognizing it, put this line in /etc/nsswitch.conf:
			# db_home: /cygdrive/e/Note
			# That will set the Cygwin home directory without requiring an /etc/passwd file to exist.
			# https://cygwin.com/cygwin-ug-net/ntsec.html#ntsec-mapping-nsswitch
			# sed -i -e s,'^.*\(# \)\?\(db_home:  \).*$','\2'"$HOME",g /etc/nsswitch.conf
			# cat /etc/nsswitch.conf

			# https://linux.die.net/man/1/readlink
			# https://www.geeksforgeeks.org/readlink-command-in-linux-with-examples/
			# https://serverfault.com/questions/76042/find-out-symbolic-link-target-via-command-line
			local home_unix_path="$(cygpath -u "${HOME}")"
			local ssh_home_dir="/home/${USERNAME}"
			if ! { [ -e "${ssh_home_dir}" ] && [ "$(readlink -f "${ssh_home_dir}")" = "$(readlink -f "${home_unix_path}")" ] ;}; then
				rm -rf "${ssh_home_dir}" \
				&& ln -s "${home_unix_path}" "${ssh_home_dir}"
			fi
			;;
	esac

	echo "completed"
}


print_gcc_install_dir() {
	echo "$(dirname "$(dirname "$(which gcc)")")"
}

print_mingw_root_dir() {
	case "${MSYSTEM}" in
		MINGW64 )
			# msvcrt.dll
			echo "/mingw64"
			;;
		UCRT64 )
			# ucrtbase.dll
			echo "/ucrt64"
			;;
		* )
			echo "unknown MSYSTEM : ${MSYSTEM}"
			return 1
			;;
	esac
}

print_packages_dir() {
	local host_triple="$1"
	case "${host_triple}" in
		x86_64-pc-cygwin )
			echo "$(cygpath -u 'D:\cygwin-packages')"
			;;
		x86_64-pc-mingw64 )
			case "${MSYSTEM}" in
				MINGW64 )
					# msvcrt.dll
					echo "$(cygpath -u 'D:\mingw-vcrt-packages')"
					;;
				UCRT64 )
					# ucrtbase.dll
					echo "$(cygpath -u 'D:\mingw-ucrt-packages')"
					;;
				* )
					echo "unknown MSYSTEM : ${MSYSTEM}"
					return 1
					;;
			esac
			;;
		*-linux )
			echo "/mnt/work/packages"
			;;
		* )
			echo "unknown host : ${host_triple}"
			return 1
			;;
	esac
}

mingw_gcc_check_or_create_directory_links() {
	if which gcc >/dev/null 2>&1; then
		local gcc_install_dir="$(print_gcc_install_dir)"
		mingw_gcc_check_or_create_directory_links_0 /mingw \
		&& mingw_gcc_check_or_create_directory_links_0 "${gcc_install_dir}/mingw" \
		&& mingw_gcc_check_or_create_directory_links_1 "${gcc_install_dir}" "${HOST_TRIPLE}"
	fi
}

mingw_gcc_check_or_create_directory_links_1() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local gcc_install_dir="$1"
	local host_triple="$2"
	local sysroot="${gcc_install_dir}/${host_triple}"
	if [ "${gcc_install_dir}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ -e "${sysroot}"/include ] && [ -e "${sysroot}"/lib ] \
		&& [ "$(readlink -f "${sysroot}"/include)" = "$(readlink -f "${mingw_root_dir}"/include)" ] \
		&& [ "$(readlink -f "${sysroot}"/lib)" = "$(readlink -f "${mingw_root_dir}"/lib)" ] ; then
		# echo OK 1 "${sysroot}"
		return 0
	fi
	rm -rf "${sysroot}"/{include,lib} \
	&& mkdir -p "${sysroot}" \
	&& ln -s "${mingw_root_dir}"/include "${sysroot}"/include \
	&& ln -s "${mingw_root_dir}"/lib "${sysroot}"/lib
}

mingw_gcc_remove_directory_links_1() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local gcc_install_dir="$1"
	local host_triple="$2"
	local sysroot="${gcc_install_dir}/${host_triple}"
	if [ "${gcc_install_dir}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	echo_command rm -rf "${sysroot}"/{include,lib}
}

mingw_gcc_check_or_create_directory_links_0() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local sysroot="$1"
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ -e "${sysroot}" ] && [ "$(readlink -f "${sysroot}")" = "$(readlink -f "${mingw_root_dir}")" ] ; then
		# echo OK 0 "${sysroot}"
		return 0
	fi
	rm -rf "${sysroot}" \
	&& mkdir -p "${sysroot}" \
	&& rm -rf "${sysroot}" \
	&& ln -s "${mingw_root_dir}" "${sysroot}"
}

mingw_gcc_remove_directory_links_0() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local sysroot="$1"
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	echo_command rm -rf "${sysroot}"
}


# https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-a-bash-array-into-a-delimited-string
# https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a
# https://zaiste.net/posts/how-to-join-elements-of-array-bash/
array_elements_join() {
	local IFS="$1"
	shift
	echo "$*"
}

array_elements_print() {
	local element
	for element in "$@"; do
		echo "		${element}"
	done
}

echo_command() {
	echo "$@" " # at $(pwd)"
	"$@"
}

time_command() {
	echo "$@" " # at $(pwd) started"
	if time "$@"; then
		echo "$@" " # at $(pwd) finished"
		return 0
	else
		local exit_status=$?
		echo "$@" " # at $(pwd) failed with exit status ${exit_status}"
		return "${exit_status}"
	fi
}

show_command_output_in_editor() {
	local output="$1"
	shift 1

	time_command "$@" >"${output}" 2>&1

	${EDITOR} "${output}"

	rm -rf "${output}"
}

parallel_make() {
	make -j "$(expr $(nproc --all) '*' 2)" "$@"
}

linux_terminal_execute_raw() {
	# konsole must specify --workdir=..., otherwise, different konsole instances will interfere
	case "${TERMINAL_EMULATOR}" in
		konsole )
			nohup "${TERMINAL_EMULATOR}" --nofork  --workdir="$(pwd)" -e "$@" &
			;;
		gnome-terminal )
			nohup "${TERMINAL_EMULATOR}" --working-directory="$(pwd)" -- "$@" &
			;;
	esac
}

linux_terminal_execute_bash_-i() {
	linux_terminal_execute_raw bash -i "$@"
}

print_current_datetime() {
	date +"%Y-%m-%d-%H-%M-%S"
}

chmod_644_recently_modified_files() {
	if [ ! -d .git ]; then
		return 1
	fi
	# https://www.google.com/search?q=linux+find+recently+modified+files
	# https://www.baeldung.com/linux/recently-changed-files
	# https://unix.stackexchange.com/questions/33850/list-of-recently-modified-files
	find . -type f -regextype posix-extended -regex '.*\.(txt|c|h|cxx|cc|cpp|hpp|java)' -mtime -1 \
	-print0 | xargs -0 -n100 \
	chmod --verbose 644
}

ask_for_confirmation() {
	local confirmation_string="$1"

	echo "you must type '${confirmation_string}' to do this operation :"
	local input
	read input
	if [ "${input}" = "${confirmation_string}" ]; then
		true
	else
		false
	fi
}

echo_multi_line() {
	local arg
	local limit=200
	local limit_plus_one="$(("${limit}" + 1))"
	local length=0
	local args=()
	for arg in "$@"; do
		length="$(("${length}" + "${#arg}" + 1))"
		if [ "${length}" -gt "${limit_plus_one}" ]; then
			echo "${args[@]}"
			length="$(("${#arg}" + 1))"
			args=( "${arg}" )
		else
			args+=( "${arg}" )
		fi
	done
	# remainder args
	echo "${args[@]}"
}

xz_compress() {
	time_command xz -zT0 "$@"
}

xz_decompress() {
	time_command xz -dT0 "$@"
}

# https://www.geeksforgeeks.org/create-a-password-generator-using-shell-scripting/
# https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
# https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
password_generate() {
	local i
	for i in $(seq 1 40);
	do
		# openssl rand -help
		# openssl rand -base64 48
		# openssl rand -hex 64
		tr -cd '[:alnum:]' < /dev/urandom | fold -w100 | head -n1
	done
}

# https://stackoverflow.com/questions/2556190/random-number-from-a-range-in-a-bash-script
port_number_generate() {
	local i
	for i in $(seq 1 40);
	do
		shuf -i 2000-65000 -n 1
	done
}

# https://stackoverflow.com/questions/4544669/batch-convert-latin-1-files-to-utf-8-using-iconv
iconv_text_files_to_UTF-8() {
	local from_encoding="$1"
	if [ -z "${from_encoding}" ] ; then
		echo "no from encoding"
		return 1
	fi
	if iconv -l | grep "${from_encoding}"; then
		true
	else
		echo "unsupported from encoding : ${from_encoding}"
		return 1
	fi

	find . -type f -regextype posix-extended -regex '.*\.(txt|c|h|s|cxx|cc|cpp|hpp|java|sh|pl|py)' \
	-print0 | xargs -0 -n1 -P0 \
	bash -c 'do_iconv_to_UTF-8() { local file="$1"; echo "${file}"; if iconv -f "'"${from_encoding}"'" -t UTF-8 "${file}" >"${file}".temp; then mv -f "${file}".temp "${file}"; else rm -rf "${file}".temp ; fi;}; do_iconv_to_UTF-8 "$@" ;' -
}

# https://en.wikibooks.org/wiki/Regular_Expressions/POSIX-Extended_Regular_Expressions
# https://www.gnu.org/software/findutils/manual/html_node/find_html/posix_002dextended-regular-expression-syntax.html
format_source_files() {
	find . -type f -regextype posix-extended -regex '.*\.(c|h|cxx|cc|cpp|hpp)' \
	-print0 | xargs -0 -n100 -P0 \
	astyle --suffix=none --style=linux --indent=tab --lineend=linux
}

dos2unix_source_files() {
	find . -type f -regextype posix-extended -regex '.*\.(txt|c|h|s|cxx|cc|cpp|hpp|java|sh|pl|py)' \
	-print0 | xargs -0 -n100 -P0 \
	dos2unix --keepdate
}

remove_temp_files() {
	find . -type f -regextype posix-extended -regex '.*(\.(orig|rej|bak)|output.txt)' \
	-print0 | xargs -0 -n100 \
	rm -rf
}

# remove the test suite directories of GCC, LLVM, and maybe others
remove_test_suite_dirs() {
	case "$(basename "$(pwd)")" in
		gcc | llvm | glibc )
			find . -type d -regextype posix-extended -regex ".*/(test|unittests|testsuite)" \
			-print0 | xargs -0 -n100 \
			rm -rf
			;;
	esac
}

# https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory
clean_or_hide_windows_home_dir_entries() {
	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-mingw64 | x86_64-pc-msys )
			true
			;;
		* )
			echo "unsupported host ${HOST_TRIPLE}"
			return 1
			;;
	esac

	local dir_entries_to_delete=(
		.Xauthority .viminfo .emacs.d .bash_history .serverauth.* .cache .kde .local .mozilla .pki .pylint.d .python_history .lesshst .wget-hsts
		ansel source .ms-ad .m2 .p2 _build .cgdb .dotnet .fltk .fvwm .ncftp .qt .source-highlight .kde4 .templateengine
	)

	echo_multi_line "dir entries to delete :" "${dir_entries_to_delete[@]}"
	echo_command rm -rf "${dir_entries_to_delete[@]}"

	local dir_entries_to_hide=(
		.*
		"3D Objects" AppData Contacts Desktop Downloads Favorites Links Music Pictures Public "Saved Games" Searches Videos Documents OneDrive
		~shortcuts_ config.guess editor.sh github-recovery-codes.txt
	)

	echo_multi_line "dir entries to hide :" "${dir_entries_to_hide[@]}"
	local dir_entry
	for dir_entry in "${dir_entries_to_hide[@]}"; do
		if [ -e "${dir_entry}" ]; then
			echo_command attrib +H "${dir_entry}"
		fi
	done

	echo "completed"
}
