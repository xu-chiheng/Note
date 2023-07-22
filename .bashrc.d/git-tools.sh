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

git_backup_directory() {
	local base="$1"
	local tarball="$2"

	rm -rf "${base}"-*.tar{,.gpg}{,.sha512} \
	&& time_command tar -cf "${tarball}" "${base}"/{.git,'~git-tools~'} \
	&& time_command sha512_calculate_file "${tarball}"
}

git_backup_directory_to_all_drives() {
	local base="$1"
	local tarball="$2"

	time_command git_backup_directory "${base}" "${tarball}" \
	&& echo_command cp -f "${tarball}" "${tarball}".bak \
	&& time_command gpg_encrypt_file "${tarball}" \
	&& echo_command mv -f "${tarball}".bak "${tarball}" \
	&& time_command sha512_calculate_file "${tarball}".gpg \
	&& case "${HOST_TRIPLE}" in
			*-cygwin | *-msys | *-mingw64 )
				set +m; time_command copy_tarball_to_all_drives "${base}" "${tarball}";
				;;
			*-linux )
				# https://unix.stackexchange.com/questions/269078/executing-a-bash-script-function-with-sudo
				# https://serverfault.com/questions/177699/how-can-i-execute-a-bash-function-with-sudo

				# https://superuser.com/questions/305933/preventing-bash-from-displaying-done-when-a-background-command-finishes-execut
				# https://unix.stackexchange.com/questions/306673/after-a-job-in-the-background-is-done
				# https://www.digitalocean.com/community/tutorials/how-to-use-bash-s-job-control-to-manage-foreground-and-background-processes
				# https://stackoverflow.com/questions/44222883/run-a-shell-script-and-immediately-background-it-however-keep-the-ability-to-in

				# echo_command \
				sudo \
				bash -i -c "set +m; time_command copy_tarball_to_all_drives"' "$@" ;' - "${base}" "${tarball}"
				# bash -c "set +m; $(declare -f print_hard_drives_mount_points); $(declare -f time_command); $(declare -f copy_tarball_to_all_drives); time_command copy_tarball_to_all_drives"' "$@" ;' - "${base}" "${tarball}"
				;;
			* )
				echo "don't know how to copy files to all drives"
				false
				;;
		esac \
	&& rm -rf "${tarball}"{,.gpg}{,.sha512}
}

do_git_backup() {
	git_check_.git_directory_or_exit

	local gc_command="$1"
	local backup_command="$2"

	case "${gc_command}" in
		do_gc )
			time_command git_gc
			;;
		no_gc )
			time_command git_reflog_expire
			;;
		* )
			echo "unknown gc_command : ${gc_command}"
			false
			;;
	esac \
	&& case "${backup_command}" in
		backup_to_all_drives | backup_to_upper_directory )
			local base="$(basename "$(pwd)")"
			local tarball="${base}-$(current_datetime)".tar
			time_command git_fsck \
			&& { pushd .. \
				&& case "${backup_command}" in
					backup_to_upper_directory )
						git_backup_directory "${base}" "${tarball}"
						;;
					backup_to_all_drives )
						git_backup_directory_to_all_drives "${base}" "${tarball}"
						;;
				esac \
				&& popd;} \
			&& time_command sync
			;;
		* )
			echo "unknown backup_command : ${backup_command}"
			false
			;;
	esac
}

do_git_commit() {
	git_check_.git_directory_or_exit

	local commit_command="$1"
	local commit_message_file="$(git_commit_message_file_name)"
	case "${commit_command}" in
		"" | -S  | merge_--squash | -S_merge_--squash )
			true
			;;
		* )
			echo "unknown commit_command : ${commit_command}"
			return 1
			;;
	esac

	local args=(  )
	case "${commit_command}" in
		-S | -S_merge_--squash )
			args+=( -S )
			;;
	esac

	args+=( -a )

	case "${commit_command}" in
		merge_--squash | -S_merge_--squash )
			if [ ! -f .git/branch ]; then
				echo ".git/branch file does not exist!"
				return 1
			fi
			local branch="$(cat .git/branch)"
			local current_branch="$(git branch --show-current)"
			if [ "${current_branch}" == "${branch}" ]; then
				echo "current branch is alreay ${branch}!"
				return 1
			fi
			echo "branch : ${branch},  current_branch : ${current_branch}"
			echo "git checkout ${branch}"
			echo "git merge --squash ${current_branch}"
			if ! ask_for_confirmation yes; then
				return 1
			fi
			time_command git checkout "${branch}" \
			&& time_command git merge --squash "${current_branch}"
			;;
	esac \
	&& if [ -f "${commit_message_file}" ]; then
		args+=( -F "${commit_message_file}" )
	fi \
	&& time_command git commit "${args[@]}" \
	&& if [ -f "${commit_message_file}" ]; then
		echo_command rm -rf "${commit_message_file}"
	fi \
	&& time_command sync
}

git_show_commit_message() {
	local commit_message_file="$(git_commit_message_file_name)"
	if [ -f "${commit_message_file}" ]; then
		echo "${commit_message_file} :"
		cat "${commit_message_file}"
	else
		echo "no ${commit_message_file}"
	fi
}

git_show_branch_info_for_diff(){
	local branch="$1"
	echo "current branch  : $(git branch --show-current)"
	if [ -f .git/branch ]; then
		echo "cat .git/branch : $(cat .git/branch)"
	fi
	if [ ! -z "${branch}" ]; then
		echo "branch          : ${branch}"
	fi
}

git_diff_HEAD() {
	git_show_commit_message

	printf "\n\n"
	git_show_branch_info_for_diff

	printf "\n\n"
	echo "git diff HEAD"

	# printf "\n\n"
	# git_print_remote_branch_tag

	printf "\n\n"
	time_command git status

	printf "\n\n"
	time_command git_diff HEAD
}

git_diff_HEAD_remote_branch_tag() {
	git_show_commit_message

	printf "\n\n"
	git_show_branch_info_for_diff

	printf "\n\n"
	git_print_remote_branch_tag

	# printf "\n\n"
	# time_command git status

	# printf "\n\n"
	# time_command git_diff HEAD
}

git_diff_branch...HEAD() {
	local branch="$1"

	if [ -z "${branch}" ]; then
		if [ -f .git/branch ]; then
			branch="$(cat .git/branch)"
		else
			echo "the file .git/branch does not exist."
			return 1
		fi
	fi

	if [ -z "${branch}" ]; then
		echo "branch is not specified."
		return 1
	elif ! git_rev_parse "${branch}" 2>&1 >/dev/null; then
		echo "branch ${branch} does not exist."
		return 1
	fi

	git_show_commit_message

	printf "\n\n"
	git_show_branch_info_for_diff "${branch}"

	printf "\n\n"
	local current_branch="$(git branch --show-current)"
	echo "git diff ${branch}...HEAD"
	echo "git diff ${branch}...${current_branch}"
	echo "git diff \$(git merge-base ${branch} ${current_branch}) ${current_branch}"

	# printf "\n\n"
	# git_print_remote_branch_tag

	# https://stackoverflow.com/questions/34279322/how-to-git-diff-all-changes-since-branching-from-master
	# https://git-scm.com/docs/git-diff
	# https://git.github.io/git-reference/inspect/

	# git diff [<options>] <commit>...<commit> [--] [<path>…​]
	# This form is to view the changes on the branch containing and up to the second <commit>, starting at a common ancestor of both <commit>. git diff A...B is equivalent to git diff $(git merge-base A B) B. You can omit any one of <commit>, which has the same effect as using HEAD instead.

	printf "\n\n"
	time_command git_diff ${branch}...HEAD
}

do_git_diff() {
	git_check_.git_directory_or_exit

	local diff_command="$1"
	shift 1

	case "${diff_command}" in
		git_diff_HEAD | git_diff_branch...HEAD | git_diff_HEAD_remote_branch_tag )
			show_command_output_in_editor "~${diff_command}.diff" "${diff_command}" "$@"
			;;
		* )
			echo "unknown diff_command : ${diff_command}"
			false
			;;
	esac
}

do_git_edit_commit_message() {
	git_check_.git_directory_or_exit

	local commit_message_file="$(git_commit_message_file_name)"
	touch "${commit_message_file}"
	${EDITOR} "${commit_message_file}"
	# https://stackoverflow.com/questions/9964823/how-to-check-if-a-file-is-empty-in-bash
	if ! [ -s "${commit_message_file}" ]; then
		# empty file
		rm -rf "${commit_message_file}"
	fi
}

do_git_misc() {
	git_check_.git_directory_or_exit

	local misc_command="$1"
	shift 1

	case "${misc_command}" in
		git_add_-A )
			time_command git add -A --verbose \
			&& time_command sync
			;;
		git_fetch )
			time_command git fetch \
			&& time_command sync
			;;
		git_fsck )
			time_command git_fsck
			;;
		git_gc )
			time_command git_gc
			;;
		git_pull_--rebase )
			local remote="$1"
			time_command git pull --rebase "${remote}" "$(git branch --show-current)" \
			&& time_command sync
			;;
		git_push )
			local remote="$1"
			time_command git push "${remote}" "$(git branch --show-current)"
			;;
		git_reset_--hard_HEAD )
			echo "git reset --hard HEAD"
			if ! ask_for_confirmation yes; then
				return 1
			fi
			time_command git reset --hard HEAD \
			&& time_command sync
			;;
		* )
			echo "unknown misc_command : ${misc_command}"
			false
			;;
	esac
}
