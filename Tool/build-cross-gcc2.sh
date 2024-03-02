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
PACKAGE=gcc
check_toolchain_build_type_and_set_compiler_flags "$1" "$2" "${HOST_TRIPLE}" "${PACKAGE}"
{
	dump_toolchain_build_type_and_compiler_flags

	# GCC_VERSION=12.3.0
	# BINUTILS_VERSION=2.36
	GCC_VERSION=14.0.0    # commit 7e949ffaafb415150047127f529377502097d897 2024-01-19
	BINUTILS_VERSION=2.43 # commit 633789901c83d6899685d9011517eb751aa31972 2024-01-19

	EXTRA_LANGUAGES=()

	EXTRA_LANGUAGES+=(
		lto
		fortran
		# ada
		objc
		obj-c++
		# jit
	)

	TARGETS=(
		x86_64-pc-cygwin
		x86_64-pc-mingw64
		x86_64-pc-linux-gnu
		aarch64-unknown-linux-gnu
		riscv64-unknown-linux-gnu
		loongarch64-unknown-linux-gnu
		# ppc64le-unknown-linux-gnu
		# sparc64-unknown-linux-gnu
		# mips64-unknown-linux-gnu
	)

	# remove ${HOST_TRIPLE}
	TARGETS=( ${TARGETS[@]/${HOST_TRIPLE}} )
	print_array_elements "${TARGETS[@]}"

	time_command build_and_install_cross_gcc_for_targets \
		"${TOOLCHAIN}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${GCC_VERSION}" "${BINUTILS_VERSION}" \
		"$(join_array_elements ',' "${EXTRA_LANGUAGES[@]}")" no no "${CURRENT_DATETIME}" "${TARGETS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-$(print_host_os_of_triple "${HOST_TRIPLE}")-${TOOLCHAIN,,}-${BUILD_TYPE,,}-output.txt"

sync .
