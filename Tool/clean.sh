#!/usr/bin/env -S bash -i

clean() {
	local find_args=(
		-mindepth 1
		-maxdepth 1
		'('
			-name '*output.txt'

			-or -name 'llvm-*'

			-or -name '*.cpp'
			-or -name '*.c'
			-or -name '*.out'
			-or -name '*.exe'
			-or -name '*.dll'
			-or -name '*.o'
			-or -name '*.obj'

			-or -name '*-build'
			-or -name '*-install'
		')'
		-and
		-not
		'('
			-name '*.sha512'
			-or -name '*.cmd'
			-or -name '*.sh'
		')'
	)

	# Windows also has a find command
	# /cygdrive/c/Windows/system32/find
	/usr/bin/find "${find_args[@]}" -print0 | xargs -0 -n100 rm -rf

	local package
	for package in git openssh gnupg; do
		if [ -d "${package}" ]; then
			if [ -d "${package}"/.git ] ; then
				(cd "${package}" && git reset --hard HEAD && git clean -xfd -e '~git-tools~') 2>&1 >/dev/null
			else
				(cd "${package}" && make distclean) 2>&1 >/dev/null
			fi
		fi
	done
}

clean "$@"
