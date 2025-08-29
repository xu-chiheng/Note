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

build() {
	local current_datetime="$(print_current_datetime)"
	local host_os="$(print_host_os_of_host_triple)"
	local generator toolset
	visual_studio_cmake_generator_toolset
	local package="cmake"
	{
		local cmake_options=(
			-G "${generator}"
			-T "${toolset}"
			"../${package}"
		)

		local build_type=Release
		local build_dir="${package}-${host_os,,}-build"

		local dest_dir="$(pwd)/__${host_os,,}"
		local tarball="${package}.tar"

		# Double click the CMake.sln file, in Visual Studio IDE, set cmake as startup project, and build/debug cmake in IDE

		time_command visual_studio_pushd_cmake_msbuild_package "${build_dir}" CMake.sln "${build_type}" "${dest_dir}" "${tarball}" "bin/${build_type}" "${cmake_options[@]}"

	} 2>&1 | tee "~${current_datetime}-${package}-${host_os,,}-output.txt"

	sync .
}

build "$@"
