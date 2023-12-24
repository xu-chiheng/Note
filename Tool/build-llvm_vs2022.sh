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

CURRENT_DATETIME="$(print_current_datetime)"
PACKAGE=llvm
{
	check_llvm_static_or_shared "$1"

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
		# all
		host
	)

	CMAKE_OPTIONS=(
		-G "Visual Studio 17 2022"
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

		-DLLVM_TARGETS_TO_BUILD="$(array_elements_join ';' "${TARGETS[@]}")"
		-DLLVM_ENABLE_PROJECTS="$(array_elements_join ';' "${PROJECTS[@]}")"
		-DLLVM_ENABLE_RUNTIMES="$(array_elements_join ';' "${RUNTIMES[@]}")"
		-DLLVM_BUILD_RUNTIME=ON

		-DLLVM_BUILD_TESTS=OFF
		-DLLVM_INCLUDE_TESTS=OFF
		-DLLVM_BUILD_BENCHMARKS=OFF
		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DLLVM_BUILD_EXAMPLES=OFF
		-DLLVM_INCLUDE_EXAMPLES=OFF
		-DLLVM_INCLUDE_DOCS=OFF

		-DCLANG_BUILD_TOOLS=ON
		-DCLANG_ENABLE_ARCMT=ON
		-DCLANG_ENABLE_STATIC_ANALYZER=ON
		-DCLANG_INCLUDE_TESTS=OFF
		-DCLANG_BUILD_EXAMPLES=OFF
		-DCLANG_INCLUDE_DOCS=OFF

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

	VS2022_BUILD_DIR="${SOURCE_DIR}-vs2022-build"
	# NINJA_BUILD_DIR="${SOURCE_DIR}-ninja-build"

	# https://learn.microsoft.com/en-us/visualstudio/ide/reference/devenv-command-line-switches?view=vs-2022
	# https://learn.microsoft.com/en-us/visualstudio/ide/reference/build-devenv-exe?view=vs-2022
	# https://stackoverflow.com/questions/18902628/using-devenv-exe-from-the-command-line-and-specifying-the-platform

	# devenv.exe LLVM.sln -build "Debug|x64"   -Out "../llvm-$(print_current_datetime)-output.txt"
	# devenv.exe LLVM.sln -build "Release|x64" -Out "../llvm-$(print_current_datetime)-output.txt"
	# devenv.exe LLVM.sln -clean

	# https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference?view=vs-2022
	# https://learn.microsoft.com/en-us/visualstudio/msbuild/obtaining-build-logs-with-msbuild?view=vs-2022

	# msbuild.exe -m LLVM.sln -property:Configuration=Debug   -fl -flp:logfile="../llvm-$(print_current_datetime)-output.txt";verbosity=diagnostic
	# msbuild.exe -m LLVM.sln -property:Configuration=Release -fl -flp:logfile="../llvm-$(print_current_datetime)-output.txt";verbosity=diagnostic

	rm -rf "${VS2022_BUILD_DIR}" \
	&& { time_command pushd_and_cmake "${VS2022_BUILD_DIR}" "${CMAKE_OPTIONS[@]}" \
	&& echo "double click the LLVM.sln file, in Visual Studio IDE, set clang as startup project, and build/debug clang in IDE" \
	&& echo_command popd;}

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync .
