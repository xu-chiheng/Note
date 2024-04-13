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

print_host_triple() {
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

	# fall back
	~/config.guess
}

print_host_triple_2() {
	local host_triple="$(print_host_triple)"
	case "${host_triple}" in
		*-linux* )
			# x86_64-pc-linux-gnu  ---> x86_64-linux-gnu
			echo "${host_triple}" | sed -E -e 's/^([^-]+)-([^-]+)-(([^-]+)(-([^-]+))?)$/\1-\3/g'
			;;
		* )
			echo "${host_triple}"
			;;
	esac
}

set_environment_variables_at_bash_startup() {
	export HOST_TRIPLE="$(print_host_triple_2)"
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
			export CYGWIN=winsymlinks:native
			;;
		x86_64-pc-msys | x86_64-pc-mingw64 )
			# For MSYS / MinGW (this includes the command-line utilities that used in the git-bash shell), add an environment variable, MSYS, and make sure it contains winsymlinks:nativestrict. (If you don’t do this, then symlinks are “emulated” by copying files and directories. This can be surprising, to say the least.)
			export MSYS=winsymlinks:native
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
	if [ "${prepend_packages_bin_dirs_to_path}" = yes ]; then
		case "${HOST_TRIPLE}" in
			x86_64-pc-cygwin | x86_64-pc-mingw64 | *-linux-gnu )
				local packages_dir="$(print_packages_dir "${HOST_TRIPLE}")"
				local packages=( gcc binutils gdb cross-gcc llvm cmake bash make )
				case "${HOST_TRIPLE}" in
					x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
						# share the self built QEMU
						true
						;;
					*-linux-gnu )
						packages+=( qemu )
						;;
				esac
				local bin_dirs=()
				local package
				for package in "${packages[@]}"; do
					bin_dirs+=( "${packages_dir}/${package}/bin" )
				done

				export PATH="$(join_array_elements ':' "${bin_dirs[@]}" "${PATH}")"
				;;
		esac
	fi

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			local dirs=(
				'C:\Program Files\Notepad++'
				# 'C:\Program Files\Microsoft VS Code'
				'C:\Program Files\Google\Chrome\Application'
				'C:\Program Files (x86)\UltraISO'
				'D:\qemu'
				'D:\youtube-dl'

			)
			local dirs2=()
			local dir
			for dir in "${dirs[@]}"; do
				dirs2+=( "$(cygpath -u "${dir}")" )
			done

			export PATH="$(join_array_elements ':' "${PATH}" "${dirs2[@]}")"
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			export BROWSER=chrome
			;;
	esac

	case "${HOST_TRIPLE}" in
		*-linux-gnu )
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
						echo "KDE has no plasma-systemmonitor or ksysguard"
					fi
					;;
				* )
					echo "Unknown Desktop Environment ${DESKTOP_SESSION}"
					;;
			esac
			# https://stackoverflow.com/questions/16842014/redirect-all-output-to-file-using-bash-on-linux
			export FILE_EXPLORER TERMINAL_EMULATOR TASK_MANAGER
			;;
	esac

}

fix_system_quirks_one_time() {
	if [ ! "$(print_host_triple)" = "$(~/config.guess)" ]; then
		echo "host triple not equal to the output of config.guess"
	fi

	# v2rayN has Tun mode(using sing-box as virtual NIC), so, for simplisity, SSH and all non-browser apps, 
	# which have different ways to setting sock/http proxy, does not need a proxy.

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
}

print_packages_dir() {
	local host_triple="$1"
	case "${host_triple}" in
		x86_64-pc-cygwin )
			echo "$(cygpath -u 'D:\_cygwin')"
			;;
		x86_64-pc-mingw64 )
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
		*-linux-gnu )
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

add_eclipse_workspace_prefs_files_force() {
	find .metadata -wholename '*/.settings/*.prefs' -print0 | xargs -0 bash -i -c 'print_array_elements "$@" ; time_command git add -f "$@" ;' -
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
		~shortcuts_ config.guess editor.sh github-recovery-codes.txt go
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

