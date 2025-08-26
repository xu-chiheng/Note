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
. "./common.sh"

build() {

	local current_datetime="$(print_current_datetime)"
	local package="binutils"
	check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
	{
		dump_compiler_linker_build_type_and_compiler_flags "${package}"

		local configure_options=(
			--enable-targets=all
			--disable-nls
			--disable-werror

			--disable-gdb
			--disable-gdbserver
			--disable-gdbsupport
			--disable-libdecnumber
			--disable-readline
			--disable-sim
		)

		time_command configure_build_install_package \
			"${COMPILER}" "${LINKER}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${package}" "${configure_options[@]}"

	} 2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${HOST_TRIPLE}" "${COMPILER}" "${LINKER}" "${BUILD_TYPE}" output.txt)"

	sync .
}

build "$@"

