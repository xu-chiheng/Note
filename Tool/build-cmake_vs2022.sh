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
PACKAGE="cmake"
{
	SOURCE_DIR="${PACKAGE}"

	CMAKE_OPTIONS=(
		-G "Visual Studio 17 2022"
		-T ClangCL
		"../${SOURCE_DIR}"
	)

	BUILD_TYPE=Release
	BUILD_DIR="${SOURCE_DIR}-vs2022-build"

	DEST_DIR="$(pwd)/__$(print_host_os_of_triple "${HOST_TRIPLE}")"
	TARBALL="${PACKAGE}.tar"

	# Double click the CMake.sln file, in Visual Studio IDE, set cmake as startup project, and build/debug cmake in IDE

	time_command visual_studio_pushd_cmake_msbuild_package "${BUILD_DIR}" CMake.sln "${BUILD_TYPE}" "${DEST_DIR}" "${TARBALL}" "bin/${BUILD_TYPE}" "${CMAKE_OPTIONS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-vs2022-output.txt"

sync .
