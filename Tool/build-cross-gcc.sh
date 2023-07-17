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

# Release
# Debug

CURRENT_DATETIME="$(current_datetime)"
PACKAGE=gcc
{
	check_toolchain_build_type_and_set_compiler_flags "$1" "$2"

	INSTALL_EXE_DIR="bin"
	COPY_DEPENDENT_DLLS="no"

	TARGETS=(
		x86_64-elf
		aarch64-elf
		riscv64-elf
		i686-elf
		arm-eabi
		riscv32-elf

		# http://sourceware-org.1504.n7.nabble.com/Fail-to-build-gcc-with-target-arm-elf-td240634.html
		# arm-elf support was obsoleted in gcc-4.7 and dropped in gcc-4.8.
	)

	time_command do_build_and_install_cross_gcc_for_targets \
		"${BUILD_TYPE}" no yes "${HOST_TRIPLE}" "${CURRENT_DATETIME}" "${PACKAGE}" "${INSTALL_EXE_DIR}" "${COPY_DEPENDENT_DLLS}" \
		"${TARGETS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync
