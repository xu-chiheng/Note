
cd ..

do_update_all_files() {
	local paths=(
		~git-tools~
		.gitattributes
		.gitconfig
		.gitignore
		.bash_profile
		.curlrc
		.minttyrc
		.wgetrc

		.bashrc
		.bashrc.d

		config.guess
		editor.sh

		__clean_and_hide.cmd

		.ssh/.gitignore
		.ssh/config

		.gnupg/.gitignore
		.gnupg/gpg.conf

		Tool/README.txt
		Tool/.gitignore

		Tool/build-llvm.sh
		Tool/build-llvm_vs2022.sh

		Tool/build-cross-gcc.sh
		Tool/build-cross-gcc2.sh
		Tool/build-binutils.sh
		Tool/build-gcc.sh
		Tool/build-gdb.sh

		Tool/build-qemu.sh

		Tool/build-cmake.sh
		Tool/build-cmake_vs2022.sh

		Tool/clean.sh
		Tool/common.sh

		Tool/llvm.cygport

		Tool/_quirk
		Tool/_patch/{bash,binutils,cmake,gcc,gdb,llvm,make}

		Tool/{linux.sh,{cygwin,msys,mingw-vcrt,mingw-ucrt,vs2022_cygwin,vs2022_msys}.cmd}

		Util/download/{Cygwin,MSYS2,Visual_Studio}

		Util/other/{crypto,backup}
		Util/{linux_setup,xray-nginx}.sh

		Util/quirk
		Util/shell
	)

	local path
	for path in "${paths[@]}"; do
		echo "${path}"
		dir="$(dirname "${path}")"

		rm -rf "${path}" \
		&& mkdir -p "${dir}" \
		&& cp -rf ~/"${path}" "${dir}"/
	done

	echo "completed"
}

do_update_all_files "$@"

read
