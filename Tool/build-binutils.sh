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

CURRENT_DATETIME="$(print_current_datetime)"
PACKAGE="binutils"
check_toolchain_build_type_and_set_compiler_flags "$1" "$2" "${HOST_TRIPLE}" "${PACKAGE}"
{
	dump_toolchain_build_type_and_compiler_flags

	# VERSION=2.41
	VERSION=2.43 # commit 820a77554e64dd26d8ec2b03b59846268730c8be 2024-03-22

	CONFIGURE_OPTIONS=(
		--enable-targets=all
		--disable-nls
		--disable-werror
		# https://sourceware.org/legacy-ml/binutils/2014-01/msg00341.html
		--disable-gdb --disable-gdbserver --disable-gdbsupport --disable-libdecnumber --disable-readline --disable-sim
	)

	time_command configure_build_install_package \
		"${TOOLCHAIN}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${VERSION}" "${CONFIGURE_OPTIONS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-$(print_host_os_of_triple "${HOST_TRIPLE}")-${TOOLCHAIN,,}-${BUILD_TYPE,,}-output.txt"

sync .
