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
PACKAGE="gcc"
{
	check_toolchain_build_type_and_set_compiler_flags "$1" "$2" "${HOST_TRIPLE}" "${PACKAGE}"

	# VERSION=13.2.0
	VERSION=14.0.0 # commit 7e949ffaafb415150047127f529377502097d897 2024-01-19

	EXTRA_LANGUAGES=()

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin )
			CONFIGURE_OPTIONS=(
				# --build=x86_64-pc-cygwin
				# --host=x86_64-pc-cygwin
				# --target=x86_64-pc-cygwin
				--without-libiconv-prefix
				--without-libintl-prefix
				--with-gcc-major-version-only
				--enable-shared
				--enable-shared-libgcc
				--enable-static
				--enable-version-specific-runtime-libs
				# --enable-bootstrap
				--enable-__cxa_atexit
				--with-dwarf2
				--with-tune=generic
				# --enable-languages=c,c++,fortran,lto,objc,obj-c++,jit
				--enable-graphite
				--enable-threads=posix
				--enable-libatomic
				--enable-libgomp
				--enable-libquadmath
				--enable-libquadmath-support
				--disable-libssp
				--enable-libada
				--disable-symvers
				--with-gnu-ld
				--with-gnu-as
				--with-cloog-include=/usr/include/cloog-isl
				--without-libiconv-prefix
				--without-libintl-prefix
				--with-system-zlib
				--enable-linker-build-id
				--with-default-libstdcxx-abi=gcc4-compatible
				--enable-libstdcxx-filesystem-ts
			)
			EXTRA_LANGUAGES+=(
				lto
				fortran
				# ada
				objc
				obj-c++
				# jit
			)
			;;
		x86_64-pc-mingw64 )
			CONFIGURE_OPTIONS=(
				# --build=x86_64-w64-mingw32
				# --host=x86_64-w64-mingw32
				# --target=x86_64-w64-mingw32
				# --enable-bootstrap
				# --enable-checking=release
				# --with-arch=x86-64
				--with-tune=generic
				# --enable-languages=c,lto,c++,fortran,ada,objc,obj-c++,jit
				--enable-shared
				--enable-static
				--enable-libatomic
				--enable-threads=posix
				--enable-graphite
				--enable-fully-dynamic-string
				--enable-libstdcxx-filesystem-ts
				--enable-libstdcxx-time
				--disable-libstdcxx-pch
				--enable-lto
				--enable-libgomp
				--disable-multilib
				--disable-rpath
				# --disable-win32-registry
				# --disable-nls
				# --disable-werror
				--disable-symvers
				--with-libiconv
				--with-system-zlib
				--with-{gmp,mpfr,mpc,isl}="$(print_mingw_root_dir)"
				--with-gnu-as
				--with-gnu-ld
				--disable-libstdcxx-debug
			)
			EXTRA_LANGUAGES+=(
				lto
				fortran
				# ada
				objc
				obj-c++
				# jit
			)
			;;
		* )
			echo "unknown host : ${HOST_TRIPLE}"
			exit 1
			;;
	esac

	time_command gcc_configure_build_install_package \
		"${TOOLCHAIN}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${VERSION}" \
		"$(join_array_elements ',' "${EXTRA_LANGUAGES[@]}")" "${CONFIGURE_OPTIONS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync .

# make -k check

