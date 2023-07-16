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

# Cygwin genisoimage was buggy, new version is not tested yet.
backup_current_directory_to_iso_file() {
	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-mingw64 | x86_64-pc-msys )
			true
			;;
		* )
			echo "unsupported host ${HOST_TRIPLE}"
			return 1
			;;
	esac

	local dir
	if [ -z "$1" ]; then
		dir="$(cd ..; pwd)"
	else
		dir="$(cygpath -u "$1")"
		if [ ! -d "${dir}" ]; then
			echo "$1 is not a directory"
			return 1
		fi
	fi

	local current_datetime="$(current_datetime)"
	local base="$(basename "$(pwd)")"
	local file="${base}-${current_datetime}.iso"
	local path="${dir}/${file}"

	echo "file='${file}'"
	echo "dir='${dir}'"
	echo "path='${path}'"

	# https://www.ezbsystems.com/ultraiso/cmdline.htm

	echo "remove temp files" \
	&& echo_command remove_temp_files \
	&& echo "hide sha512 files" \
	&& echo_command attrib +H '*.sha512' /S \
	&& echo "generate tree.txt" \
	&& echo_command tree -I '*.sha512' -o tree.txt \
	&& echo "creating ISO file '${file}' ......" \
	&& time_command "$(cygpath -u "${ULTRAISO}")" -volume "${current_datetime}" \
			-imax -udfdvd -directory . -output "$(cygpath -w "${path}")" \
	\
	&& echo "sync ......" \
	&& time_command sync \
	\
	&& echo "calculating SHA512 of '${file}' ......" \
	&& time_command sha512_calculate_file "${path}" \
	\
	&& time_command sync \
	&& echo_command rm -rf tree.txt \
	\
	&& echo "completed ......"
}
