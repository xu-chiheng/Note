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

CURRENT_DATETIME="$(current_datetime)"
PACKAGE="gdb"
{
	check_toolchain_build_type_and_set_compiler_flags "$1" "$2"

	VERSION=13.2
	GIT_TAG="$(git_tag_of_package_version "${PACKAGE}" "${VERSION}")"
	GIT_REPO_URL="$(git_repo_url_of_package "${PACKAGE}")"

	CONFIGURE_OPTIONS=(
		--disable-nls
		--disable-werror
		--disable-gas --disable-binutils --disable-ld --disable-gprof
	)

	time_command configure_build_install_package \
		"${BUILD_TYPE}" "${HOST_TRIPLE}" \
		"${PACKAGE}" "${VERSION}" "${GIT_TAG}" "${GIT_REPO_URL}" \
		"${CONFIGURE_OPTIONS[@]}"

} 2>&1 | tee "~${CURRENT_DATETIME}-${PACKAGE}-output.txt"

sync
