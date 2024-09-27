#!/usr/bin/env bash

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

open_files_in_editor() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys | *-mingw* )
			local translated_file_paths=()
			local file
			for file in "$@"; do
				translated_file_paths+=( "$(cygpath -w "${file}")" )
			done
			# echo "${translated_file_paths[@]}"
			notepad++ -multiInst -nosession -noPlugin "${translated_file_paths[@]}"
			# code --wait --new-window "${translated_file_paths[@]}"
			;;
		*-linux* )
			# code --wait --new-window "$@"
			# gedit "$@"
			kwrite "$@"
			;;
	esac
}

open_files_in_editor "$@"
