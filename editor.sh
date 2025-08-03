#!/usr/bin/env bash

open_files_in_editor() {
	case "${HOST_TRIPLE}" in
		*-cygwin | *-msys | *-mingw* )
			local translated_file_paths=()
			local file
			for file in "$@"; do
				translated_file_paths+=( "$(cygpath -w "${file}")" )
			done
			# echo "${translated_file_paths[@]}"

			# https://stackoverflow.com/questions/10564/how-can-i-set-up-an-editor-to-work-with-git-on-windows
			# https://docs.github.com/en/get-started/git-basics/associating-text-editors-with-git
			# https://git-scm.com/book/ms/v2/Getting-Started-First-Time-Git-Setup
			# https://npp-user-manual.org/docs/command-prompt/
			"$(cygpath -u 'C:\Program Files\Notepad++\notepad++.exe')" -multiInst -nosession -noPlugin "${translated_file_paths[@]}"

			# https://stackoverflow.com/questions/30024353/how-can-i-use-visual-studio-code-as-default-editor-for-git
			# https://docs.github.com/en/get-started/git-basics/associating-text-editors-with-git
			# https://code.visualstudio.com/docs/configure/command-line
			# "$(cygpath -u 'C:\Program Files\Microsoft VS Code\Code.exe')" --wait --new-window "${translated_file_paths[@]}"
			;;
		*-linux* )
			# code --wait --new-window "$@"
			# gedit "$@"
			kwrite "$@"
			;;
		* )
			echo "unknown host : ${HOST_TRIPLE}"
			return 1
			;;
	esac
}

open_files_in_editor "$@"
