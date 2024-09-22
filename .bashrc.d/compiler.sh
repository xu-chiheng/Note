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


maybe_create_test_branch_for_bisect() {
	local major_branch="$1"
	local test_branch="$2"
	local trunk_branch="$3"

	if ! git_branch_exists "${test_branch}"; then
		echo_command git checkout -f -b "${test_branch}" "$(git merge-base "${trunk_branch}" "${major_branch}")"
	fi
}

# git remote rename origin upstream
common_create_test_branches_for_bisect() {
	local dir="$1"
	local major_version_start="$2"
	local major_branch_pattern_begin="$3"
	local major_branch_pattern_end="$4"
	local trunk_branch="$5"

	if [ ! -d .git ]; then
		return 1
	fi
	if [ ! "$(basename "$(pwd)")" = "${dir}" ]; then
		return 1
	fi

	local major_version
	for major_version in $(seq "${major_version_start}" 99); do
		# echo "${major_version}"
		local major_branch="${major_branch_pattern_begin}${major_version}${major_branch_pattern_end}"
		local test_branch="$(printf "test%02d0000\n" "${major_version}")"
		if git_branch_exists "${major_branch}"; then
			maybe_create_test_branch_for_bisect "${major_branch}" "${test_branch}" "${trunk_branch}"
		else
			maybe_create_test_branch_for_bisect "${trunk_branch}" "${test_branch}" "${trunk_branch}"
			break
		fi
	done
	echo_command git checkout -f "${trunk_branch}"
	echo_command git branch
}

llvm_create_test_branches_for_bisect() {
	common_create_test_branches_for_bisect llvm 16 "remotes/origin/release/" ".x" main
}

gcc_create_test_branches_for_bisect() {
	common_create_test_branches_for_bisect gcc 13 "remotes/origin/releases/gcc-" "" master
}

binutils_create_test_branches_for_bisect() {
	common_create_test_branches_for_bisect binutils 36 "remotes/origin/binutils-2_" "-branch" master
}

gdb_create_test_branches_for_bisect() {
	common_create_test_branches_for_bisect gdb 14 "remotes/origin/gdb-" "-branch" master
}

check_compiler_existence() {
	if [ -z "$1" ]; then
		echo "no compiler specified"
		return 1
	fi
	if ! quiet_command which "$1"; then
		echo "compiler $1 can not be found"
		return 1
	fi
}

print_compiler_version() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi

	case "$1" in
		*clang | *clang++ | *clang-cl )
			"$1" -v  2>&1 | grep -E '^clang version ' | sed -E -e 's/^clang version //'
			;;
		*gcc | *g++ )
			"$1" -v  2>&1 | grep -E '^gcc version ' | sed -E -e 's/^gcc version //' | sed -E -e 's/ \((GCC|experimental)\)//g'
			;;
		*cl )
			"$1"  2>&1 | grep -E ' Compiler Version ' | sed -E -e 's/.+ Compiler Version //'
			;;
		* )
			echo "unknown compiler : $1"
			return 1
			;;
	esac
}

print_compiler_predefined_macros() {
	if ! check_compiler_existence "$1"; then
		return 1
	fi

	case "$1" in
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
			echo "unknown compiler : $1"
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

	case "$1" in
		*g++ | *c++ )
			echo | "$@" -E -Wp,-v -xc++ - 2>&1
			;;
		*gcc | *clang )
			echo | "$@" -E -Wp,-v -xc - 2>&1
			;;
		* )
			echo "unknown compiler : $1"
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
	print_array_elements $(gcc -v 2>&1 | grep -E '^Configured with: ' | sed -E -e 's/^.+\/configure //' )
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

	local print_hello_world_program_command
	local source_file_name

	case "$1" in
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
	echo_command "$@" -v -Wl,-v "${source_file_name}"
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
	# print_array_elements "${options[@]}"
	local option
	for option in "${options[@]}"; do
		echo_command llvm-config "${option}"
		printf "\n\n"
	done
}

# remove the test suite directories of GCC, LLVM, and maybe others
remove_test_suite_dirs() {
	case "$(basename "$(pwd)")" in
		gcc | llvm | glibc )
			find . -type d -regextype posix-extended -regex ".*/(test|unittests|testsuite)" \
			-print0 | xargs -0 -n100 \
			rm -rf
			;;
	esac
}

# https://gcc.gnu.org/wiki/Testing_GCC
# https://gcc.gnu.org/install/test.html
# https://dmalcolm.fedorapeople.org/gcc/newbies-guide/working-with-the-testsuite.html
# https://stackoverflow.com/questions/44943652/how-to-run-unit-tests-on-an-installed-gcc-installation
# http://lambda.phys.tohoku.ac.jp/~tsukada/INSTALL/test.html
# GCC Binutils GDB
gnu_toolchain_run_test_suite() {
	local make_command=( parallel_make )
	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			# too many jobs will cause following errors :
			# -574947849 [main] expect 10703 tty_list::allocate: No pty allocated
			# FAIL: gcc.dg/torture/matrix-4.c   -O2 -flto  (test for excess errors)
			# -559944125 [main] expect 12177 tty_list::allocate: No pty allocated
			# FAIL: g++.old-deja/g++.mike/p6611.C  -std=c++20 (test for excess errors)
			make_command+=( -j 80 )
			;;
	esac

	time_command "${make_command[@]}" -k check 2>&1 | tee "../~$(print_current_datetime)-$(basename "$(pwd)")-test-output.txt"
}

# https://llvm.org/docs/TestingGuide.html
# https://llvm.org/docs/TestSuiteGuide.html
llvm_run_test_suite() {
	time_command make -k check-llvm 2>&1 | tee "../~$(print_current_datetime)-$(basename "$(pwd)")-test-output.txt"
}
