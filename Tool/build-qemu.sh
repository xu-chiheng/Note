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

# https://wiki.qemu.org/Hosts/W32#Native_builds_with_MSYS2

# QEMU 7.1.0 can be built by GCC 12.2.0 and Clang 15.0.4 on  msys64-2022-11-07  mingw-msvcrt
# QEMU 7.2.1 8.0.0 can also be built, but it can not load the kernel.

# Quirk : 2024-03-22, QEMU must be built in ~/Tool directory， can't be built in E:/Note/Tool directory.
# QEMU build system does not support the directory symlink E:/Note ---> ~  .

# Self-built GCC has problems to build QEMU, Pre-installed GCC is OK
# ../qemu/meson.build:1:0: ERROR: Unable to detect GNU compiler type:
# gcc: fatal error: cannot execute 'cc1': CreateProcess: No such file or directory
# compilation terminated.

# 7.1.0 can be built by GCC and Clang
# 9.1.0 can only be built by GCC
# ../qemu/meson.build:321:4: ERROR: Problem encountered: Your compiler does not support __attribute__((gcc_struct)) - please use GCC instead of Clang
# A full log can be found at C:/Users/Administrator/Tool/qemu-mingw-ucrt-clang-release-build/meson-logs/meson-log.txt
# ERROR: meson setup failed


cd "$(dirname "$0")"
. "./common.sh"

CURRENT_DATETIME="$(print_current_datetime)"
PACKAGE="qemu"
check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
{
	dump_compiler_linker_build_type_and_compiler_flags

	CONFIGURE_OPTIONS=(
		--enable-gtk
		--enable-sdl
		--enable-slirp
		--disable-werror
	)

	time_command configure_build_install_package \
		"${COMPILER}" "${LINKER}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${CONFIGURE_OPTIONS[@]}"

} 2>&1 | tee "$(print_name_for_config "~${CURRENT_DATETIME}-${PACKAGE}" "${HOST_TRIPLE}" "${COMPILER}" "${LINKER}" "${BUILD_TYPE}" output.txt)"

sync .
