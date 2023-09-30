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


maybe_create_test_branch() {
	local major_branch="$1"
	local test_branch="$2"
	local trunk_branch="$3"

	if ! git_rev_parse "${test_branch}" >/dev/null 2>&1; then
		echo_command git checkout -b "${test_branch}" "$(git merge-base "${trunk_branch}" "${major_branch}")"
	fi
}

llvm_create_test_branches_for_bisect() {
	local major_version
	for major_version in $(seq 16 99); do
		# echo "${major_version}"
		local major_branch="remotes/origin/release/${major_version}.x"
		local test_branch="$(printf "test%02d0000\n" "${major_version}")"
		if git_rev_parse "${major_branch}" >/dev/null 2>&1; then
			maybe_create_test_branch "${major_branch}" "${test_branch}" main
		else
			maybe_create_test_branch main "${test_branch}" main
			break
		fi
	done
	echo_command git checkout main
	echo_command git branch
}

gcc_create_test_branches_for_bisect() {
	local major_version
	for major_version in $(seq 13 99); do
		# echo "${major_version}"
		local major_branch="remotes/origin/releases/gcc-${major_version}"
		local test_branch="$(printf "test%02d0000\n" "${major_version}")"
		if git_rev_parse "${major_branch}" >/dev/null 2>&1; then
			maybe_create_test_branch "${major_branch}" "${test_branch}" master
		else
			maybe_create_test_branch master "${test_branch}" master
			break
		fi
	done
	echo_command git checkout master
	echo_command git branch
}

check_compiler_existence() {
	local compiler="$1"
	if [ -z "${compiler}" ]; then
		echo "no compiler specified"
		return 1
	fi
	if ! which "${compiler}" >/dev/null 2>&1; then
		echo "compiler ${compiler} can not be found"
		return 1
	fi
}

print_compiler_version() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi
	local compiler="$1"

	case "${compiler}" in
		*clang | *clang++ | *clang-cl )
			"${compiler}" -v  2>&1 | grep -E '^clang version ' | sed -E -e 's/^clang version //'
			;;
		*gcc | *g++ )
			"${compiler}" -v  2>&1 | grep -E '^gcc version ' | sed -E -e 's/^gcc version //' | sed -E -e 's/ \((GCC|experimental)\)//g'
			;;
		*cl )
			"${compiler}"  2>&1 | grep -E ' Compiler Version ' | sed -E -e 's/.+ Compiler Version //'
			;;
		* )
			echo "unknown compiler : ${compiler}"
			return 1
			;;
	esac
}

print_compiler_predefined_macros() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi
	local compiler="$1"

	case "${compiler}" in
		*g++ | *c++ )
			"$@" -E -dM -x c++ - </dev/null | sort
			;;
		*gcc | *clang )
			"$@" -E -dM -x c - </dev/null | sort
			;;
		*cl )
			# https://stackoverflow.com/questions/3665537/how-to-find-out-cl-exes-built-in-macros
			# https://developercommunity.visualstudio.com/t/provide-the-ability-to-list-predefined-macros-and/934925
			rm -rf empty.* \
			&& touch empty.cpp \
			&& "$@" /EP /Zc:preprocessor /PD empty.cpp 2>/dev/null | sort \
			&& rm -rf empty.*
			;;
		* )
			echo "unknown compiler : ${compiler}"
			return 1
			;;
	esac
}

# https://stackoverflow.com/questions/17939930/finding-out-what-the-gcc-include-path-is
# https://stackoverflow.com/questions/4980819/what-are-the-gcc-default-include-directories
print_compiler_include_dirs() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi
	local compiler="$1"

	case "${compiler}" in
		*g++ | *c++ )
			echo | "$@" -E -Wp,-v -xc++ - 2>&1
			;;
		*gcc | *clang )
			echo | "$@" -E -Wp,-v -xc - 2>&1
			;;
		* )
			echo "unknown compiler : ${compiler}"
			return 1
			;;
	esac
}

# print_command_options clang
# print_command_options clang -cc1
# print_command_options $(gcc -print-prog-name=cc1)
# print_command_options $(gcc -print-prog-name=cc1plus)
print_command_options() {
	"$@" --help 2>&1 | grep -E '^\s*-{1,2}\w+\s.*'  | sed -E -e 's/^\s+//' | cut -d ' ' -f 1 | sort
}

print_gcc_configure_options() {
	array_elements_print $(gcc -v 2>&1 | grep -E '^Configured with: ' | sed -E -e 's/^.+\/configure //' )
}

print_hello_world_program_in_c() {
	cat <<EOF
#include <stdio.h>
int main(int argc, char ** argv)
{
	printf("Hello, World!\n");
	return 0;
}
EOF
}

print_hello_world_program_in_cxx() {
	cat <<EOF
#include <iostream>
int main(int argc, char ** argv)
{
	std::cout << "Hello, World!" << std::endl;
	return 0;
}
EOF
}

# Display the programs invoked by the compiler.
# Show commands to run and use verbose output
show_compiler_commands() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi
	local compiler="$1"
	shift 1
	local args=( "$@" )

	args+=(
		-v
		# -Wl,-v
		# -Wl,--verbose
	)

	local print_hello_world_program_command
	local source_file_name

	case "${compiler}" in
		*g++ | *c++ | *cl )
			print_hello_world_program_command=print_hello_world_program_in_cxx
			source_file_name=main.cpp
			;;
		* )
			print_hello_world_program_command=print_hello_world_program_in_c
			source_file_name=main.c
			;;
	esac

	"${print_hello_world_program_command}" | tee "${source_file_name}"
	echo_command "$(which "${compiler}")" "${args[@]}" "${source_file_name}"
}

show_compiler_commands_bfd() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi

	show_compiler_commands "$@" -fuse-ld=bfd
}

show_compiler_commands_lld() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi

	show_compiler_commands "$@" -fuse-ld=lld
}

llvm-config_print() {
	local options=( $(print_command_options llvm-config) )
	# array_elements_print "${options[@]}"
	local option
	for option in "${options[@]}"; do
		echo_command llvm-config "${option}"
		printf "\n\n"
	done
}
