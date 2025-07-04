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

print_host_triple_0() {
	case "$(uname -m)" in
		x86_64 )
			case "$(uname -o)" in
				GNU/Linux )
					echo "x86_64-pc-linux-gnu"
					return 0
					;;
				Cygwin )
					echo "x86_64-pc-cygwin"
					return 0
					;;
				Msys )
					case "$(uname -s)" in
						MSYS_NT-* )
							echo "x86_64-pc-msys"
							return 0
						;;
						MINGW64_NT-* )
							echo "x86_64-pc-mingw64"
							return 0
						;;
					esac
					;;
			esac
			;;
	esac

	# fallback
	~/config.guess
}

print_host_triple() {
	local host_triple="$(print_host_triple_0)"
	if host_triple_is_linux "${HOST_TRIPLE}"; then
		# x86_64-pc-linux-gnu  ---> x86_64-linux-gnu
		echo "${host_triple}" | sed -E -e 's/^([^-]+)-([^-]+)-(([^-]+)(-([^-]+))?)$/\1-\3/g'
	else
		echo "${host_triple}"
	fi
}

host_triple_is_windows() {
	local host_triple="$1"
	case "${host_triple}" in
		*-cygwin | *-msys | *-mingw* )
			true
			;;
		* )
			false
			;;
	esac
}

host_triple_is_linux() {
	local host_triple="$1"
	case "${host_triple}" in
		*-linux* )
			true
			;;
		* )
			false
			;;
	esac
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

print_ssh_os_of_triple() {
	local host_triple="$1"
	case "${host_triple}" in
		*-msys | *-mingw* )
			# msys-2.0.dll
			echo "msys"
			;;
		*-cygwin )
			# cygwin1.dll
			echo "cygwin"
			;;
		*-linux* )
			echo "linux"
			;;
		* )
			echo "unknown host : ${host_triple}"
			return 1
			;;
	esac
}

# Note : this function can't print any message, otherwise, FileZilla and WinSCP can't connect to this VPS through SFTP(FTP over SSH).
set_environment_variables_at_bash_startup() {
	export HOST_TRIPLE="$(print_host_triple)"
	export TZ=Asia/Shanghai
	# export TZ=America/Los_Angeles
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export EDITOR=~/editor.sh

	if host_triple_is_windows "${HOST_TRIPLE}"; then
		case "${HOST_TRIPLE}" in
			# https://www.joshkel.com/2018/01/18/symlinks-in-windows/
			# https://www.cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks
			# https://stackoverflow.com/questions/32847697/windows-specific-git-configuration-settings-where-are-they-set/32849199#32849199

			# https://superuser.com/questions/550732/use-mklink-in-msys
			# https://superuser.com/questions/526736/how-to-run-internal-cmd-command-from-the-msys-shell

			*-cygwin )
				# For Cygwin, add an environment variable, CYGWIN, and make sure it contains winsymlinks:nativestrict. See the Cygwin manual for details. (If you don’t do this, then Cygwin defaults to emulating symlinks by using special file contents that it understands but non-Cygwin software doesn’t.)
				# default setting works
				export CYGWIN=winsymlinks:native
				;;
			*-msys | *-mingw* )
				# For MSYS / MinGW (this includes the command-line utilities that used in the git-bash shell), add an environment variable, MSYS, and make sure it contains winsymlinks:nativestrict. (If you don’t do this, then symlinks are “emulated” by copying files and directories. This can be surprising, to say the least.)
				export MSYS=winsymlinks:native
				;;
		esac
	fi

	if host_triple_is_windows "${HOST_TRIPLE}" && [ -v VSINSTALLDIR ]; then
		# Visual Studio, MSVC bin dirs has been prepended to PATH
		# if prepend packages bin dirs to PATH, will shadow the MSVC bin dirs
		if [ -v VCPKG_DIR ]; then
			export PATH="$(join_array_elements ':' "$(cygpath -u "${VCPKG_DIR}")" "${PATH}")"
		fi
	else
		case "${HOST_TRIPLE}" in
			*-mingw* )
				local mingw_root_dir="$(print_mingw_root_dir)"
				local mingw_root_dir_2="$(cygpath -m "${mingw_root_dir}")"
				export PATH="$(join_array_elements ':' "${mingw_root_dir}/bin" "${PATH}")"
				export INCLUDE="${mingw_root_dir_2}/include"
				export LIB="${mingw_root_dir_2}/lib"
				;;
		esac

		case "${HOST_TRIPLE}" in
			*-cygwin | *-mingw* | *-linux* )
				local packages_dir="$(print_packages_dir_of_host_triple "${HOST_TRIPLE}")"
				local packages=( gcc binutils gdb cross-gcc llvm cmake bash make )
				if host_triple_is_windows "${HOST_TRIPLE}"; then
					# share the self built QEMU
					true
				else
					packages+=( qemu )
				fi

				local package

				# PATH
				local bin_dirs=()
				for package in "${packages[@]}"; do
					bin_dirs+=( "${packages_dir}/${package}/bin" )
				done
				export PATH="$(join_array_elements ':' "${bin_dirs[@]}" "${PATH}")"

				if host_triple_is_linux "${HOST_TRIPLE}"; then
					# LD_LIBRARY_PATH
					local lib_dirs=()
					for package in "${packages[@]}"; do
						lib_dirs+=( "${packages_dir}/${package}/lib" )
					done
					export LD_LIBRARY_PATH="$(join_array_elements ':' "${lib_dirs[@]}" "${LD_LIBRARY_PATH}")"
				fi
				;;
			*-msys )
				# no self built package
				true
				;;
		esac
	fi

	if host_triple_is_windows "${HOST_TRIPLE}"; then
		local dirs=(
			'C:\Program Files\Notepad++'
			# 'C:\Program Files\Microsoft VS Code'
			# 'C:\Program Files\Google\Chrome\Application'
			'C:\Program Files (x86)\UltraISO'
			'D:\qemu'
			# 'D:\youtube-dl'

		)
		local dirs2=()
		local dir
		for dir in "${dirs[@]}"; do
			dirs2+=( "$(cygpath -u "${dir}")" )
		done

		export PATH="$(join_array_elements ':' "${PATH}" "${dirs2[@]}")"

		# export BROWSER=chrome
	elif host_triple_is_linux "${HOST_TRIPLE}"; then
		# https://superuser.com/questions/96151/how-do-i-check-whether-i-am-using-kde-or-gnome
		case "${DESKTOP_SESSION}" in
			*plasma* )
				FILE_EXPLORER=dolphin
				TERMINAL_EMULATOR=konsole
				if quiet_command which plasma-systemmonitor; then
					TASK_MANAGER=plasma-systemmonitor
				elif quiet_command which ksysguard; then
					TASK_MANAGER=ksysguard
				else
					# echo "KDE has no plasma-systemmonitor or ksysguard"
					true
				fi
				;;
			* )
				# echo "Unknown Desktop Environment ${DESKTOP_SESSION}"
				true
				;;
		esac
		# https://stackoverflow.com/questions/16842014/redirect-all-output-to-file-using-bash-on-linux
		export FILE_EXPLORER TERMINAL_EMULATOR TASK_MANAGER
	fi

	source_ssh-agent_env_script
}

source_ssh-agent_env_script() {
	local ssh_agent_env_script=~/.ssh/"ssh-agent_env_$(print_ssh_os_of_triple "${HOST_TRIPLE}").sh"

	if [ -f "${ssh_agent_env_script}" ]; then
		quiet_command source "${ssh_agent_env_script}"
		if ssh-agent_is_ok; then
			return 0
		fi
	fi

	# echo "Killing ssh-agent..."
	# ssh-agent -k

	# echo "Starting ssh-agent..."
	ssh-agent -s >"${ssh_agent_env_script}" 2>/dev/null
	quiet_command chmod 600 "${ssh_agent_env_script}"

	quiet_command source "${ssh_agent_env_script}"

	# quiet_command ssh-add ~/.ssh/id_github # need password
	# echo_command ssh-add -l

	# if ! ssh-agent_is_ok; then
	# 	echo "Failed to start ssh-agent"
	# fi
	# pgrep ssh-agent | wc -l
}

ssh-agent_is_ok() {
	[ -v SSH_AUTH_SOCK ] && [ -v SSH_AGENT_PID ] && [ -S "${SSH_AUTH_SOCK}" ] && quiet_command ps -p "${SSH_AGENT_PID}"
}

fix_system_quirks_one_time() {
	if host_triple_is_windows "${HOST_TRIPLE}"; then
		if [ ! "${HOST_TRIPLE}" = "$(~/config.guess)" ]; then
			echo "host triple ${HOST_TRIPLE} not equal to the output of config.guess $(~/config.guess)"
		fi

		case "${HOST_TRIPLE}" in
			*-cygwin )
				# Cygwin has no connect.exe, use MinGW's
				local usr_bin_connect="/usr/bin/connect.exe"
				if [ -v MSYS2_DIR ]; then
					local mingw_ucrt_bin_connect="$(cygpath -u "${MSYS2_DIR}")/ucrt64/bin/connect.exe"
					if [ -f "${mingw_ucrt_bin_connect}" ]; then
						if [ ! -f "${usr_bin_connect}" ] || ! cmp --quiet "${usr_bin_connect}" "${mingw_ucrt_bin_connect}" ; then
							rm -rf "${usr_bin_connect}" \
							&& cp -f "${mingw_ucrt_bin_connect}" "${usr_bin_connect}"
						fi
					fi
				fi

				# Cygwin has gpg and gpg2 commands, override gpg command to gpg2
				local usr_bin_gpg="/usr/bin/gpg.exe"
				local usr_bin_gpg2="/usr/bin/gpg2.exe"
				if [ -f "${usr_bin_gpg2}" ] ; then
					if [ -f "${usr_bin_gpg}" ] && [ ! -f "${usr_bin_gpg}".backup ]; then
						mv -f "${usr_bin_gpg}" "${usr_bin_gpg}".backup
					fi \
					&& if [ ! -f "${usr_bin_gpg}" ] || ! cmp --quiet "${usr_bin_gpg}" "${usr_bin_gpg2}" ; then
						rm -rf "${usr_bin_gpg}" \
						&& cp -f "${usr_bin_gpg2}" "${usr_bin_gpg}"
					fi
				fi
		esac

		# ssh uses wrong home directory in Cygwin - Server Fault
		# https://serverfault.com/questions/95750/ssh-uses-wrong-home-directory-in-cygwin

		# https://linux.die.net/man/1/readlink
		# https://www.geeksforgeeks.org/readlink-command-in-linux-with-examples/
		# https://serverfault.com/questions/76042/find-out-symbolic-link-target-via-command-line
		local home_unix_path="$(cygpath -u "${HOME}")"
		local ssh_home_dir="/home/${USERNAME}"
		if ! { [ -e "${ssh_home_dir}" ] && [ "$(readlink -f "${ssh_home_dir}")" = "$(readlink -f "${home_unix_path}")" ] ;}; then
			rm -rf "${ssh_home_dir}" \
			&& ln -s "${home_unix_path}" "${ssh_home_dir}"
		fi
	fi
}

print_packages_dir_of_host_triple() {
	local host_triple="$1"
	case "${host_triple}" in
		*-cygwin )
			echo "$(cygpath -u 'D:\_cygwin')"
			;;
		*-mingw* )
			case "${MSYSTEM}" in
				MINGW64 )
					# msvcrt.dll
					echo "$(cygpath -u 'D:\_mingw-vcrt')"
					;;
				UCRT64 )
					# ucrtbase.dll
					echo "$(cygpath -u 'D:\_mingw-ucrt')"
					;;
				* )
					echo "unknown MSYSTEM : ${MSYSTEM}"
					return 1
					;;
			esac
			;;
		*-linux* )
			echo "/mnt/work/_linux"
			;;
		* )
			echo "unknown host : ${host_triple}"
			return 1
			;;
	esac
}

# https://stackoverflow.com/questions/1527049/how-can-i-join-elements-of-a-bash-array-into-a-delimited-string
# https://dev.to/meleu/how-to-join-array-elements-in-a-bash-script-303a
# https://zaiste.net/posts/how-to-join-elements-of-array-bash/
join_array_elements() {
	local IFS="$1"
	shift
	echo "$*"
}

print_array_elements() {
	local element
	for element in "$@"; do
		echo "		${element}"
	done
}

quiet_command() {
	# https://stackoverflow.com/questions/18012930/how-can-i-redirect-all-output-to-dev-null
	# https://www.digitalocean.com/community/tutorials/dev-null-in-linux
	# https://www.baeldung.com/linux/silencing-bash-output
	"$@" >/dev/null 2>&1
	# "$@" &>/dev/null
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
	case "${TERMINAL_EMULATOR}" in
		konsole )
			# konsole must specify --workdir=..., otherwise, different konsole instances will interfere
			linux_launch_program_in_background "${TERMINAL_EMULATOR}" --nofork  --workdir="$(pwd)" -e "$@"
			;;
		gnome-terminal )
			linux_launch_program_in_background "${TERMINAL_EMULATOR}" --working-directory="$(pwd)" -- "$@"
			;;
	esac
}

linux_terminal_execute_bash_-i() {
	linux_terminal_execute_raw bash -i "$@"
}

print_current_datetime() {
	date +"%Y-%m-%d-%H-%M-%S"
}

chmod_644_recently_modified_files_in_current_dir() {
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

# https://stackoverflow.com/questions/4544669/batch-convert-latin-1-files-to-utf-8-using-iconv
iconv_text_files_to_UTF-8_in_current_dir() {
	local from_encoding="$1"
	if [ -z "${from_encoding}" ] ; then
		echo "no from encoding"
		return 1
	fi
	if iconv -l | grep -E "${from_encoding}"; then
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
format_source_files_in_current_dir() {
	find . -type f -regextype posix-extended -regex '.*\.(c|h|cxx|cc|cpp|hpp)' \
	-print0 | xargs -0 -n100 -P0 \
	astyle --suffix=none --style=linux --indent=tab --lineend=linux
}

dos2unix_source_files_in_current_dir() {
	find . -type f -regextype posix-extended -regex '.*\.(txt|c|h|s|cxx|cc|cpp|hpp|java|sh|pl|py)' \
	-print0 | xargs -0 -n100 -P0 \
	dos2unix --keepdate
}

remove_temp_files_in_current_dir() {
	find . -type f -regextype posix-extended -regex '.*(\.(orig|rej|bak)|output.txt)' \
	-print0 | xargs -0 -n100 \
	rm -rf
}

remove_all_dirs_in_current_dir() {
	find . -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 rm -rf
}

# https://www.geeksforgeeks.org/create-a-password-generator-using-shell-scripting/
# https://www.howtogeek.com/howto/30184/10-ways-to-generate-a-random-password-from-the-command-line/
# https://unix.stackexchange.com/questions/230673/how-to-generate-a-random-string
password_generate_one() {
	# openssl rand -help
	# openssl rand -base64 48
	# openssl rand -hex 64
	tr -cd '[:alnum:]' < /dev/urandom | fold -w100 | head -n1
}

password_generate() {
	for i in $(seq 1 40); do
		password_generate_one
	done
}

# https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory
windows_clean_or_hide_home_dir_entries() {
	if ! host_triple_is_windows "${HOST_TRIPLE}"; then
		echo "unsupported host ${HOST_TRIPLE}"
		return 1
	fi

	cd ~

	local dir_entries_to_delete=(
		.Xauthority .viminfo .emacs.d .bash_history .serverauth.* .cache .kde .local .mozilla .pki .pylint.d .python_history .lesshst .wget-hsts
		ansel source .ms-ad _build .cgdb .dotnet .fltk .fvwm .ncftp .qt .source-highlight .kde4 .templateengine
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

# https://superuser.com/questions/198525/how-can-i-execute-a-windows-command-line-in-background
# https://stackoverflow.com/questions/21031171/how-to-run-a-command-in-the-background-on-windows
# https://stackoverflow.com/questions/31164253/how-to-open-url-in-microsoft-edge-from-the-command-line
windows_launch_program_in_background() {
	if ! host_triple_is_windows "${HOST_TRIPLE}"; then
		echo "unsupported host ${HOST_TRIPLE}"
		return 1
	fi

	local program_unix_path="$(cygpath -u "$1")"
	shift 1
	local program_base_name="$(basename "${program_unix_path}")"
	local program_dir_name="$(dirname "${program_unix_path}")"

	PATH="$(join_array_elements ':' "${program_dir_name}" "${PATH}")" cmd.exe /c start /B "${program_base_name}" "$@"
}

linux_launch_program_in_background() {
	nohup "$@" >/dev/null 2>&1 &
}

print_program_dir() {
	local program="$1"
	dirname "$(which "${program}")"
}

print_program_dir_upper_dir() {
	local program="$1"
	dirname "$(print_program_dir "${program}")"
}

backup_or_restore_file_or_dir() {
	local file_or_dir="$1"
	local dir="$(dirname "${file_or_dir}")"
	local base="$(basename "${file_or_dir}")"
	if [ ! -d "${dir}" ]; then
		echo "${dir} is not a directory"
		return 1
	fi

	pushd "${dir}" \
	&& if [ ! -f "${base}".tar ]; then
		if [ ! -e "${base}" ]; then
			echo "${base} does not exist"
			return 1
		fi \
		&& tar -cvf "${base}".tar "${base}" \
		&& rm -rf "${base}".tar.sha512 \
		&& sha512_calculate_file "${base}".tar
	else
		if [ ! -f "${base}".tar.sha512 ]; then
			echo "${base}.tar.sha512 does not exist"
			return 1
		fi \
		&& if ! sha512_check_file "${base}".tar.sha512; then
			echo "${base}.tar is corrupt"
			return 1
		fi \
		&& rm -rf "${base}" \
		&& tar -xvf "${base}".tar
	fi \
	&& popd
}

# https://stackoverflow.com/questions/2556190/random-number-from-a-range-in-a-bash-script
port_number_generate() {
	local start="$1"
	if [ -z "${start}" ]; then
		start=10000
	fi
	shuf -i "${start}"-65535 -n 1
}

email_is_valid() {
	local email="$1"
	if [ ! -z "${email}" ] && [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
		return 0  # valid
	else
		return 1  # invalid
	fi
}

windows_power_management_hibernate() {
	rundll32 powrProf.dll,SetSuspendState
}

windows_screen_lock() {
	rundll32 user32.dll,LockWorkStation
}

windows_time_synchonize() {
	# need to start "Windows Time" service
	# https://serverfault.com/questions/294787/how-do-i-force-sync-the-time-on-windows-workstation-or-server
	net start w32time
	w32tm /resync
}

# google_chrome_remove_remnant_files_after_uninstall() {
# 	rm -rf "$(cygpath -u 'C:\Program Files\Google\Chrome')"
# 	rm -rf ~/AppData/Local/Google/Chrome
# }

# microsoft_edge_remove_remnant_files_after_uninstall() {
# 	rm -rf "$(cygpath -u 'C:\Program Files (x86)\Microsoft\Edge')"
# 	rm -rf ~/AppData/Local/Microsoft/Edge
# }

