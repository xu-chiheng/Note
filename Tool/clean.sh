#!/usr/bin/env -S bash -i

cd "$(dirname "$0")"
. "./common.sh"

FIND_ARGS=(
	-mindepth 1
	-maxdepth 1
	'('
		-name 'gcc-*'
		-or -name 'llvm-*'
		-or -name 'qemu-*'
		-or -name 'cmake-*'
		-or -name 'binutils-*'
		-or -name 'bash-*'
		-or -name 'make-*'
		-or -name 'perl-*'
		-or -name 'python-*'
		-or -name 'cygwin-*'
		-or -name 'mingw-*'
		-or -name 'gdb-*'
		-or -name 'gmp*'
		-or -name 'mpfr*'
		-or -name 'mpc*'
		-or -name '*output.txt'
	')'
	-and
	-not
	'('
		# remove manually
		-name '*-vs2022-build'
		-or -name '*.sha512'
		-or -name '*.cmd'
		-or -name '*.sh'
		-or -name '*.cygport'
	')'
)

# Windows also has a find command
# /cygdrive/c/Windows/system32/find
/usr/bin/find "${FIND_ARGS[@]}" -print0 | xargs -0 -n100 rm -rf
