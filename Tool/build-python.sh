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



# Ubuntu build-essential
# https://devguide.python.org/getting-started/setup-building/
# https://stackoverflow.com/questions/8097161/how-would-i-build-python-myself-from-source-code-on-ubuntu
# https://superuser.com/questions/1412975/how-to-build-and-install-python-3-7-x-from-source-on-debian-9-8
# https://www.build-python-from-source.com/
# https://stackoverflow.com/questions/51216675/building-python-from-the-source-as-64-bit
# https://web.archive.org/web/20220907075854/https://cpython-core-tutorial.readthedocs.io/en/latest/build_cpython_windows.html

# How to compile the Python interpreter from scratch on Microsoft Windows
# https://www.youtube.com/watch?v=GqZT9EY4MGQ



build() {
	local current_datetime="$(print_current_datetime)"
	local package="python"
	local compiler linker build_type cc cxx cflags cxxflags ldflags
	check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
	{
		dump_compiler_linker_build_type_and_compiler_flags \
			"${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}"

		local configure_options=(
			--with-computed-gotos
		)
		case "${HOST_TRIPLE}" in
			*-mingw* )
				local mingw_libc=( -lbcrypt -lversion -lpathcch -lws2_32 -lole32 -luuid )
				configure_options+=( --with-libc="${mingw_libc[*]}" )
				;;
		esac

		time_command configure_build_install_package \
			"${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" "${configure_options[@]}"

	} 2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" output.txt)"

	sync .
}

build "$@"

