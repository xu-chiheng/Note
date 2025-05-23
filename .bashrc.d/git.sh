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

# https://linuxize.com/post/bash-functions/
git_update_git-tools_1() {
	local d="$1"
	# echo "${d}"
	if [ -z "${d}" ]; then
		echo "no directory specified"
		return 1
	elif ! [ "$(basename "${d}")" = .git ]; then
		echo "${d} is not a .git directory"
		return 1
	elif ! [ -d "${d}" ]; then
		echo "directory ${d} does not exist"
		return 1
	fi
	local dir="$(dirname "$d")"
	echo "${dir}"
	if [ ! -d "${dir}"/'~git-tools~' ] \
		|| { [ ! "$(readlink -f "${dir}")" = "$(readlink -f ~)" ] \
		&& ! quiet_command diff -Naur "${dir}"/'~git-tools~' ~/'~git-tools~' ;}; then
		echo_command rm -rf "${dir}"/'~git-tools~' \
		&& echo_command cp -rf ~/'~git-tools~' "${dir}"/
	fi
}

git_update_git-tools() {
	find . -type d -name '.git' \
	-print0 | xargs -0 -n1 -P0 \
	bash -c "$(declare -f quiet_command); $(declare -f echo_command); $(declare -f git_update_git-tools_1); git_update_git-tools_1"' "$@" ;' -
}

git_diff() {
	if [ ! -d .git ]; then
		return 1
	fi

	git diff --stat=200 --summary --patch "$@"
}

# https://stackoverflow.com/questions/5167957/is-there-a-better-way-to-find-out-if-a-local-git-branch-exists
git_rev_parse() {
	if [ ! -d .git ]; then
		return 1
	fi

	local revision="$1"
	git rev-parse --verify --quiet "${revision}"
}

git_branch_delete_all_test_branches() {
	if [ ! -d .git ]; then
		return 1
	fi

	local remote="$1"
	if [ -z "${remote}" ]; then
		# local branches
		git branch | grep -E '^  test' | xargs git branch -D
	else
		# remote branches
		git branch -r | grep -E "${remote}/test" | xargs -I {} git push origin --delete {}
	fi
}

# test branches are named like "test%04d"
git_branch_delete_test_range() {
	if [ ! -d .git ]; then
		return 1
	fi

	local first="$1"
	local last="$2"
	local remote="$3"
	if [ -z "${first}" ] || [ -z "${last}" ]; then
		echo "must provide first and last number"
		return 1
	fi

	local i
	# https://stackoverflow.com/questions/169511/how-do-i-iterate-over-a-range-of-numbers-defined-by-variables-in-bash
	local branches=( $(for i in $(seq "${first}" "${last}"); do printf "test%04d\n" $i; done) )
	if [ -z "${remote}" ]; then
		# local branches
		echo_command git branch -D "${branches[@]}"
	else
		# remote branches
		if git_remote_exists "${remote}"; then
			local branch
			for branch in "${branches[@]}"; do
				echo_command git push "${remote}" :"${branch}"
			done
		else
			echo "remote ${remote} does not exist"
			return 1
		fi
	fi
}

git_branch_delete_test_range_origin() {
	local first="$1"
	local last="$2"
	git_branch_delete_test_range "${first}" "${last}" "origin"
}

git_branch_delete_test_range_upstream() {
	local first="$1"
	local last="$2"
	git_branch_delete_test_range "${first}" "${last}" "upstream"
}

git_branch_delete_test_range_downstream() {
	local first="$1"
	local last="$2"
	git_branch_delete_test_range "${first}" "${last}" "downstream"
}

git_remove_all_files() {
	if [ ! -d .git ]; then
		return 1
	fi

	# find . -mindepth 1 -maxdepth 1 -regextype posix-extended ! -regex '\./(\.git|~git-tools~)'
	find . -mindepth 1 -maxdepth 1 ! -name '.git' -a ! -name '~git-tools~' \
	-print0 | xargs -0 -n100 \
	rm -rf
}

git_filemode_false() {
	if [ ! -d .git ]; then
		return 1
	fi

	echo_command sed -Ei -e 's/filemode = true/filemode = false/' .git/config
}

git_filemode_true() {
	if [ ! -d .git ]; then
		return 1
	fi

	echo_command sed -Ei -e 's/filemode = false/filemode = true/' .git/config
}

git_fsck() {
	if [ ! -d .git ]; then
		return 1
	fi

	time_command git fsck --full --strict --progress
}

git_reflog_expire() {
	if [ ! -d .git ]; then
		return 1
	fi

	time_command git reflog expire --expire=now --all
}

git_gc() {
	if [ ! -d .git ]; then
		return 1
	fi

	time_command git_reflog_expire \
	&& time_command git gc --aggressive --prune=all \
	&& time_command sync .git
}

git_print_remote_branch_tag() {
	if [ ! -d .git ]; then
		return 1
	fi

	echo "remotes :"
	git remote -v
	echo
	echo "branches :"
	echo_multi_line $(git branch -a | sed -E -e 's/^[ \*] //')
	echo
	echo "tags :"
	echo_multi_line $(git tag -l)
}

# How do I remove the old history from a git repository?
# https://stackoverflow.com/questions/4515580/how-do-i-remove-the-old-history-from-a-git-repository
# https://web.archive.org/web/20130116195128/http://bogdan.org.ua/2011/03/28/how-to-truncate-git-history-sample-script-included.html
git_truncate() {
	if [ ! -d .git ]; then
		return 1
	fi

	local first_rev="$1"
	if [ -z "${first_rev}" ]; then
		echo "no first revision"
		return 1
	fi
	local first_commit="$(git_rev_parse "${first_rev}")"
	if [ -z "${first_commit}" ]; then
		echo "unknown first revision : ${first_rev}"
		return 1
	fi

	local last_rev="$(git branch --show-current)"
	local last_commit="$(git_rev_parse "${last_rev}")"

	git_print_remote_branch_tag
	echo "first revision : ${first_rev}"
	git show -s "${first_rev}"
	printf "\n\n"
	echo "last  revision : ${last_rev}"
	git show -s "${last_rev}"
	printf "\n\n"

	if ! ask_for_confirmation yes; then
		return 1
	fi

	echo_command git_fsck \
	&& echo_command git reset --hard HEAD \
	&& echo_command git checkout --orphan temp "${first_commit}" \
	&& echo_command git commit -m "Truncated history" \
	&& echo_command git rebase --onto temp "${first_commit}" "${last_commit}" \
	&& echo_command git branch -D $(git branch --list | grep -E '^  ' | grep -Ev '^  temp$') \
	&& echo_command git checkout -b main \
	&& echo_command git branch -D temp \
	&& echo_command git_gc \
	&& echo "completed"

	# --orphan <new-branch>
	# 	Create a new orphan branch, named <new-branch>, started from <start-point> and switch to it. The first commit made on this new branch will have no parents and it will be the root of a new history totally disconnected from
	# 	all the other branches and commits.

	# git checkout --orphan temp $1 # create a new branch without parent history
	# git commit -m "Truncated history" # create a first commit on this branch
	# git rebase --onto temp $1 master # now rebase the part of master branch that we want to keep onto this branch
	# git branch -D temp # delete the temp branch

	# # The following 2 commands are optional - they keep your git repo in good shape.
	# git prune --progress # delete all the objects w/o references
	# git gc --aggressive # aggressively collect garbage; may take a lot of time on large repos
}

print_git_commit_message_file_name() {
	echo "~commit-message.txt"
}

mount_point_size_available_in_G() {
	local mount_point="$1"
	df -BG "${mount_point}" | tail -n +2 | awk '{print $4}' | sed -E -e "s/G$//g"
}

mount_point_size_available_is_bigger_than_10G() {
	local mount_point="$1"
	local a="$(mount_point_size_available_in_G "${mount_point}")"
	local b="10"
	# [ "$a" -gt "$b" ]
	(( a > b ))
}

print_hard_drives_mount_points_0() {
	local d
	case "${HOST_TRIPLE}" in
		*-cygwin )
			cat /proc/mounts | grep -E '^[A-Z]: /cygdrive/[a-z] ' | cut -d ' ' -f 2
			;;
		*-msys | *-mingw* )
			cat /proc/mounts | grep -E '^[A-Z]: /[a-z] ' | cut -d ' ' -f 2
			;;
		*-linux* )
			# Linux hard drive device file naming convention
			# regular expression special characters
			cat /proc/mounts | grep -E '^/dev/[hsv]d[a-z](|[1-9][0-9]*) (/|(/\w+)+) ' | cut -d ' ' -f 2
			;;
	esac
}

print_hard_drives_mount_points() {
	local d
	for d in $(print_hard_drives_mount_points_0); do
		# echo "$d $(mount_point_size_available_in_G "$d")"
		if [ -w "$d" ] && mount_point_size_available_is_bigger_than_10G "$d"; then
			# writable and available size > 10G
			echo "$d"
		fi
	done
}

hide_or_unhide_backup_dirs() {
	if ! host_triple_is_windows "${HOST_TRIPLE}"; then
		echo "unsupported host ${HOST_TRIPLE}"
		return 1
	fi

	local d
	local dir
	for d in $(print_hard_drives_mount_points); do
		dir="$d/Backup"
		if [ -f "${dir}/.trusted" ]; then
			echo_command attrib +H "$(cygpath -w "${dir}")"
		else
			echo_command attrib -H "$(cygpath -w "${dir}")"
		fi
	done
}

# sometimes, we want to remove the files copied to the backup directories.
# pass the base_names of the backup files
remove_backuped_tarballs_by_base_names() {
	local d
	local dir
	local base
	for d in $(print_hard_drives_mount_points); do
		dir="$d/Backup"
		for base in "$@"; do
			echo_command rm -rf "${dir}/${base}"-*.tar{,.gpg}{,.sha512}
		done
	done
}

# https://stackoverflow.com/questions/965053/extract-filename-and-extension-in-bash
# https://www.w3schools.io/terminal/bash-extract-file-extension/
copy_tarball_to_all_drives() {
	local base="$1"
	local tarball="$2"
	local d
	local dir

	local pids=()
	local pid
	local all_success=yes

	for d in \
		$(
			{
				print_hard_drives_mount_points

				# data directory
				if host_triple_is_windows "${HOST_TRIPLE}"; then
					if [ -v DATA_DIR ] && [ ! -z "${DATA_DIR}" ]; then
						echo "$(cygpath -u "${DATA_DIR}")"
					fi
				fi
			} | sort | uniq
		); do
		### run in foreground
		# echo "${d}"
		dir="${d}/Backup"

		### run in background
		mkdir -p "${dir}" \
		&& rm -rf "${dir}/${base}"-*.tar{,.gpg}{,.sha512} \
		&& if [ -f "${dir}/.trusted" ]; then
			echo "${tarball}"'{,.sha512}'"               ======> ${dir}"
			cp "${tarball}"{,.sha512} "${dir}"
		else
			echo "${tarball}"'{.gpg{,.sha512},.sha512}'" ======> ${dir}"
			cp "${tarball}"{.gpg{,.sha512},.sha512} "${dir}"
		fi \
		&& sync "${dir}" \
		& # run in background
		pids+=( $! )
	done \
	&& for pid in "${pids[@]}"; do
		wait "${pid}" || all_success=no
	done \
	&& [ "${all_success}" = yes ]
}

git_branch_exists() {
	if [ ! -d .git ]; then
		return 1
	fi

	local branch="$1"
	quiet_command git_rev_parse "${branch}"
}

git_remote_exists() {
	if [ ! -d .git ]; then
		return 1
	fi

	local remote="$1"
	git remote | quiet_command grep -E "^${remote}$"
}
