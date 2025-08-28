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
	local package="gcc"
	local compiler linker build_type cc cxx cflags cxxflags ldflags
	check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
	{
		dump_compiler_linker_build_type_and_compiler_flags \
			"${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}"

		local extra_languages=(
			lto
			fortran
			# ada
			objc
			obj-c++
			# jit
		)

		local targets=(
			x86_64-pc-cygwin
			x86_64-pc-mingw64
			x86_64-linux-gnu
			aarch64-linux-gnu
			riscv64-linux-gnu
			loongarch64-linux-gnu
			ppc64le-linux-gnu
			sparc64-linux-gnu
			mips64-linux-gnu
		)

		# remove ${HOST_TRIPLE}
		targets=( ${targets[@]/${HOST_TRIPLE}} )
		print_array_elements "${targets[@]}"

		time_command build_and_install_cross_gcc_for_targets \
			"${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" "$(join_array_elements ',' "${extra_languages[@]}")" \
			no "${current_datetime}" "${targets[@]}"

	} 2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" output.txt)"

	sync .
}

build "$@"
