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
	local package="cmake"
	local tool build_type generator toolset
	visual_studio_check_tool_build_type_and_set_generator_toolset "$1" "$2"
	{
		visual_studio_dump_tool_build_type_and_generator_toolset \
			"${package}" "${tool}" "${build_type}" "${generator}" "${toolset}"

		local cmake_options=(
			-G "${generator}"
			-T "${toolset}"
			"../${package}"
		)

		# Double click the CMake.sln file, in Visual Studio IDE, set cmake as startup project, and build/debug cmake in IDE
		time_command visual_studio_pushd_cmake_msbuild_package "${package}" "${tool}" "${build_type}" CMake.sln "bin/${build_type}" "${cmake_options[@]}"

	} 2>&1 | tee "$(print_name_for_config_2 "~${current_datetime}-${package}" "${tool}" "${build_type}" output.txt)"

	sync .
}

build "$@"
