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
# https://stackoverflow.com/questions/53084815/compile-qemu-under-windows-10-64-bit-for-windows-10-64-bit
# https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-qemu/PKGBUILD

# QEMU 7.1.0 can be built by GCC 12.2.0 and Clang 15.0.4 on  msys64-2022-11-07  mingw-msvcrt
# QEMU 7.2.1 8.0.0 can also be built, but it can not load the kernel.

cd "$(dirname "$0")"
. "./common.sh"

CURRENT_DATETIME="$(current_datetime)"
PACKAGE="qemu"
{
	check_toolchain_build_type_and_set_compiler_flags "$1" "$2"

	VERSION=7.1.0
	GIT_TAG="v${VERSION}"
	GIT_REPO_URL="https://gitlab.com/qemu-project/qemu.git"
	SOURCE_DIR="qemu"

	case "${HOST_TRIPLE}" in
		x86_64-pc-mingw64 )
			INSTALL_EXE_DIR="."
			COPY_DEPENDENT_DLLS="yes"
			;;
		*-linux )
			INSTALL_EXE_DIR="bin"
			COPY_DEPENDENT_DLLS="no"
			;;
		* )
			echo "unsupported host name : ${HOST_TRIPLE}"
			exit
			;;
	esac

	GIT_DEFAULT_BRANCH="master"

	CONFIGURE_OPTIONS=(
		--enable-gtk
		--enable-sdl
		--disable-werror
	)

	time_command configure_build_install_package \
		"${BUILD_TYPE}" "${SOURCE_DIR}" true \
		"${HOST_TRIPLE}" "${PACKAGE}" "${VERSION}" "${GIT_TAG}" "${GIT_REPO_URL}" "${INSTALL_EXE_DIR}" "${COPY_DEPENDENT_DLLS}" "${GIT_DEFAULT_BRANCH}" \
		"${CONFIGURE_OPTIONS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync
