
cd ..

do_update_all_files() {
	local paths=(
		README.txt
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

		.ssh/{.gitignore,README.txt,config}
		.gnupg/{.gitignore,README.txt,gpg.conf,gpg-agent.conf}

		config.guess
		editor.sh

		__clean_or_hide.cmd

		{eclipse-workspace,runtime-EclipseApplication}/{.gitignore,{clean,cygwin,backup_metadata_dir,git_add_-f_prefs_files}.cmd}

		IDE/{.gitignore,cygwin.cmd,README.md,patch}
		IDE/{remove_unneeded_plug-ins,generate_list_of_changed_files}.{cmd,sh,sh.txt}
		IDE/list_of{,_non}_java_files_{added,modified,deleted}.txt

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

		Tool/_cygport/{.gitignore,cygwin.cmd,llvm.cygport}

		Tool/_doc
		Tool/_quirk
		Tool/_patch/{bash,binutils,cmake,gcc,gdb,llvm,make,mintty,konsole,qemu}

		Tool/{linux.sh,{cygwin,msys,mingw-vcrt,mingw-ucrt,vs2022_cygwin,vs2022_msys}.cmd}

		Util/download/{Cygwin,MSYS2,Visual_Studio,Linux,Windows_10_Enterprise_ISO}

		Util/other/{crypto,backup}
		Util/{linux_setup,xray-nginx,wireguard}.sh

		Util/quirk
		Util/shell
		Util/setting/Editors
	)

	local path
	for path in "${paths[@]}"; do
		if [ -e ~/"${path}" ]; then
			echo "${path}"
			dir="$(dirname "${path}")"
			rm -rf "${path}" \
			&& mkdir -p "${dir}" \
			&& cp -rf ~/"${path}" "${dir}"
		else
			echo "${path} does not exist"
		fi
	done
	echo "Completed!"
}

do_update_all_files "$@"

read
