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
check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
{
	dump_compiler_linker_build_type_and_compiler_flags

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
		x86_64-elf
		aarch64-elf
		riscv64-elf
		loongarch64-elf
		sparc64-elf
		mips64-elf

		# -m32
		# i686-elf
		# arm-eabi
		# riscv32-elf
	)

	time_command build_and_install_cross_gcc_for_targets \
		"${COMPILER}" "${LINKER}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" \
		"$(join_array_elements ',' "${EXTRA_LANGUAGES[@]}")" no "${CURRENT_DATETIME}" "${TARGETS[@]}"

} 2>&1 | tee "$(print_name_for_config "~${CURRENT_DATETIME}-${PACKAGE}" "${HOST_TRIPLE}" "${COMPILER}" "${LINKER}" "${BUILD_TYPE}" output.txt)"

sync .
