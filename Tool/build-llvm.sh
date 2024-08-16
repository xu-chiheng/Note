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

# https://clang.llvm.org/get_started.html
# https://llvm.org/docs/CMake.html
# https://llvm.org/docs/GettingStarted.html

# https://llvm.org/docs/AdvancedBuilds.html
# https://llvm.org/docs/BuildingADistribution.html

# https://fuchsia.dev/fuchsia-src/development/build/toolchain

# 2016 LLVM Developers’ Meeting: C. Bieneman "Developing and Shipping LLVM and Clang with CMake"
# https://www.youtube.com/watch?v=StF77Cx7pz8

# 2017 LLVM Developers’ Meeting: Petr Hosek "Compiling cross-toolchains with CMake and runtimes build"
# https://www.youtube.com/watch?v=OCQGpUzXDsY

# 2023 LLVM Dev Mtg - Understanding the LLVM build
# https://www.youtube.com/watch?v=Dnubzx8-E1M


# https://llvm.org/docs/CMakePrimer.html
# https://llvm.org/docs/AdvancedBuilds.html

CURRENT_DATETIME="$(print_current_datetime)"
PACKAGE=llvm
check_toolchain_build_type_and_set_compiler_flags "$1" "$2" "${HOST_TRIPLE}" "${PACKAGE}"
check_llvm_static_or_shared "$3"
{
	dump_toolchain_build_type_and_compiler_flags
	dump_llvm_static_or_shared

	# VERSION=12.0.1
	# VERSION=13.0.1
	# VERSION=14.0.6
	# VERSION=15.0.7
	# VERSION=16.0.6
	# VERSION=17.0.6
	# VERSION=18.1.8
	VERSION=19.0.0 # commit c5f839bd58e7f888acc4cb39a18e9e5bbaa9fb0a 2024-03-22

	SOURCE_DIR="${PACKAGE}"

	PROJECTS=(
		clang
		clang-tools-extra
		lld
		# lldb
	)

	# runtime projects are not needed to build Cross Clang
	RUNTIMES=(
		# compiler-rt
		# libcxx
		# libcxxabi
		# libunwind
	)

	TARGETS=(
		all
		# host
	)

	CMAKE_OPTIONS=(
		"../${SOURCE_DIR}/llvm"

		-DLLVM_TARGETS_TO_BUILD="$(join_array_elements ';' "${TARGETS[@]}")"
		-DLLVM_ENABLE_PROJECTS="$(join_array_elements ';' "${PROJECTS[@]}")"
		-DLLVM_ENABLE_RUNTIMES="$(join_array_elements ';' "${RUNTIMES[@]}")"
		-DLLVM_BUILD_RUNTIME=ON

		-DLLVM_OPTIMIZED_TABLEGEN=ON
		-DLLVM_ENABLE_WERROR=OFF
		-DLLVM_ENABLE_ASSERTIONS=OFF
		-DLLVM_ENABLE_BACKTRACES=OFF
		-DLLVM_ENABLE_LIBXML2=ON
		-DLLVM_ENABLE_PLUGINS=OFF
		-DLLVM_ENABLE_MODULES=OFF

		-DLLVM_BUILD_TESTS=ON
		-DLLVM_INCLUDE_TESTS=ON
		-DLLVM_BUILD_BENCHMARKS=OFF
		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DLLVM_BUILD_EXAMPLES=OFF
		-DLLVM_INCLUDE_EXAMPLES=OFF
		-DLLVM_INCLUDE_DOCS=OFF

		-DCLANG_BUILD_TOOLS=ON
		-DCLANG_ENABLE_ARCMT=ON
		-DCLANG_ENABLE_STATIC_ANALYZER=ON
		-DCLANG_INCLUDE_TESTS=ON
		-DCLANG_BUILD_EXAMPLES=OFF
		-DCLANG_INCLUDE_DOCS=OFF

		-DLLVM_INSTALL_UTILS=ON

		-DLLVM_BUILD_LLVM_C_DYLIB=OFF

	)

	case "${LLVM_STATIC_OR_SHARED}" in
		static )
			CMAKE_OPTIONS+=(
				-DBUILD_SHARED_LIBS=OFF

				-DLLVM_BUILD_LLVM_DYLIB=OFF
				-DLLVM_LINK_LLVM_DYLIB=OFF

				# On Cygwin and MinGW, it is important to explicitly set LLVM_ENABLE_PIC to OFF
				# otherwise, there is link error
				# /usr/bin/ld: error: export ordinal too large: 101192
				# caused by commit de07b1e84d8de948304766df602fee2b845e9532
				-DLLVM_ENABLE_PIC=OFF
			)
			;;
		shared )
			CMAKE_OPTIONS+=(
				-DBUILD_SHARED_LIBS=ON

				# NOTE: Important! the following 2 lines must be commented,  the 2 variables must have no initial values. Tested many times.
				# -DLLVM_BUILD_LLVM_DYLIB=OFF
				# -DLLVM_LINK_LLVM_DYLIB=OFF
				# -DLLVM_ENABLE_PIC=OFF
			)
			;;
	esac

	time_command cmake_build_install_package \
		"${TOOLCHAIN}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${VERSION}" \
		"${CC}" "${CXX}" "${CFLAGS}" "${CXXFLAGS}" "${LDFLAGS}" "${CMAKE_OPTIONS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-$(print_host_os_of_triple "${HOST_TRIPLE}")-${TOOLCHAIN,,}-${BUILD_TYPE,,}-output.txt"

sync .
