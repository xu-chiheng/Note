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

CURRENT_DATETIME="$(current_datetime)"
PACKAGE=gcc
{
	check_toolchain_build_type_and_set_compiler_flags "$1" "$2"

	INSTALL_EXE_DIR="bin"
	COPY_DEPENDENT_DLLS="no"

	TARGETS=(
		x86_64-pc-cygwin
		x86_64-pc-msys
		x86_64-pc-mingw64
		x86_64-pc-linux

		# The directory that should contain system headers does not exist:
		#   /mingw/include
		# make[1]: *** [Makefile:3267: stmp-fixinc] Error 1
		# rm gfdl.pod gcc.pod gcov-dump.pod gcov-tool.pod fsf-funding.pod gpl.pod cpp.pod gcov.pod lto-dump.pod
		# make[1]: Leaving directory '/c/Users/Administrator/Tool/gcc-x86_64-pc-mingw64-release-build/gcc'
		# make: *** [Makefile:4285: all-gcc] Error 2







		# *** ld does not support target x86_64-pc-coff
		# *** see ld/configure.tgt for supported targets

		# *** BFD does not support target x86_64-pc-coff.
		# *** Look in bfd/config.bfd for supported targets.

		# *** Configuration x86_64-pc-pe not supported
		# make: *** [Makefile:4211: configure-gcc] Error 1

		# both x86_64-coff and x86_64-pe do not work


		# for x86_64-pc-mingw64 to x86_64-pc-cygwin cross compiling, has the following error:
		# checking how to run the C preprocessor... /lib/cpp
		# configure: error: in `/e/Note/Tool/gcc-x86_64-pc-cygwin-release-build/x86_64-pc-cygwin/libgcc':
		# configure: error: C preprocessor "/lib/cpp" fails sanity check
		# See `config.log' for more details
		# make: *** [Makefile:13996: configure-target-libgcc] Error 1
		# x86_64-pc-cygwin


		# for x86_64-pc-cygwin to x86_64-pc-mingw64 cross compiling, has the following error:
		# ../../../gcc/libgcc/libgcc2.c:2276:10: fatal error: windows.h: No such file or directory
		#  2276 | #include <windows.h>
		#       |          ^~~~~~~~~~~
		# compilation terminated.

		# for non cross compiling, has the following error:
		# The directory that should contain system headers does not exist:
		# /mingw/include
		# make[1]: *** [Makefile:3267: stmp-fixinc] Error 1
		# rm gfdl.pod gcc.pod gcov-dump.pod gcov-tool.pod fsf-funding.pod gpl.pod cpp.pod gcov.pod lto-dump.pod
		# make[1]: Leaving directory '/c/Users/Administrator/Tool/gcc-x86_64-pc-mingw64-release-build/gcc'
		# make: *** [Makefile:4285: all-gcc] Error 2
		# x86_64-pc-mingw64

		# *** Configuration x86_64-windows-pe not supported
		# make: *** [Makefile:4222: configure-gcc] Error 1
		# but Clang support this target
		# x86_64-windows-pe

	)

	time_command do_build_and_install_cross_gcc_for_targets \
		"${BUILD_TYPE}" no no "${HOST_TRIPLE}" "${CURRENT_DATETIME}" "${PACKAGE}" "${INSTALL_EXE_DIR}" "${COPY_DEPENDENT_DLLS}" \
		"${TARGETS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync
