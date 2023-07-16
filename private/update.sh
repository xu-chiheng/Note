
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

		Tool/.gitignore

		Tool/build-clang.sh
		Tool/build-clang_vs2022.sh
		Tool/build-cross-gcc.sh
		Tool/build-cross-gcc2.sh
		Tool/build-qemu.sh
		Tool/clean.sh
		Tool/common.sh

		Tool/cygwin
		Tool/mingw

		Tool/linux.sh
		Tool/cygwin.cmd
		Tool/msys.cmd
		Tool/mingw.cmd
		Tool/mingw-ucrt.cmd
		Tool/vs2022_cygwin.cmd
		Tool/vs2022_msys.cmd

		Utils/download/Cygwin
		Utils/download/MSYS2
		Utils/download/Visual_Studio

		Utils/other/crypto
		Utils/other/backup

		Utils/shell
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
