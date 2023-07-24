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

check_toolchain_build_type_and_set_compiler_flags() {
	local toolchain="$1"
	local build_type="$2"
	local cc
	local cxx
	local cflags=()
	local cxxflags=()
	local ldflags=()

	if [ -z "${toolchain}" ];then
		toolchain=GCC
	fi

	if [ -z "${build_type}" ];then
		build_type=Release
	fi

	case "${toolchain}" in
		GCC )
			cc=gcc
			cxx=g++
			;;
		Clang )
			cc=clang
			cxx=clang++
			;;
		* )
			echo "unknown toolchain : ${toolchain}"
			echo "valid toolchain : GCC Clang"
			exit
			;;
	esac

	# Disable color errors globally?
	# http://clang-developers.42468.n3.nabble.com/Disable-color-errors-globally-td4065317.html
	export TERM=dumb
	# VERBOSE=1 make
	export VERBOSE=1

	local cpu_arch_flags=()
	case "${HOST_TRIPLE}" in
		x86_64-pc-* )
			# https://www.phoronix.com/news/GCC-11-x86-64-Feature-Levels
			# x86-64: CMOV, CMPXCHG8B, FPU, FXSR, MMX, FXSR, SCE, SSE, SSE2
			# x86-64-v2: (close to Nehalem) CMPXCHG16B, LAHF-SAHF, POPCNT, SSE3, SSE4.1, SSE4.2, SSSE3
			# x86-64-v3: (close to Haswell) AVX, AVX2, BMI1, BMI2, F16C, FMA, LZCNT, MOVBE, XSAVE
			# x86-64-v4: AVX512F, AVX512BW, AVX512CD, AVX512DQ, AVX512VL

			# only gcc 11+ and clang 12+ support this
			# local cpu_arch_flags=( -march=x86-64-v3 )
			local cpu_arch_flags+=( -march=x86-64 )
			;;
	esac

	case "${build_type}" in
		Release )
			local release_c_cxx_common_flags=( "${cpu_arch_flags[@]}" -O3 )
			cflags+=(   "${release_c_cxx_common_flags[@]}" )
			cxxflags+=( "${release_c_cxx_common_flags[@]}" )
			# ldflags+=( -Wl,--strip-all )
			;;
		Debug )
			local debug_c_cxx_common_flags=( "${cpu_arch_flags[@]}" -O0 -g )
			cflags+=(   "${debug_c_cxx_common_flags[@]}" )
			cxxflags+=( "${debug_c_cxx_common_flags[@]}" )
			ldflags+=()
			;;
		* )
			echo "unknown build type : ${build_type}"
			echo "valid build type : Release Debug"
			exit
			;;
	esac

	case "${toolchain}" in
		Clang )
			local clang_c_cxx_flags=( -Wno-unknown-warning-option )
			cflags+=(   "${clang_c_cxx_flags[@]}" )
			cxxflags+=( "${clang_c_cxx_flags[@]}" )
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin )
			case "${toolchain}" in
				Clang )

					# /usr/bin/ld: ../../../../lib/libLLVMSupport.a(Parallel.cpp.o):Parallel.cpp:(.text+0x130): multiple definition of `TLS wrapper function for llvm::parallel::threadIndex'; ../../../../lib/liblldELF.a(Relocations.cpp.o):Relocations.cpp:(.text+0xf3c0): first defined here
					# make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
					# [100%] Built target clang-scan-deps
					# clang-8: error: linker command failed with exit code 1 (use -v to see invocation)
					# make[2]: *** [tools/lld/tools/lld/CMakeFiles/lld.dir/build.make:273: bin/lld.exe] Error 1
					# make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
					# make[1]: *** [CMakeFiles/Makefile2:56980: tools/lld/tools/lld/CMakeFiles/lld.dir/all] Error 2
					# make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
					# make: *** [Makefile:156: all] Error 2

					ldflags+=(  -Wl,--allow-multiple-definition )
					;;
			esac
			;;
		x86_64-pc-mingw64 )
			# https://learn.microsoft.com/en-us/cpp/c-runtime-library/link-options
			# binmode.obj	pbinmode.obj	Sets the default file-translation mode to binary. See _fmode.

			# MinGW-w64 runtime has regression in binmode.o, which defaulted to text mode,
			# will cause Cross GCC to corrupt libgcc's .o and .a files

			# E:\Note\Tool\gcc-x86_64-elf-release-install\x86_64-elf\bin\ar.exe: libgcov.a: error reading _gcov_merge_add.o: file truncated
			# make[1]: *** [Makefile:939: libgcov.a] Error 1
			# make[1]: *** Waiting for unfinished jobs....
			# make[1]: Leaving directory '/c/Users/Administrator/Tool/gcc-x86_64-elf-release-build/x86_64-elf/libgcc'
			# make: *** [Makefile:13696: all-target-libgcc] Error 2

			ldflags+=( -Wl,"$(cygpath -m /mingw64/lib/binmode.o)" )
			;;
	esac

	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			# https://cygwin.fandom.com/wiki/Rebaseall
			# https://community.bmc.com/s/news/aA33n000000CiC6CAK/cygwin-rebase-utility-for-bsa
			# https://pipeline.lbl.gov/code/3rd_party/licenses.win/Cygwin/rebase-3.0.README
			# https://cygwin.com/git/gitweb.cgi?p=cygwin-apps/rebase.git;f=README;hb=HEAD

			#       0 [main] clang-17 1506 child_info_fork::abort: \??\D:\cygwin64-packages\clang\bin\cygclangLex-17git.dll: Loaded to different address: parent(0x16E0000) != child(0x5C12D0000)
			# clang++: error: unable to execute command: posix_spawn failed: Resource temporarily unavailable
			#       0 [main] clang-17 1507 child_info_fork::abort: \??\D:\cygwin64-packages\clang\bin\cygLLVMRISCVCodeGen-17git.dll: Loaded to different address: parent(0xE60000) != child(0xEC0000)
			# clang++: error: unable to execute command: posix_spawn failed: Resource temporarily unavailable

			ldflags+=( -Wl,--enable-auto-image-base -Wl,--dynamicbase )
			;;
	esac

	# if true; then
	#     # Do not link against shared libraries
	#     ldflags+=( -Wl,-Bstatic )
	# else
	#     # Link against shared libraries
	#     ldflags+=( -Wl,-Bdynamic )
	# fi

	export TOOLCHAIN="${toolchain}"
	export BUILD_TYPE="${build_type}"
	export CC="${cc}"
	export CXX="${cxx}"
	export CFLAGS="${cflags[*]}"
	export CXXFLAGS="${cxxflags[*]}"
	export LDFLAGS="${ldflags[*]}"

	echo "TOOLCHAIN  : ${TOOLCHAIN}"
	echo "BUILD_TYPE : ${BUILD_TYPE}"
	echo "CC         : ${CC} $("${CC}" -dumpversion) $(which "${CC}")"
	echo "CXX        : ${CXX} $("${CXX}" -dumpversion) $(which "${CXX}")"
	echo "CFLAGS     : ${CFLAGS}"
	echo "CXXFLAGS   : ${CXXFLAGS}"
	echo "LDFLAGS    : ${LDFLAGS}"
}

# control llvm as a library, whether is static or shared
check_llvm_static_or_shared() {
	local llvm_static_or_shared="$1"
	if [ -z "${llvm_static_or_shared}" ];then
		llvm_static_or_shared=static
	fi
	case "${llvm_static_or_shared}" in
		static | shared )
			true
			;;
		* )
			echo "unknown arg : ${llvm_static_or_shared}"
			echo "valid arg : static shared"
			exit
			;;
	esac
	export LLVM_STATIC_OR_SHARED="${llvm_static_or_shared}"
	echo "LLVM_STATIC_OR_SHARED : ${LLVM_STATIC_OR_SHARED}"
}

maybe_git_filemode_false() {
	case "${HOST_TRIPLE}" in
		x86_64-pc-cygwin | x86_64-pc-msys | x86_64-pc-mingw64 )
			# MSYS2 git seem have file mode problem. Even newly cloned repo has diff over file mode.
			echo_command git_filemode_false
			;;
	esac
}

binutils_git_tag_from_version() {
	local version="$1"
	echo "binutils-$(echo "${version}" | sed -e 's/\./_/g' )"
}

gcc_git_tag_from_version() {
	local version="$1"
	echo "releases/gcc-${version}"
}

git_checkout_dir_revision() {
	local dir="$1"
	local revision="$2"

	{ pushd "${dir}" \
	&& echo_command maybe_git_filemode_false \
	&& time_command git reset --hard HEAD \
	&& time_command git checkout --detach "${revision}" \
	&& popd;}
}

git_clone_and_checkout_dir_revision() {
	local dir="$1"
	local revision="$2"
	local git_repo_url="$3"

	time_command git clone --no-checkout "${git_repo_url}" "${dir}" \
	&& echo_command git_checkout_dir_revision "${dir}" "${revision}"
}

check_dir_maybe_clone_and_checkout_tag() {
	local dir="$1"
	local tag="$2"
	local git_repo_url="$3"

	if [ -d "${dir}" ]; then
		if [ -f "${dir}"/patching ]; then
			# do nothing
			true
		elif [ -d "${dir}"/.git ]; then
			echo_command git_checkout_dir_revision "${dir}" "${tag}"
		else
			echo "source directory ${dir} exists, but contains no patching file, or .git directory."
			echo_command rm -rf "${dir}" \
			&& echo_command git_clone_and_checkout_dir_revision "${dir}" "${tag}" "${git_repo_url}"
		fi
	else
		echo "dir ${dir} does not exist"
		echo_command git_clone_and_checkout_dir_revision "${dir}" "${tag}" "${git_repo_url}"
	fi
}

maybe_make_tarball_and_move() {
	local build_type="$1"
	local tarball_name="$2"
	local install_dir="$3"
	local host_triple="$4"

	if [ "${build_type}" != Debug ]; then
		echo_command rm -rf "${tarball_name}" \
		&& { echo_command pushd "${install_dir}" \
			&& time_command tar -cvf  "../${tarball_name}" * \
			&& echo_command popd;} \
		&& time_command sha512_calculate_file "${tarball_name}" \
		\
		&& echo_command mkdir -p "${host_triple}" \
		&& time_command mv -f "${tarball_name}"{,.sha512} "${host_triple}"
	fi
}

download_and_verify_source_tarball() {
	local url="$1"
	local base="$(basename "${url}")"

	if [ ! -f "${base}" ]; then
		time_command wget --quiet "${url}"
	fi \
	&& if [ ! -f "${base}".sha512 ]; then
		time_command sha512_calculate_file "${base}"
	else
		time_command sha512_check_file "${base}".sha512
	fi
}

pushd_and_cmake() {
	local build_dir="$1"
	shift 1

	echo "cmake options :"
	array_elements_print "$@"

	echo_command rm -rf "${build_dir}" \
	&& echo_command mkdir "${build_dir}" \
	&& echo_command pushd "${build_dir}" \
	&& time_command cmake "$@"
}

pushd_and_configure() {
	local build_dir="$1"
	local source_dir="$2"
	shift 2

	echo "configure options :"
	array_elements_print "$@"

	echo_command rm -rf "${build_dir}" \
	&& echo_command mkdir "${build_dir}" \
	&& echo_command pushd "${build_dir}" \
	&& time_command ../"${source_dir}"/configure "$@"
}

extract_tarball() {
	local tarball="$1"
	local extracted_dir="$2"
	local source_dir="$3"

	echo_command rm -rf "${extracted_dir}" "${source_dir}" \
	&& time_command tar -xvf "${tarball}" \
	&& echo_command mv "${extracted_dir}" "${source_dir}"
}

extract_configure_build_and_install_package() {
	local package="$1"
	local tarball="$2"
	local extracted_dir="$3"
	local build_dir="$4"
	local install_dir="$5"
	shift 5

	local source_dir="${package}"

	time_command extract_tarball "${tarball}" "${extracted_dir}" "${source_dir}" \
	&& { time_command pushd_and_configure "${build_dir}" "${source_dir}" "$@" \
		&& time_command parallel_make \
		&& time_command parallel_make install \
		&& echo_command popd;}
}

gcc_pushd_and_configure() {
	local build_dir="$1"
	local source_dir="$2"
	local install_dir="$3"
	local languages="$4"
	local host_triple="$5"
	shift 5

	# https://www.linuxfromscratch.org/lfs/view/7.1/chapter06/gcc.html
	# gcc/Makefile.in
	# # Control whether to run fixincludes.
	# STMP_FIXINC = @STMP_FIXINC@
	# sed -i -e 's,@STMP_FIXINC@,,g' "${source_dir}/gcc/Makefile.in"

	# --disable-fixincludes
	# make[2]: *** No rule to make target '../build-x86_64-pc-cygwin/fixincludes/fixinc.sh', needed by 'stmp-fixinc'.  Stop.

	local build_fixincludes_dir="build-${host_triple}/fixincludes"

	local install_prefix="$(pwd)/${install_dir}"

	local gcc_generic_configure_options=(
			--prefix="${install_prefix}"
			--enable-languages="${languages}"
			--disable-bootstrap
			--disable-nls
			--disable-werror
			--disable-win32-registry
			--enable-checking=release
			--disable-fixincludes
	)
	time_command pushd_and_configure "${build_dir}" "${source_dir}" "${gcc_generic_configure_options[@]}" "$@" \
	&& echo_command mkdir -p "${build_fixincludes_dir}" \
	&& echo_command touch "${build_fixincludes_dir}/fixinc.sh"
}


# gcc_test() {
#     time_command parallel_make -k check 2>&1 | tee "../gcc_test_$(current_datetime).txt"
#     sync
# }


do_copy_dependent_dlls() {
	local host_triple="$1"
	local install_dir="$2"
	local install_exe_dir="$3"
	local root_dirs=()
	local bin_dirs=()
	case "${host_triple}" in
		x86_64-pc-cygwin | x86_64-pc-mingw64 | x86_64-pc-msys )
			case "${host_triple}" in
				x86_64-pc-mingw64 )
					case "${MSYSTEM}" in
						MINGW64 )
							# msvcrt.dll
							root_dirs+=( /mingw64 )
							;;
						UCRT64 )
							# ucrtbase.dll
							root_dirs+=( /ucrt64 )
							;;
						* )
							echo "unknown MSYSTEM : ${MSYSTEM}"
							exit 1
							;;
					esac
					;;
				x86_64-pc-cygwin )
					# cygwin1.dll
					root_dirs+=( /usr / )
					;;
				x86_64-pc-msys )
					# msys-2.0.dll
					root_dirs+=( /usr / )
					;;
			esac
			for root_dir in "${root_dirs[@]}"
			do
				bin_dirs+=( "${root_dir}/bin/" )
			done
			# echo "bin_dirs : "  "${bin_dirs[@]}"
			local dest_dir="${install_dir}/${install_exe_dir}"
			echo_command mkdir -p "${dest_dir}" \
			&& echo_command cp $(ldd $(find "${install_dir}" -name '*.exe') | awk '{print $3}' | grep -E "$(array_elements_join '|' "${bin_dirs[@]}")" | sort | uniq) "${dest_dir}"
			;;
	esac
}

do_build_and_install_gmp_mpfr_mpc() {
	local build_type="$1"
	local gmp_mpfr_mpc_install_dir="$2"

	local gmp_version=6.2.1
	local mpfr_version=4.1.0
	local mpc_version=1.2.1

	local gmp_tarball="gmp-${gmp_version}.tar.xz"
	local mpfr_tarball="mpfr-${mpfr_version}.tar.xz"
	local mpc_tarball="mpc-${mpc_version}.tar.gz"

	local gmp_extracted_dir="gmp-${gmp_version}"
	local mpfr_extracted_dir="mpfr-${mpfr_version}"
	local mpc_extracted_dir="mpc-${mpc_version}"

	local gmp_build_dir="gmp-${build_type,,}-build"
	local mpfr_build_dir="mpfr-${build_type,,}-build"
	local mpc_build_dir="mpc-${build_type,,}-build"

	# local mirror_site=https://mirrors.aliyun.com
	# local mirror_site=https://mirrors.tuna.tsinghua.edu.cn
	local mirror_site=https://mirrors.ustc.edu.cn

	local install_prefix="$(pwd)/${gmp_mpfr_mpc_install_dir}"

	echo "downloading source code ......" \
	&& time_command download_and_verify_source_tarball "${mirror_site}/gnu/gmp/${gmp_tarball}" \
	&& time_command download_and_verify_source_tarball "${mirror_site}/gnu/mpfr/${mpfr_tarball}" \
	&& time_command download_and_verify_source_tarball "${mirror_site}/gnu/mpc/${mpc_tarball}" \
	&& echo "completed" \
	\
	&& echo_command rm -rf "${gmp_mpfr_mpc_install_dir}" \
	\
	&& echo "building gmp mpfr mpc ......" \
	&& time_command extract_configure_build_and_install_package gmp "${gmp_tarball}" "${gmp_extracted_dir}" "${gmp_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared \
	&& time_command extract_configure_build_and_install_package mpfr "${mpfr_tarball}" "${mpfr_extracted_dir}" "${mpfr_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared --with-gmp="${install_prefix}" \
	&& time_command extract_configure_build_and_install_package mpc "${mpc_tarball}" "${mpc_extracted_dir}" "${mpc_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared --with-gmp="${install_prefix}" \
	&& echo "completed"
}

do_build_and_install_binutils_gcc_for_target() {
	local target="$1"
	local build_type="$2"
	local build_and_install_gmp_mpfr_mpc="$3"
	local build_and_install_libgcc="$4"
	local binutils_source_dir="$5"
	local gcc_source_dir="$6"
	local gmp_mpfr_mpc_install_dir="$7"
	local host_triple="$8"
	local package="$9"
	local version="${10}"

	local gcc_install_dir="${gcc_source_dir}-${target}-${build_type,,}-install"
	local gcc_build_dir="${gcc_source_dir}-${target}-${build_type,,}-build"
	local bin_tarball_name="${package}-${target}-${version}.tar"
	local binutils_build_dir="${binutils_source_dir}-${target}-${build_type,,}-build"

	local install_prefix="$(pwd)/${gcc_install_dir}"

	local binutils_configure_options=(
			--target="${target}"
			--prefix="${install_prefix}"
			--disable-nls
			--disable-werror
	)
	local gcc_configure_options=(
			--without-headers
			--target="${target}"
	)
	if [ "${build_and_install_gmp_mpfr_mpc}" = yes ]; then
		gcc_configure_options+=(
			--with-gmp="${gmp_mpfr_mpc_install_dir}"
			--with-mpfr="${gmp_mpfr_mpc_install_dir}"
			--with-mpc="${gmp_mpfr_mpc_install_dir}"
		)
	fi


	local languages=(
		# all
		c
		c++
	)

	# The $PREFIX/bin dir _must_ be in the PATH.
	local old_path="${PATH}"

	echo_command rm -rf "${gcc_install_dir}" \
	\
	&& echo_command export PATH="${gcc_install_dir}/bin:${old_path}" \
	\
	&& { time_command pushd_and_configure "${binutils_build_dir}" "${binutils_source_dir}" \
			"${binutils_configure_options[@]}" \
		&& time_command parallel_make \
		&& time_command parallel_make install \
		&& echo_command popd;} \
	\
	\
	&& { time_command gcc_pushd_and_configure "${gcc_build_dir}" "${gcc_source_dir}" "${gcc_install_dir}" \
			"$(array_elements_join ',' "${languages[@]}")" "${host_triple}" \
			"${gcc_configure_options[@]}" \
		&& time_command parallel_make all-gcc \
		&& if [ "${build_and_install_libgcc}" = yes ]; then
			time_command parallel_make all-target-libgcc
		fi \
		&& time_command parallel_make install-gcc \
		&& if [ "${build_and_install_libgcc}" = yes ]; then
			time_command parallel_make install-target-libgcc
		fi \
		&& echo_command popd;} \
	\
	\
	&& time_command maybe_make_tarball_and_move "${build_type}" "${bin_tarball_name}" "${gcc_install_dir}" "${host_triple}" \
	\
	&& echo_command export PATH="${old_path}"
}

# http://wiki.osdev.org/GCC_Cross-Compiler
# https://gcc.gnu.org/install/configure.html
# https://gcc.gnu.org/install/specific.html
# https://github.com/richfelker/musl-cross-make

# https://wiki.gentoo.org/wiki/Crossdev
# https://wiki.gentoo.org/wiki/Cross_build_environment
# https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Creating_a_cross-compiler
do_build_and_install_cross_gcc_for_targets() {
	local build_type="$1"
	local build_and_install_gmp_mpfr_mpc="$2"
	local build_and_install_libgcc="$3"
	local host_triple="$4"
	local current_datetime="$5"
	local package="$6"
	shift 6

	local targets=( "$@" )
	echo "targets :"
	array_elements_print "${targets[@]}"
	local target

	# gcc 13.1.0 and binutils 2.36 combined will fail to build RISC-V libgcc, because of unrecognized new instructions.
	local gcc_version=12.3.0
	local binutils_version=2.36

	# bintuils 2.40 can't be built on Cygwin, due to too new version of texinfo/makeinfo package.

	# Note: bintuils 2.37 2.38 and maybe 2.39 can't handle the following line in kernel link script
	#   .head           : { head.o (.multiboot) head.o (.*) }
	# it can't do relocation of 32 bit code in head.o, due to commit 17c6c3b99156fe82c1e637e1a5fd9f163ac788c8

	local gcc_git_tag="$(gcc_git_tag_from_version "${gcc_version}")"
	local binutils_git_tag="$(binutils_git_tag_from_version "${binutils_version}")"

	local gcc_git_repo_url="git://gcc.gnu.org/git/gcc.git"
	local binutils_git_repo_url="git://sourceware.org/git/binutils-gdb.git"

	local gcc_source_dir="gcc"
	local binutils_source_dir="binutils-gdb"

	local gmp_mpfr_mpc_install_dir="gmp-mpfr-mpc-${build_type,,}-install"

	if [ "${build_and_install_gmp_mpfr_mpc}" = yes ]; then
		time_command do_build_and_install_gmp_mpfr_mpc "${build_type}" "${gmp_mpfr_mpc_install_dir}" 2>&1 | tee "~${current_datetime}-gmp-mpfr-mpc-output.txt"
	fi \
	&& time_command check_dir_maybe_clone_and_checkout_tag "${binutils_source_dir}" "${binutils_git_tag}" "${binutils_git_repo_url}" \
	&& echo_command binutils_source_dir_prepare "${binutils_source_dir}" \
	&& time_command check_dir_maybe_clone_and_checkout_tag "${gcc_source_dir}" "${gcc_git_tag}" "${gcc_git_repo_url}" \
	\
	&& echo "building binutils and gcc ......" \
	&& for target in "${targets[@]}"; do
			time_command do_build_and_install_binutils_gcc_for_target "${target}" "${build_type}" \
			"${build_and_install_gmp_mpfr_mpc}" "${build_and_install_libgcc}" "${binutils_source_dir}" "${gcc_source_dir}" \
			"${gmp_mpfr_mpc_install_dir}" "${host_triple}" "${package}" "${gcc_version}" \
			2>&1 | tee "~${current_datetime}-${package}-${target}-output.txt" &
	done \
	&& time_command wait \
	&& echo "completed" \
	&& time_command sync
}

binutils_source_dir_prepare() {
	local source_dir="$1"
	echo_command rm -rf "${source_dir}"/{contrib,gdb,gdbserver,gdbsupport,gnulib,libdecnumber,readline,sim}
}

gdb_source_dir_prepare() {
	local source_dir="$1"
	# TODO: FIX
	echo_command rm -rf "${source_dir}"/{contrib,gdb,gdbserver,gdbsupport,gnulib,libdecnumber,readline,sim}
}


pre_generate_build_install_package() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${package}" = binutils ]; then
		echo_command binutils_source_dir_prepare "${source_dir}"
	elif [ "${package}" = gdb ]; then
		echo_command gdb_source_dir_prepare "${source_dir}"
	elif [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = gcc ]; then
		echo_command mingw_gcc_check_or_create_directory_links /mingw \
		&& echo_command mingw_gcc_check_or_create_directory_links "${install_dir}/mingw" \
		&& echo_command mingw_gcc_check_or_create_directory_links "${install_dir}/${host_triple}"
	fi

}

post_generate_build_install_package() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = qemu ]; then
		echo_command do_copy_dependent_dlls "${host_triple}" "${install_dir}" "."
	elif [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = gcc ]; then
		true
	fi
}

generate_build_install_package() {
	local build_type="$1"
	local source_dir="$2"
	local install_dir="$3"
	local host_triple="$4"
	local package="$5"
	local version="$6"
	local git_tag="$7"
	local git_repo_url="$8"
	local pushd_and_generate_command="$9"
	shift 9
	local bin_tarball_name="${package}-${version}.tar"

	# https://stackoverflow.com/questions/11307465/destdir-and-prefix-of-make

	time_command check_dir_maybe_clone_and_checkout_tag "${source_dir}" "${git_tag}" "${git_repo_url}" \
	&& echo_command rm -rf "${install_dir}" \
	&& pre_generate_build_install_package "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
	&& { time_command "${pushd_and_generate_command}" "$@" \
		&& time_command parallel_make \
		&& time_command parallel_make install \
		&& echo_command popd;} \
	&& post_generate_build_install_package "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
	&& time_command maybe_make_tarball_and_move "${build_type}" "${bin_tarball_name}" "${install_dir}" "${host_triple}" \
	&& time_command sync
}

cmake_build_install_package() {
	local build_type="$1"
	local host_triple="$2"
	local package="$3"
	local version="$4"
	local git_tag="$5"
	local git_repo_url="$6"
	local cc="$7"
	local cxx="$8"
	local cflags="$9"
	local cxxflags="${10}"
	local ldflags="${11}"
	shift 11

	local source_dir="${package}"
	local build_dir="${source_dir}-${build_type,,}-build"
	local install_dir="${source_dir}-${build_type,,}-install"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_cmake_options=(
			-G 'Unix Makefiles'
			-DCMAKE_BUILD_TYPE="${build_type}"
			-DCMAKE_INSTALL_PREFIX="${install_prefix}"

			-DCMAKE_C_COMPILER="${cc}"
			-DCMAKE_CXX_COMPILER="${cxx}"
			-DCMAKE_ASM_COMPILER="${cxx}"
			-DCMAKE_C_FLAGS="${cflags}"
			-DCMAKE_CXX_FLAGS="${cxxflags}"
	)

	time_command generate_build_install_package "${build_type}" "${source_dir}" "${install_dir}" \
		"${host_triple}" "${package}" "${version}" "${git_tag}" "${git_repo_url}" \
		pushd_and_cmake "${build_dir}" "${generic_cmake_options[@]}" "$@"
}

configure_build_install_package() {
	local build_type="$1"
	local host_triple="$2"
	local package="$3"
	local version="$4"
	local git_tag="$5"
	local git_repo_url="$6"
	shift 6

	local source_dir="${package}"
	local build_dir="${source_dir}-${build_type,,}-build"
	local install_dir="${source_dir}-${build_type,,}-install"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_configure_options=(
			--prefix="${install_prefix}"
	)

	time_command generate_build_install_package "${build_type}" "${source_dir}" "${install_dir}" \
		"${host_triple}" "${package}" "${version}" "${git_tag}" "${git_repo_url}" \
		pushd_and_configure "${build_dir}" "${source_dir}" "${generic_configure_options[@]}" "$@"
}

gcc_configure_build_install_package() {
	local build_type="$1"
	local host_triple="$2"
	local package="$3"
	local version="$4"
	local git_tag="$5"
	local git_repo_url="$6"
	shift 6

	local source_dir="${package}"
	local build_dir="${source_dir}-${build_type,,}-build"
	local install_dir="${source_dir}-${build_type,,}-install"

	local languages=(
		# all
		c
		c++
	)

	time_command generate_build_install_package "${build_type}" "${source_dir}" "${install_dir}" \
		"${host_triple}" "${package}" "${version}" "${git_tag}" "${git_repo_url}" \
		gcc_pushd_and_configure "${build_dir}" "${source_dir}" "${install_dir}" "$(array_elements_join ',' "${languages[@]}")" "${host_triple}" "$@"
}
