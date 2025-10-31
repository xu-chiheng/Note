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

	# fall back
	~/config.guess
}

print_host_triple() {
	local host_triple_0="$(print_host_triple_0)"
	case "${host_triple_0}" in
		*-linux* )
			# x86_64-pc-linux-gnu  ---> x86_64-linux-gnu
			echo "${host_triple_0}" | sed -E -e 's/^([^-]+)-([^-]+)-(([^-]+)(-([^-]+))?)$/\1-\3/g'
			;;
		* )
			echo "${host_triple_0}"
			;;
	esac
}

host_triple_is_windows() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys | *-mingw* )
			true
			;;
		* )
			false
			;;
	esac
}

host_triple_is_linux() {
	case "${HOST_TRIPLE}" in
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
		MINGW32 )
			# msvcrt.dll 32-bit
			echo "/mingw32"
			;;
		MINGW64 )
			# msvcrt.dll 64-bit
			echo "/mingw64"
			;;
		UCRT64 )
			# ucrtbase.dll 64-bit
			echo "/ucrt64"
			;;
		CLANG64 )
			# clang + ucrtbase.dll 64-bit
			echo "/clang64"
			;;
		CLANG32 )
			# clang + ucrtbase.dll 32-bit
			echo "/clang32"
			;;
		CLANGARM64 )
			# clang + ucrtbase.dll ARM64
			echo "/clangarm64"
			;;
		MSYS )
			# MSYS2 runtime
			echo "/usr"
			;;
		* )
			# unknown
			echo "/mingw"
			;;
	esac
}

print_ssh_os_of_host_triple() {
	case "${HOST_TRIPLE}" in
		*-msys | *-mingw* )
			# msys-2.0.dll
			echo "Msys"
			;;
		*-cygwin )
			# cygwin1.dll
			echo "Cygwin"
			;;
		*-linux* )
			echo "Linux"
			;;
		* )
			echo "Unknown"
			;;
	esac
}

print_visual_studio_major_version() {
    local major="${VisualStudioVersion%%.*}"
    echo "${major}"
}

print_visual_studio_release_year() {
    local major="$(print_visual_studio_major_version)"
    local year="Unknown"
    case "${major}" in
        17) year="2022" ;;
        16) year="2019" ;;
        15) year="2017" ;;
        14) year="2015" ;;
        12) year="2013" ;;
        11) year="2012" ;;
        10) year="2010" ;;
    esac
    echo "${year}"
}

print_host_os_of_host_triple() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys )
			# cygwin1.dll or msys-2.0.dll
			if [ -v VSINSTALLDIR ]; then
				# Visual Studio
				local year="$(print_visual_studio_release_year)"
				echo "VS${year}"
			else
				case "${HOST_TRIPLE}" in
					*-cygwin )
						echo "Cygwin"
						;;
					*-msys )
						echo "Msys"
						;;
				esac
			fi
			;;
		*-mingw* )
			case "${MSYSTEM}" in
				UCRT64 )
					# ucrtbase.dll
					echo "MinGW_UCRT"
					;;
				MINGW64 )
					# msvcrt.dll
					echo "MinGW_VCRT"
					;;
				* )
					# unknown
					echo "MinGW"
					;;
			esac
			;;
		*-linux* )
			echo "Linux"
			;;
		* )
			echo "Unknown"
			;;
	esac
}

set_bash_PS1_for_terminal_emulator_at_bash_startup() {
	local ps1_symbol='\$'
	if { host_triple_is_windows && [ "${USERNAME}" = Administrator ]; } \
		|| { host_triple_is_linux && [ "$(id -u)" -eq 0 ]; }; then
		ps1_symbol='\[\e[1m\]#\[\e[0m\]'
	fi
	local host_os="$(print_host_os_of_host_triple)"
	local system="${host_os}"
	case "${HOST_TRIPLE}" in
		*-cygwin )
			# cygwin1.dll
			if [ -v VSINSTALLDIR ]; then
				system+="_Cygwin"
			fi
			;;
		*-msys )
			# msys-2.0.dll
			if [ -v VSINSTALLDIR ]; then
				system+="_Msys"
			fi
			;;
	esac
	# Based on the PS1(Prompt String 1) of MSYS2
	export PS1='\[\e]0;'"${system}"' \w\a\]\n\[\e[32m\]\u@\h \[\e[35m\]'"${system}"'\[\e[0m\] \[\e[33m\]\w\[\e[0m\]\n'"${ps1_symbol}"' '
	# Decode the above code
	# ChatGPT/Claude/Gemini/DeepSeek
}

set_cygwin_CYGWIN_msys_MSYS_at_bash_startup() {
	if host_triple_is_windows; then
		local value="winsymlinks:native"
		case "${HOST_TRIPLE}" in
			# https://www.joshkel.com/2018/01/18/symlinks-in-windows/
			# https://www.cygwin.com/cygwin-ug-net/using.html#pathnames-symlinks
			# https://stackoverflow.com/questions/32847697/windows-specific-git-configuration-settings-where-are-they-set/32849199#32849199

			# https://superuser.com/questions/550732/use-mklink-in-msys
			# https://superuser.com/questions/526736/how-to-run-internal-cmd-command-from-the-msys-shell

			*-cygwin )
				# For Cygwin, add an environment variable, CYGWIN, and make sure it contains winsymlinks:nativestrict. See the Cygwin manual for details. (If you don’t do this, then Cygwin defaults to emulating symlinks by using special file contents that it understands but non-Cygwin software doesn’t.)
				# default setting works
				export CYGWIN="${value}"
				;;
			*-msys | *-mingw* )
				# For MSYS / MinGW (this includes the command-line utilities that used in the git-bash shell), add an environment variable, MSYS, and make sure it contains winsymlinks:nativestrict. (If you don’t do this, then symlinks are “emulated” by copying files and directories. This can be surprising, to say the least.)
				export MSYS="${value}"
				;;
		esac
	fi
}

set_mingw_PATH_INCLUDE_LIB_at_bash_startup() {
	case "${HOST_TRIPLE}" in
		*-mingw* )
			local mingw_root_dir="$(print_mingw_root_dir)"
			local mingw_root_dir_2="$(cygpath -m "${mingw_root_dir}")"
			export PATH="$(join_array_elements ':' "${mingw_root_dir}/bin" "${PATH}")"
			export INCLUDE="${mingw_root_dir_2}/include"
			export LIB="${mingw_root_dir_2}/lib"
			;;
	esac
}

set_visual_studio_msvc_CL_at_bash_startup() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys )
			# cygwin1.dll or msys-2.0.dll
			if [ -v VSINSTALLDIR ]; then
				# https://learn.microsoft.com/en-us/cpp/build/reference/cl-environment-variables
				# https://learn.microsoft.com/en-us/cpp/build/reference/utf-8-set-source-and-executable-character-sets-to-utf-8
				# https://learn.microsoft.com/en-us/cpp/build/reference/compiler-options-listed-by-category
				# https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line
				# https://stackoverflow.com/questions/84404/using-visual-studios-cl-from-a-normal-command-line
				# for VS MSVC(cl.exe, not clang-cl.exe)
				case "${HOST_TRIPLE}" in
					*-cygwin )
						export CL="/utf-8"
						;;
					*-msys )
						# MSYS2 will modify CL from "/utf-8" to 'D:/msys64/utf-8' if invoke cl.exe from bash
						# cl : Command line warning D9024 : unrecognized source file type 'D:/msys64/utf-8', object file assumed

						# # which python; CL="/utf-8" python -c "import os; print(os.environ.get('CL'))";
						# /c/Users/Administrator/AppData/Local/Programs/Python/Python313/python
						# D:/msys64/utf-8

						export CL="-utf-8"
						;;
				esac
				# CL environment variable only exported in ~/.bashrc at bash startup, not set globally as a Windows environment variable
				# Visual Studio IDE(devenv.exe) does not get that variable, unless the IDE is launched from command line
			fi
			;;
	esac
}

set_packages_PATH_and_LD_LIBRARY_PATH_at_bash_startup() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys )
			# cygwin1.dll or msys-2.0.dll
			if [ -v VSINSTALLDIR ]; then
				# Visual Studio, MSVC bin dirs has been prepended to PATH
				# prepend packages bin dirs to PATH, to shadow the MSVC bin dirs
				local packages_dir="$(print_packages_dir_of_host_triple)"
				local packages=(
					llvm cmake
				)

				local package

				# PATH
				local bin_dirs=()
				for package in "${packages[@]}"; do
					bin_dirs+=( "${packages_dir}/${package}/bin" )
				done
				export PATH="$(join_array_elements ':' "${bin_dirs[@]}" "${PATH}")"

				# winget search python
				# winget search python | grep -E '^Python [0-9]+\.[0-9]+\s+Python.Python.'

				# from Python.org
				# winget install --id Python.Python.3.13
				# winget list | grep Python
				# winget uninstall Python.Python.3.13

				# # which python
				# /cygdrive/c/Users/Administrator/AppData/Local/Programs/Python/Python313/python

				# from Microsoft Store, does not work
				# winget install python
				# python -c "import sys; print(sys.executable)"
				# C:\Users\Administrator\AppData\Local\Microsoft\WindowsApps
				# export PATH="$(join_array_elements ':' "$(dirname "$(readlink "$(cygpath -u "${LOCALAPPDATA}\Microsoft\WindowsApps")"/python.exe)")" "${PATH}")"
				# python3.13.exe
				return;
			fi
			;;
	esac
	case "${HOST_TRIPLE}" in
		*-cygwin | *-mingw* | *-linux* )
			local packages_dir="$(print_packages_dir_of_host_triple)"
			local packages=(
				gcc binutils gdb cross-gcc llvm cmake
				# bash make
			)
			if host_triple_is_windows; then
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

			if host_triple_is_linux; then
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
}

set_common_windows_packages_PATH_at_bash_startup() {
	if host_triple_is_windows; then
		local dirs=(
			'D:\qemu'
			# 'D:\youtube-dl'
		)
		local dirs2=()
		local dir
		for dir in "${dirs[@]}"; do
			dirs2+=( "$(cygpath -u "${dir}")" )
		done
		export PATH="$(join_array_elements ':' "${PATH}" "${dirs2[@]}")"
	fi
}

set_other_linux_environment_variables_at_bash_startup() {
	if host_triple_is_linux; then
		# https://superuser.com/questions/96151/how-do-i-check-whether-i-am-using-kde-or-gnome
		case "${DESKTOP_SESSION}" in
			*plasma* )
				FILE_EXPLORER=dolphin
				TERMINAL_EMULATOR=konsole
				if check_command_existence plasma-systemmonitor; then
					TASK_MANAGER=plasma-systemmonitor
				elif check_command_existence ksysguard; then
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
}

# Note : this function can't print any message, otherwise, FileZilla and WinSCP can't connect to this VPS through SFTP(FTP over SSH).
set_environment_variables_at_bash_startup() {
	export HOST_TRIPLE="$(print_host_triple)"
	export TZ=Asia/Shanghai
	# export TZ=America/Los_Angeles
	export LANG=en_US.UTF-8
	export LC_ALL=en_US.UTF-8
	export EDITOR=~/editor.sh
	# global UTF-8 mode (files, strings, I/O).
	export PYTHONUTF8=1
	# just enforces UTF-8 for stdin/stdout/stderr.
	# export PYTHONIOENCODING=utf-8

	# the order is important here
	set_bash_PS1_for_terminal_emulator_at_bash_startup
	set_cygwin_CYGWIN_msys_MSYS_at_bash_startup
	set_mingw_PATH_INCLUDE_LIB_at_bash_startup
	set_visual_studio_msvc_CL_at_bash_startup
	set_packages_PATH_and_LD_LIBRARY_PATH_at_bash_startup
	set_common_windows_packages_PATH_at_bash_startup
	set_other_linux_environment_variables_at_bash_startup

	source_ssh-agent_env_script
}

source_ssh-agent_env_script() {
	local ssh_os="$(print_ssh_os_of_host_triple)"
	local ssh_agent_env_script=~/.ssh/"ssh-agent_env_${ssh_os,,}.sh"

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

print_packages_dir_of_host_triple() {
	local host_os="$(print_host_os_of_host_triple)"
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys | *-mingw*  )
			echo "$(cygpath -u 'D:\_'"${host_os,,}")"
			;;
		* )
			echo "/mnt/work/_${host_os,,}"
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

print_command_path() {
	command -v "$1"
	# which "$1"
}

# Quietly check if a command exists
check_command_existence() {
	quiet_command print_command_path "$1"
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

open_files_in_editor() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys | *-mingw* )
			local translated_file_paths=()
			local file
			for file in "$@"; do
				translated_file_paths+=( "$(cygpath -w "${file}")" )
			done
			# echo "${translated_file_paths[@]}"

			# https://stackoverflow.com/questions/10564/how-can-i-set-up-an-editor-to-work-with-git-on-windows
			# https://docs.github.com/en/get-started/git-basics/associating-text-editors-with-git
			# https://git-scm.com/book/ms/v2/Getting-Started-First-Time-Git-Setup
			# https://npp-user-manual.org/docs/command-prompt/
			local notepadpp_options=( -multiInst -nosession -noPlugin )
			if [ $# -le 1 ]; then
				notepadpp_options+=( -notabbar )
			else
				# Can't specify -notabbar if you want to open multiple files
				true
			fi
			"$(cygpath -u 'C:\Program Files\Notepad++\notepad++.exe')" "${notepadpp_options[@]}" "${translated_file_paths[@]}"

			# https://stackoverflow.com/questions/30024353/how-can-i-use-visual-studio-code-as-default-editor-for-git
			# https://docs.github.com/en/get-started/git-basics/associating-text-editors-with-git
			# https://code.visualstudio.com/docs/configure/command-line
			# "$(cygpath -u 'C:\Program Files\Microsoft VS Code\Code.exe')" --wait --new-window "${translated_file_paths[@]}"
			;;
		*-linux* )
			# code --wait --new-window "$@"
			# gedit "$@"
			kwrite "$@"
			;;
		* )
			# unknown
			# assume KDE environment
			kwrite "$@"
			;;
	esac
}

show_command_output_in_editor() {
	local output="$1"
	shift 1

	time_command "$@" >"${output}" 2>&1

	open_files_in_editor "${output}"

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
password_generate_1() {
	# How much entropy does each [:alnum:] character provide?
	# The [:alnum:] character class includes:
	# 26 uppercase letters (A–Z)
	# 26 lowercase letters (a–z)
	# 10 digits (0–9)
	# Total: 62 possible characters.
	# Entropy per character is calculated as:
	# log2(62) ≈ 5.954 bits
	# That means each alphanumeric character contributes approximately 5.95 bits of entropy.

	# How many characters are needed for 512 bits of entropy?
	# To determine the required number of characters:
	# 512 bits / 5.954 bits ≈ 86.03
	# So, to reach or exceed 512 bits of entropy using only alphanumeric characters, you need at least 87 characters.

	# Summary Table
	# Target Entropy    Bits per Character    Required Length
	# 128 bits          ≈ 5.95                22 characters
	# 256 bits          ≈ 5.95                44 characters
	# 512 bits          ≈ 5.95                87 characters

	local count="$1"
	if [ -z "${count}" ]; then
		count=1;
	fi
	local length="$2"
	if [ -z "${length}" ]; then
		length=100;
	fi
	tr -cd '[:alnum:]' < /dev/urandom | fold -w"${length}" | head -n"${count}"
}

password_generate_one() {
	password_generate_1
}

password_generate() {
	password_generate_1 100
}

# https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory
windows_clean_or_hide_home_dir_entries() {
	if ! host_triple_is_windows; then
		echo "unsupported host ${HOST_TRIPLE}"
		return 1
	fi

	# Assume current dir is home
	# cd ~

	local dir_entries_to_delete=(
		.Xauthority .viminfo .emacs.d .bash_history .serverauth.* .cache .kde .local .mozilla .pki .pylint.d .python_history .lesshst .wget-hsts
		ansel source .ms-ad _build .cgdb .dotnet .fltk .fvwm .ncftp .qt .source-highlight .kde4 .templateengine
	)

	echo "dir entries to delete :"
	echo_multi_line "${dir_entries_to_delete[@]}"
	echo_command rm -rf "${dir_entries_to_delete[@]}"

	local dir_entries_to_hide=(
		.*
		"3D Objects" AppData Contacts Desktop Downloads Favorites Links Music Pictures Public "Saved Games" Searches Videos Documents OneDrive
		~shortcuts_ config.guess editor.sh github-recovery-codes.txt
	)

	echo "dir entries to hide :"
	echo_multi_line "${dir_entries_to_hide[@]}"
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
	dirname "$(print_command_path "${program}")"
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

windows_download_executable_from_url_and_execute() {
	local executable="$1"
	local url="$2"
	shift 2
	# using Cygwin's /usr/bin/curl will have problem
	# curl: (77) error setting certificate file: /etc/pki/tls/certs/ca-bundle.crt
	# Since Windows 10, a native curl.exe is included. You can invoke it directly
	# This version uses Windows' certificate store and avoids the issue.
	local curl
	# curl="/usr/bin/curl"
	curl="$(cygpath -u 'C:\Windows\System32\curl.exe')"
	echo_command rm -rf "${executable}" \
	&& time_command "${curl}" -L -o "${executable}" "${url}" \
	&& echo_command chmod +x "${executable}" \
	&& time_command ./"${executable}" "$@" \
	&& echo_command rm -rf "${executable}"
}

# google_chrome_remove_remnant_files_after_uninstall() {
# 	rm -rf "$(cygpath -u 'C:\Program Files\Google\Chrome')"
# 	rm -rf ~/AppData/Local/Google/Chrome
# }

# microsoft_edge_remove_remnant_files_after_uninstall() {
# 	rm -rf "$(cygpath -u 'C:\Program Files (x86)\Microsoft\Edge')"
# 	rm -rf ~/AppData/Local/Microsoft/Edge
# }

print_essential_files_for_basic_setup() {
	local paths=(
		README.txt
		~git-tools~
		.gitattributes
		.gitconfig
		.gitignore
		.bash_profile
		.curlrc
		.minttyrc
		.wgetrc

		.bashrc
		.bashrc.d

		.ssh/{.gitignore,README.txt,config}
		.gnupg/{.gitignore,README.txt,gpg.conf,gpg-agent.conf}

		.config/{.gitignore,git/gitk}

		config.guess
		editor.sh

		__clean_or_hide.cmd

		Util/download/{Cygwin,MSYS2,Linux,Visual_Studio_2022_Enterprise,Windows_10_22H2_Enterprise_ISO}

		Util/other/{crypto,backup}
		Util/{linux_setup,xray-nginx,sing-box-yg,sing-box,wireguard}.sh

		Util/quirk
		Util/shell
		Util/setting/Editors
	)
	local path
	for path in "${paths[@]}"; do
		echo "${path}"
	done
}

print_essential_files_for_tool_setup() {
	local paths=(
		{eclipse-workspace,runtime-EclipseApplication}/{.gitignore,{clean,cygwin,backup_metadata_dir,git_add_-f_prefs_files}.cmd}

		IDE/{.gitignore,cygwin.cmd,README.md,patch}
		IDE/{remove_unneeded_plug-ins,generate_list_of_changed_files}.{cmd,sh,sh.txt}
		IDE/list_of{,_non}_java_files_{added,modified,deleted}.txt

		Tool/{README.txt,.gitignore,clean.sh,common.sh,_doc}
		Tool/build-{llvm{,_vs},cross-gcc{,2},binutils,gcc,gdb,qemu,cmake{,_vs},python}.sh
		Tool/_cygport/{.gitignore,cygwin.cmd,llvm.cygport}
		Tool/_patch/{bash,binutils,cmake,gcc,gdb,llvm,make,mintty,konsole,qemu,python}
		Tool/{linux.sh,{cygwin,msys,mingw_{ucrt,vcrt},vs_{cygwin,msys}}.cmd}
	)

	print_essential_files_for_basic_setup
	local path
	for path in "${paths[@]}"; do
		echo "${path}"
	done
}

copy_home_dir_files_for_basic_setup() {
	copy_home_dir_files_to_current_directory $(print_essential_files_for_basic_setup)
}

copy_home_dir_files_for_tool_setup() {
	copy_home_dir_files_to_current_directory $(print_essential_files_for_tool_setup)
}

copy_home_dir_files_to_current_directory() {
	local path
	for path in "$@"; do
		if [ -e ~/"${path}" ]; then
			echo "${path}"
			dir="$(dirname "${path}")"
			rm -rf "${path}" \
			&& mkdir -p "${dir}" \
			&& cp -rf ~/"${path}" "${dir}"
		else
			echo "${path} does not exist"
		fi
	done
	echo "Completed!"
}


