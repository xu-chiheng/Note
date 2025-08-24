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
# https://llvm.org/docs/GettingStartedVS.html
# https://learn.microsoft.com/en-us/cpp/build/clang-support-msbuild
# https://learn.microsoft.com/en-us/cpp/build/clang-support-cmake
# https://stackoverflow.com/questions/57480964/how-to-create-visual-studio-projects-that-use-llvm
# https://phasetw0.com/llvm/getting-started-on-windows

CURRENT_DATETIME="$(print_current_datetime)"
PACKAGE=llvm
{
	SOURCE_DIR="${PACKAGE}"

	PROJECTS=(
		clang
		clang-tools-extra
		lld
		lldb
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
		-G "Visual Studio 17 2022"

		# v143 - Visual Studio 2022 (MSVC 14.3x)
		# v142 - Visual Studio 2019 (MSVC 14.2x)
		# v141 - Visual Studio 2017 (MSVC 14.1x)
		# v140 - Visual Studio 2015 (MSVC 14.0)
		# v120 - Visual Studio 2013 (MSVC 12.0)
		# v110 - Visual Studio 2012 (MSVC 11.0)
		# -T v143

		-T ClangCL

		# https://vcpkg.io
		# https://vcpkg.io/en/getting-started.html
		# https://learn.microsoft.com/en-us/vcpkg/
		# https://github.com/microsoft/vcpkg

		# $ vcpkg integrate install
		# Applied user-wide integration for this vcpkg root.
		# CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=D:/vcpkg/scripts/buildsystems/vcpkg.cmake"
		# All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.
		# -DCMAKE_TOOLCHAIN_FILE="$(cygpath -m "${VCPKG_DIR}")/scripts/buildsystems/vcpkg.cmake"

		# vcpkg install zlib libxml2
		# -- Could NOT find ZLIB (missing: ZLIB_LIBRARY ZLIB_INCLUDE_DIR)
		# -- Could NOT find LibXml2 (missing: LIBXML2_LIBRARY LIBXML2_INCLUDE_DIR)
		# -DZLIB_LIBRARY="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/lib/zlib.lib"
		# -DZLIB_INCLUDE_DIR="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/include"
		# -DLIBXML2_LIBRARY="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/lib/libxml2.lib"
		# -DLIBXML2_INCLUDE_DIR="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/include/libxml2"

		# vcpkg install libbacktrace
		# -- Could NOT find Backtrace (missing: Backtrace_LIBRARY Backtrace_INCLUDE_DIR)

		"../${SOURCE_DIR}/llvm"

		-DLLVM_TARGETS_TO_BUILD="$(join_array_elements ';' "${TARGETS[@]}")"
		-DLLVM_ENABLE_PROJECTS="$(join_array_elements ';' "${PROJECTS[@]}")"
		-DLLVM_ENABLE_RUNTIMES="$(join_array_elements ';' "${RUNTIMES[@]}")"
		-DLLVM_BUILD_RUNTIME=ON

		-DLLVM_BUILD_TESTS=OFF             ###
		-DLLVM_INCLUDE_TESTS=OFF           ###
		-DLLVM_BUILD_BENCHMARKS=OFF
		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DLLVM_BUILD_EXAMPLES=OFF
		-DLLVM_INCLUDE_EXAMPLES=OFF
		-DLLVM_INCLUDE_DOCS=OFF

		-DCLANG_BUILD_TOOLS=ON
		-DCLANG_ENABLE_ARCMT=ON
		-DCLANG_ENABLE_STATIC_ANALYZER=ON
		-DCLANG_INCLUDE_TESTS=OFF          ###
		-DCLANG_BUILD_EXAMPLES=OFF
		-DCLANG_INCLUDE_DOCS=OFF

		-DLLVM_USE_SYMLINKS=OFF
		-DLLVM_INSTALL_UTILS=ON

		-DLLVM_BUILD_LLVM_C_DYLIB=OFF

		# LLVM_BUILD_LLVM_DYLIB
		# LLVM_LINK_LLVM_DYLIB
		# LLVM_ENABLE_PIC

		-DBUILD_SHARED_LIBS=OFF
		# MSVC does not support this option
		# -DBUILD_SHARED_LIBS=ON
	)

	BUILD_TYPE=Release
	VS2022_BUILD_DIR="${SOURCE_DIR}-vs2022-build"

	DEST_DIR="$(pwd)/__vs2002"
	TARBALL="${PACKAGE}.tar"

	# https://learn.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches
	# https://learn.microsoft.com/en-us/visualstudio/ide/reference/build-devenv-exe
	# https://stackoverflow.com/questions/18902628/using-devenv-exe-from-the-command-line-and-specifying-the-platform

	# time_command devenv.exe LLVM.sln -build "Release|x64" -out "../~$(print_current_datetime)-llvm-vs2022-output.txt"
	# time_command devenv.exe LLVM.sln -clean

	# https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference
	# https://learn.microsoft.com/en-us/visualstudio/msbuild/obtaining-build-logs-with-msbuild

	# Double click the LLVM.sln file, in Visual Studio IDE, set clang as startup project, and build/debug clang in IDE.

	rm -rf "${VS2022_BUILD_DIR}" \
	&& { time_command pushd_and_cmake_2 "${VS2022_BUILD_DIR}" "${CMAKE_OPTIONS[@]}" \
	&& time_command visual_studio_msbuild_solution_build_type LLVM.sln "${BUILD_TYPE}" \
	&& time_command quiet_command make_tarball_and_calculate_sha512 "${DEST_DIR}" "${TARBALL}" "${BUILD_TYPE}" \
	&& echo_command popd;}

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-vs2022-output.txt"

sync .
