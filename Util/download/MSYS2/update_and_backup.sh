
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

# https://www.msys2.org
# https://packages.msys2.org
# https://github.com/msys2


# run this command twice
# pacman -Syuu --noconfirm

update_and_backup_msys2() {
    local current_datetime="$1"

    local msys_packages=(
        # msys-2.0.dll
        base
        base-devel
        compression
        editors
        git
        subversion
        mercurial
        expect
        python
        ninja
        python-setuptools
    )

    local mingw_packages=(
        # msvcrt.dll
        mingw-w64-x86_64-libxml2
        mingw-w64-x86_64-gcc
        mingw-w64-x86_64-clang
        mingw-w64-x86_64-clang-analyzer
        mingw-w64-x86_64-clang-tools-extra
        mingw-w64-x86_64-cmake
        mingw-w64-x86_64-make
        mingw-w64-x86_64-astyle
        mingw-w64-x86_64-glib2
        mingw-w64-x86_64-gtk3
        mingw-w64-x86_64-SDL2
        mingw-w64-x86_64-connect
    )


    local mingw_ucrt_packages=(
        # ucrtbase.dll

    )

    local package
    for package in "${mingw_packages[@]}"; do
        mingw_ucrt_packages+=( "$(echo "${package}" | sed -e 's/^mingw-w64-/mingw-w64-ucrt-/g' )" )
    done

    local all_packages=(
        "${msys_packages[@]}"
        "${mingw_packages[@]}"
        "${mingw_ucrt_packages[@]}"
    )
    echo "packages :"
    array_elements_print "${all_packages[@]}"

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
}

CURRENT_DATETIME="$(current_datetime)"
time_command update_and_backup_msys2 "${CURRENT_DATETIME}" 2>&1 | tee "~${CURRENT_DATETIME}"-update_and_backup_msys2-output.txt

sync .

read

# mingw-w64-x86_64-make executable is mingw32-make.exe
