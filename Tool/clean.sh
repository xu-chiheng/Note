#!/usr/bin/env -S bash -i

cd "$(dirname "$0")"
. "./common.sh"

FIND_ARGS=(
	-mindepth 1
	-maxdepth 1
	'('
		-name '*output.txt'

		-or -name 'a.exe'
		-or -name 'a.out'
		-or -name 'main.cpp'
		-or -name 'main.c'

		-or -name '*-build'
		-or -name '*-install'
	')'
	-and
	-not
	'('
		# remove manually
		-name '*.sha512'
		-or -name '*.cmd'
		-or -name '*.sh'
	')'
)

# Windows also has a find command
# /cygdrive/c/Windows/system32/find
/usr/bin/find "${FIND_ARGS[@]}" -print0 | xargs -0 -n100 rm -rf
