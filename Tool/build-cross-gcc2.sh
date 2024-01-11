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
{
	check_toolchain_build_type_and_set_compiler_flags "$1" "$2" "${HOST_TRIPLE}" "${PACKAGE}"

	# GCC_VERSION=12.3.0
	# BINUTILS_VERSION=2.36
	GCC_VERSION=14.0.0    # commit 61d6dee992fdfa350a0c6d2a8151ec6e2844c419 2023-12-17
	BINUTILS_VERSION=2.42 # commit 9846e9c11081a1f268c867bd99b6354680d760f6 2023-12-16

	TARGETS=(
		x86_64-pc-cygwin
		x86_64-pc-mingw64
		x86_64-pc-linux
	)

	# remove ${HOST_TRIPLE}
	TARGETS=( ${TARGETS[@]/${HOST_TRIPLE}} )
	array_elements_print "${TARGETS[@]}"

	time_command build_and_install_cross_gcc_for_targets \
		"${TOOLCHAIN}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${GCC_VERSION}" "${BINUTILS_VERSION}" \
		no no "${CURRENT_DATETIME}" "${TARGETS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync .
