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
		-or -name 'binutils-gdb-*'
		-or -name 'gmp*'
		-or -name 'mpfr*'
		-or -name 'mpc*'
		-or -name '*-gcc-*'
		-or -name 'gdb*'
		-or -name '*output.txt'
	')'
	-and ! -name '*.sha512'
)

# Windows also has a find command
# /cygdrive/c/Windows/system32/find
/usr/bin/find "${FIND_ARGS[@]}" -print0 | xargs -0 -n100 rm -rf
