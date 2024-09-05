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

patch_generate() {
	local dir_a="$1"
	local dir_b="$2"
	local patch="$3"
	if [ -z "${dir_a}" ]; then
		echo "directory a is not provided"
		return 1
	elif [ ! -e "${dir_a}" ]; then
		echo "${dir_a} does not exist"
		return 1
	elif [ ! -d "${dir_a}" ]; then
		echo "${dir_a} is not a directory"
		return 1
	fi

	if [ -z "${dir_b}" ]; then
		echo "directory b is not provided"
		return 1
	elif [ ! -e "${dir_b}" ]; then
		echo "${dir_b} does not exist"
		return 1
	elif [ ! -d "${dir_b}" ]; then
		echo "${dir_b} is not a directory"
		return 1
	fi

	if [ -z "${patch}" ]; then
		echo "patch file is not provided"
		return 1
	elif [ -e "${patch}" ]; then
		if [ ! -f "${patch}" ]; then
			echo "${patch} exists, but is not a file"
			return 1
		fi
	fi

	if [ -e a ] || [ -e b ]; then
		echo "directory entry a or b exist in current directory"
		return 1
	fi

	ln -s "${dir_a}" a \
	&& ln -s "${dir_b}" b \
	&& diff -Naur a b >"${patch}" \
	&& rm -rf a b
}

patch_apply_verify() {
	local dir="$1"
	shift 1
	local patches=( "$@" )

	if [ -z "${dir}" ]; then
		echo "directory is not provided"
		return 1
	elif [ ! -e "${dir}" ]; then
		echo "${dir} does not exist"
		return 1
	elif [ ! -d "${dir}" ]; then
		echo "${dir} is not a directory"
		return 1
	fi

	local patch
	for patch in "${patches[@]}"; do
		if [ ! -e "${patch}" ]; then
			echo "${patch} does not exist"
			return 1
		elif [ ! -f "${patch}" ]; then
			echo "${patch} is not a file"
			return 1
		elif ! file "${patch}" | grep "unified diff output"; then
			echo "${patch} is not a patch file"
			return 1
		fi
	done
}

patch_apply_no_check() {
	local dir="$1"
	shift 1
	local patches=( "$@" )

	for patch in "${patches[@]}"; do
		echo "apply ${patch}"
		if ! cat "${patch}" | ( cd "${dir}" && patch -Np1 ) ; then
			echo "${patch} can not be applied"
		fi
	done
}

patch_apply() {
	if ! patch_apply_verify "$@"; then
		return 1
	fi
	local dir="$1"
	shift 1
	local patches=( "$@" )

	for patch in "${patches[@]}"; do
		echo "check ${patch}"
		if ! cat "${patch}" | ( cd "${dir}" && patch -Np1 --dry-run --quiet ) ; then
			echo "${patch} can not be applied"
			return 1
		fi
	done

	patch_apply_no_check "${dir}" "${patches[@]}"
}

patch_apply_reverse_no_check() {
	local dir="$1"
	shift 1
	local patches=( "$@" )

	for patch in "${patches[@]}"; do
		echo "apply ${patch}"
		if ! cat "${patch}" | ( cd "${dir}" && patch -Rp1 ) ; then
			echo "${patch} can not be applied"
		fi
	done
}

patch_apply_reverse() {
	if ! patch_apply_verify "$@"; then
		return 1
	fi
	local dir="$1"
	shift 1
	local patches=( "$@" )

	for patch in "${patches[@]}"; do
		echo "check ${patch}"
		if ! cat "${patch}" | ( cd "${dir}" && patch -Rp1 --dry-run --quiet ) ; then
			echo "${patch} can not be applied"
			return 1
		fi
	done

	patch_apply_reverse_no_check "${dir}" "${patches[@]}"
}
