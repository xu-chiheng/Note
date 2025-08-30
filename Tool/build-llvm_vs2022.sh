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

# VCToolsVersion="14.44.35207"
# VSCMD_VER="17.14.11"
# VisualStudioVersion="17.0"
# Windows SDK version 10.0.26100.0
# MSVC 19.44.35214.0
# Clang 19.1.5 with MSVC-like command-line

# https://vcpkg.io
# https://vcpkg.io/en/getting-started.html
# https://learn.microsoft.com/en-us/vcpkg/
# https://github.com/microsoft/vcpkg

# # vcpkg integrate install
# Applied user-wide integration for this vcpkg root.
# CMake projects should use: "-DCMAKE_TOOLCHAIN_FILE=C:/Program Files/Microsoft Visual Studio/2022/Enterprise/VC/vcpkg/scripts/buildsystems/vcpkg.cmake"
# All MSBuild C++ projects can now #include any installed libraries. Linking will be handled automatically. Installing new libraries will make them instantly available.
# -DCMAKE_TOOLCHAIN_FILE="$(cygpath -m "$(dirname "$(which vcpkg)")")/scripts/buildsystems/vcpkg.cmake"

# vcpkg install zlib libxml2
# -- Could NOT find ZLIB (missing: ZLIB_LIBRARY ZLIB_INCLUDE_DIR)
# -- Could NOT find LibXml2 (missing: LIBXML2_LIBRARY LIBXML2_INCLUDE_DIR)
# -DZLIB_LIBRARY="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/lib/zlib.lib"
# -DZLIB_INCLUDE_DIR="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/include"
# -DLIBXML2_LIBRARY="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/lib/libxml2.lib"
# -DLIBXML2_INCLUDE_DIR="$(cygpath -m "${VCPKG_DIR}")/installed/x86-windows/include/libxml2"

# # vcpkg install zlib libxml2
# error: Could not locate a manifest (vcpkg.json) above the current working directory.
# This vcpkg distribution does not have a classic mode instance.
# See https://learn.microsoft.com/vcpkg/troubleshoot/build-failures?WT.mc_id=vcpkg_inproduct_cli for more information.

# https://learn.microsoft.com/en-us/vcpkg/get_started/get-started-vs
# https://learn.microsoft.com/en-us/vcpkg/concepts/manifest-mode

# vcpkg install libbacktrace
# -- Could NOT find Backtrace (missing: Backtrace_LIBRARY Backtrace_INCLUDE_DIR)

build() {
	local current_datetime="$(print_current_datetime)"
	local package="llvm"
	local tool build_type generator toolset
	visual_studio_check_tool_build_type_and_set_generator_toolset "$1" "$2"
	{
		visual_studio_dump_tool_build_type_and_generator_toolset \
			"${package}" "${tool}" "${build_type}" "${generator}" "${toolset}"

		local projects=(
			clang
			clang-tools-extra
			lld
			lldb
		)

		# runtime projects are not needed to build Cross Clang
		local runtimes=(
			# compiler-rt
			# libcxx
			# libcxxabi
			# libunwind
		)

		local targets=(
			all
			# host
		)

		local cmake_options=(
			-G "${generator}"
			-T "${toolset}"
			"../${package}/llvm"

			-DLLVM_TARGETS_TO_BUILD="$(join_array_elements ';' "${targets[@]}")"
			-DLLVM_ENABLE_PROJECTS="$(join_array_elements ';' "${projects[@]}")"
			-DLLVM_ENABLE_RUNTIMES="$(join_array_elements ';' "${runtimes[@]}")"
			-DLLVM_BUILD_RUNTIME=ON

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

			-DLLVM_USE_SYMLINKS=OFF
			-DLLVM_INSTALL_UTILS=ON

			-DLLVM_BUILD_LLVM_C_DYLIB=OFF

			# LLVM_BUILD_LLVM_DYLIB
			# LLVM_LINK_LLVM_DYLIB
			# LLVM_ENABLE_PIC

			-DBUILD_SHARED_LIBS=OFF
			# MSVC does not support this option
			# message(FATAL_ERROR "BUILD_SHARED_LIBS options is not supported on Windows.")
			# -DBUILD_SHARED_LIBS=ON
		)

		# https://learn.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches
		# https://learn.microsoft.com/en-us/visualstudio/ide/reference/build-devenv-exe
		# https://stackoverflow.com/questions/18902628/using-devenv-exe-from-the-command-line-and-specifying-the-platform

		# time_command devenv.exe LLVM.sln -build Release -out "../~$(print_current_datetime)-llvm-vs2022-output.txt"
		# time_command devenv.exe LLVM.sln -clean

		# Double click the LLVM.sln file, in Visual Studio IDE, set clang as startup project, and build/debug clang in IDE.
		time_command visual_studio_pushd_cmake_msbuild_package "${package}" "${tool}" "${build_type}" LLVM.sln "${build_type}" "${cmake_options[@]}"

	} 2>&1 | tee "$(print_name_for_config_2 "~${current_datetime}-${package}" "${tool}" "${build_type}" output.txt)"

	sync .
}

build "$@"
