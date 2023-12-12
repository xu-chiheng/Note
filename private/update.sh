
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
		linux_setup.sh

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

		Tool/_quirk
		Tool/_patch

		Tool/linux.sh
		Tool/cygwin.cmd
		Tool/msys.cmd
		Tool/mingw-vcrt.cmd
		Tool/mingw-ucrt.cmd
		Tool/vs2022_cygwin.cmd
		Tool/vs2022_msys.cmd

		Util/download/Cygwin
		Util/download/MSYS2
		Util/download/Visual_Studio

		Util/other/crypto
		Util/other/backup

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
