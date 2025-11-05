# MIT License

# Copyright (c) 2025 徐持恒 Xu Chiheng

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



# https://www.msys2.org
# https://packages.msys2.org
# https://github.com/msys2


# run this command twice
# pacman -Syuu --noconfirm

msys2_update_and_backup() {
	local current_datetime="$(print_current_datetime)"

	{
		local msys_packages=(
			# msys-2.0.dll
			base
			base-devel
			sys-utils
			compression
			editors
			VCS
			expect
			python
			ninja
			python-setuptools
		)

		local mingw_vcrt_packages=(
			# msvcrt.dll

			mingw-w64-x86_64-toolchain

			mingw-w64-x86_64-clang
			mingw-w64-x86_64-clang-analyzer
			mingw-w64-x86_64-clang-tools-extra

			# LLVM build requirements
			mingw-w64-x86_64-cmake
			mingw-w64-x86_64-libxml2

			# QEMU build requirements
			# https://wiki.qemu.org/Hosts/W32#Native_builds_with_MSYS2
			mingw-w64-x86_64-glib2
			mingw-w64-x86_64-pixman
			mingw-w64-x86_64-gtk3
			mingw-w64-x86_64-SDL2
			mingw-w64-x86_64-libslirp

			mingw-w64-x86_64-astyle
			mingw-w64-x86_64-connect
		)


		local mingw_ucrt_packages=(
			# ucrtbase.dll

		)

		local package
		for package in "${mingw_vcrt_packages[@]}"; do
			mingw_ucrt_packages+=( "$(echo "${package}" | sed -E -e 's/^(mingw-w64)-(x86_64-.*)$/\1-ucrt-\2/g' )" )
		done

		local all_packages=(
			"${msys_packages[@]}"
			"${mingw_vcrt_packages[@]}"
			"${mingw_ucrt_packages[@]}"
		)
		echo "packages :"
		print_array_elements "${all_packages[@]}"

		local msys_root_parent_dir="$(cd "$(cygpath -m "${MSYS2_DIR}")/.." && pwd)"
		local msys_root_base_name="$(basename "$(cygpath -m "${MSYS2_DIR}")")"
		local msys_tarball_name="${msys_root_base_name}-${current_datetime}.tar"

		pacman -Syuu --noconfirm \
		&& time_command pacman -S --needed --noconfirm --verbose "${all_packages[@]}" --downloadonly \
		&& time_command pacman -S --needed --noconfirm --verbose "${all_packages[@]}" \
		&& { echo_command pushd "${msys_root_parent_dir}" \
			&& time_command tar -cf "${msys_tarball_name}" "${msys_root_base_name}" \
			&& time_command xz_compress "${msys_tarball_name}" \
			&& time_command sha512_calculate_file "${msys_tarball_name}".xz \
			&& time_command sync . \
			&& echo_command popd;} \
		&& echo "completed"

	} 2>&1 | tee "~${current_datetime}"-msys2_update_and_backup-output.txt

	sync .

}

# mingw-w64-x86_64-make executable is mingw32-make.exe
