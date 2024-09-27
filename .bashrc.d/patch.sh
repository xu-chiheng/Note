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

patch_apply_1() {
	local check="$1"
	local reverse="$2"
	local dir="$3"
	shift 3
	local patches=( "$@" )

	local patch_options=()
	if [ "${reverse}" = yes ]; then
		patch_options+=( -Rp1 )
	else
		patch_options+=( -Np1 )
	fi

	local patch

	if [ "${check}" = yes ]; then
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

		for patch in "${patches[@]}"; do
			echo "checking ${patch}"
			if ! cat "${patch}" | ( cd "${dir}" && patch "${patch_options[@]}" --dry-run --quiet ) ; then
				echo "${patch} can not be applied"
				return 1
			fi
		done
	fi

	local failed_patches=()
	for patch in "${patches[@]}"; do
		echo "applying ${patch}"
		if ! cat "${patch}" | ( cd "${dir}" && patch "${patch_options[@]}" ) ; then
			echo "${patch} can not be applied"
			failed_patches+=( "${patch}" )
		fi
	done
	if ! [ ${#failed_patches[@]} -eq 0 ]; then
		echo "failed patches :"
		print_array_elements "${failed_patches[@]}"
	else
		echo "all succeed"
	fi
}

patch_apply_no_check() {
	patch_apply_1 no no "$@"
}

patch_apply() {
	patch_apply_1 yes no "$@"
}

patch_apply_reverse_no_check() {
	patch_apply_1 no yes "$@"
}

patch_apply_reverse() {
	patch_apply_1 yes yes "$@"
}
