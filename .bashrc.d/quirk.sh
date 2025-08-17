# MIT License

# Copyright (c) 2025 徐持恒 Xu Chiheng

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


fix_cygwin_connect_quirk() {
	# https://github.com/gotoh/ssh-connect
	# https://packages.msys2.org/package/mingw-w64-x86_64-connect?repo=mingw64

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
}

fix_cygwin_gpg_quirk() {
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
}

fix_cygwin_python_quirk() {
	local usr_bin_python_version="/usr/bin/python3.12.exe"
	local usr_bin_python
	for usr_bin_python in "/usr/bin/python.exe" "/usr/bin/python3.exe"; do
		if [ ! -f "${usr_bin_python}" ]; then
			rm -rf "${usr_bin_python}" \
			&& cp -f "${usr_bin_python_version}" "${usr_bin_python}"
		fi
	done
}

fix_mingw_mode_quirk() {
	# https://learn.microsoft.com/en-us/cpp/c-runtime-library/link-options

	local binmode_c='
#include <fcntl.h>
int _fmode = _O_BINARY; 
'
	local commode_c='
// #include <corecrt_internal_stdio.h>
int _commode = 0x0800; // _IOCOMMIT
'
	local mingw_root="$(print_mingw_root_dir)"
	local mode
	for mode in binmode commode; do
		local tmp_src="$(mktemp --suffix=.c)"
		local tmp_obj="$(mktemp --suffix=.o)"
		local target_obj="${mingw_root}/lib/${mode}.o"
		echo "${tmp_src}" "${tmp_obj}" "${target_obj}"
		local varname="${mode}_c"
		echo "${!varname}" >"${tmp_src}"
		echo_command cat "${tmp_src}"
		echo_command gcc -c -O3 -o "${tmp_obj}" "${tmp_src}"
		echo_command strip --strip-debug --discard-all -o "${tmp_obj}" "${tmp_obj}"
		echo_command objdump -h -t "${tmp_obj}"
		echo_command objdump -s -j .data "${tmp_obj}"
		# echo_command objdump -s -j .bss "${tmp_obj}"
		# echo_command objdump -d "${tmp_obj}"
		if echo_command cmp "${tmp_obj}" "${target_obj}"; then
			echo "equal"
		else
			echo "not equal"
			rm -rf "${target_obj}" \
			&& mv -f "${tmp_obj}" "${target_obj}"
		fi
		rm -rf "${tmp_src}" "${tmp_obj}"
	done
}

fix_cygwin_msys_ssh_quirk() {
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
}

fix_system_quirks_one_time() {
	if host_triple_is_windows "${HOST_TRIPLE}"; then
		if [ ! "${HOST_TRIPLE}" = "$(~/config.guess)" ]; then
			echo "host triple ${HOST_TRIPLE} not equal to the output of config.guess $(~/config.guess)"
		fi

		case "${HOST_TRIPLE}" in
			*-cygwin )
				time_command fix_cygwin_connect_quirk
				time_command fix_cygwin_gpg_quirk
				time_command fix_cygwin_python_quirk
				;;
			*-mingw* )
				time_command fix_mingw_mode_quirk
				;;
		esac

		time_command fix_cygwin_msys_ssh_quirk
	fi
}
