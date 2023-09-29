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
	local cc=
	local cxx=
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
		x86_64-* )
			# https://www.phoronix.com/news/GCC-11-x86-64-Feature-Levels
			# x86-64: CMOV, CMPXCHG8B, FPU, FXSR, MMX, FXSR, SCE, SSE, SSE2
			# x86-64-v2: (close to Nehalem) CMPXCHG16B, LAHF-SAHF, POPCNT, SSE3, SSE4.1, SSE4.2, SSSE3
			# x86-64-v3: (close to Haswell) AVX, AVX2, BMI1, BMI2, F16C, FMA, LZCNT, MOVBE, XSAVE
			# x86-64-v4: AVX512F, AVX512BW, AVX512CD, AVX512DQ, AVX512VL

			# only gcc 11+ and clang 12+ support this
			# local cpu_arch_flags=( -march=x86-64-v3 )
			local cpu_arch_flags=( -march=x86-64 )
			cflags+=(   "${cpu_arch_flags[@]}" )
			cxxflags+=( "${cpu_arch_flags[@]}" )
			;;
	esac

	case "${build_type}" in
		Release )
			local release_c_cxx_common_flags=( -O3 )
			cflags+=(   "${release_c_cxx_common_flags[@]}" )
			cxxflags+=( "${release_c_cxx_common_flags[@]}" )
			ldflags+=( -Wl,--strip-all )
			;;
		Debug )
			# https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
			# https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
			local debug_c_cxx_common_flags=( -Og -g )
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

	case "${HOST_TRIPLE}" in
		x86_64-pc-mingw64 )
			local mingw_c_cxx_common_flags=(  )
			cflags+=(   "${mingw_c_cxx_common_flags[@]}" )
			cxxflags+=( "${mingw_c_cxx_common_flags[@]}" )
			ldflags+=(  )

			# https://learn.microsoft.com/en-us/cpp/c-runtime-library/link-options
			ldflags+=( -Wl,"$(cygpath -m "$(gcc -print-file-name=binmode.o)")" )
			;;
	esac

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

git_tag_of_package_version() {
	local package="$1"
	local version="$2"
	case "${package}" in
		binutils )
			echo "binutils-$(echo "${version}" | sed -e 's/\./_/g' )"
			;;
		gdb )
			echo "gdb-${version}-release"
			;;
		gcc )
			echo "releases/gcc-${version}"
			;;
		llvm )
			echo "llvmorg-${version}"
			;;
		qemu )
			echo "v${version}"
			;;
		* )
			echo "unknown package : ${package}"
			exit 1
			;;
	esac
}

git_repo_url_of_package() {
	local package="$1"
	case "${package}" in
		binutils | gdb )
			echo "git://sourceware.org/git/binutils-gdb.git"
			;;
		gcc )
			echo "git://gcc.gnu.org/git/gcc.git"
			;;
		llvm )
			echo "https://github.com/llvm/llvm-project"
			;;
		qemu )
			echo "https://gitlab.com/qemu-project/qemu.git"
			;;
		* )
			echo "unknown package : ${package}"
			exit 1
			;;
	esac
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
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local tarball="$4"
	local install_dir="$5"

	local dest_dir="${host_triple}/${toolchain,,}"

	if [ "${build_type}" = Release ]; then
		echo_command rm -rf "${tarball}"{,.sha512} \
		&& { echo_command pushd "${install_dir}" \
			&& time_command tar -cvf  "../${tarball}" * \
			&& echo_command popd;} \
		&& time_command sha512_calculate_file "${tarball}" \
		\
		&& echo_command mkdir -p "${dest_dir}" \
		&& time_command mv -f "${tarball}"{,.sha512} "${dest_dir}"
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

copy_dependent_dlls() {
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

build_and_install_gmp_mpfr_mpc() {
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

build_and_install_binutils_gcc_for_target() {
	local target="$1"
	local toolchain="$2"
	local build_type="$3"
	local host_triple="$4"
	local is_build_and_install_gmp_mpfr_mpc="$5"
	local is_build_and_install_libgcc="$6"
	local binutils_source_dir="$7"
	local gcc_source_dir="$8"
	local gmp_mpfr_mpc_install_dir="$9"
	local package="${10}"
	local version="${11}"

	local gcc_install_dir="${gcc_source_dir}-${target}-${build_type,,}-install"
	local gcc_build_dir="${gcc_source_dir}-${target}-${build_type,,}-build"
	local bin_tarball="${package}-${target}-${version}.tar"
	local binutils_build_dir="${binutils_source_dir}-${target}-${build_type,,}-build"

	local install_prefix="$(pwd)/${gcc_install_dir}"

	local binutils_configure_options=(
			--target="${target}"
			--prefix="${install_prefix}"
			--disable-nls
			--disable-werror
			# https://sourceware.org/legacy-ml/binutils/2014-01/msg00341.html
			--disable-gdb --disable-gdbserver --disable-gdbsupport --disable-libdecnumber --disable-readline --disable-sim
	)

	local gcc_configure_options=(
			--without-headers
			--target="${target}"
	)

	if [ "${is_build_and_install_gmp_mpfr_mpc}" = yes ]; then
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
		&& if [ "${is_build_and_install_libgcc}" = yes ]; then
			time_command parallel_make all-target-libgcc
		fi \
		&& time_command parallel_make install-gcc \
		&& if [ "${is_build_and_install_libgcc}" = yes ]; then
			time_command parallel_make install-target-libgcc
		fi \
		&& echo_command popd;} \
	\
	\
	&& time_command maybe_make_tarball_and_move "${toolchain}" "${build_type}" "${host_triple}" "${bin_tarball}" "${gcc_install_dir}" \
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
build_and_install_cross_gcc_for_targets() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local package="$4"
	local gcc_version="$5"
	local binutils_version="$6"
	local is_build_and_install_gmp_mpfr_mpc="$7"
	local is_build_and_install_libgcc="$8"
	local current_datetime="$9"
	shift 9

	local targets=( "$@" )
	echo "targets :"
	array_elements_print "${targets[@]}"
	local target

	# gcc 13.1.0 and binutils 2.36 combined will fail to build RISC-V libgcc, because of unrecognized new instructions.

	# Note: bintuils 2.37 2.38 2.39 2.40 2.41 can't handle the following line in kernel link script
	#   .head           : { head.o (.multiboot) head.o (.*) }
	# it can't do relocation of 32 bit code in head.o, due to commit 17c6c3b99156fe82c1e637e1a5fd9f163ac788c8

	local gcc_git_tag="$(git_tag_of_package_version gcc "${gcc_version}")"
	local binutils_git_tag="$(git_tag_of_package_version binutils "${binutils_version}")"

	local gcc_git_repo_url="$(git_repo_url_of_package gcc)"
	local binutils_git_repo_url="$(git_repo_url_of_package binutils)"

	local gcc_source_dir="gcc"
	local binutils_source_dir="binutils"

	local gmp_mpfr_mpc_install_dir="gmp-mpfr-mpc-${build_type,,}-install"

	if [ "${is_build_and_install_gmp_mpfr_mpc}" = yes ]; then
		time_command build_and_install_gmp_mpfr_mpc "${build_type}" "${gmp_mpfr_mpc_install_dir}" 2>&1 | tee "~${current_datetime}-gmp-mpfr-mpc-output.txt"
	fi \
	&& time_command check_dir_maybe_clone_and_checkout_tag "${binutils_source_dir}" "${binutils_git_tag}" "${binutils_git_repo_url}" \
	&& time_command check_dir_maybe_clone_and_checkout_tag "${gcc_source_dir}" "${gcc_git_tag}" "${gcc_git_repo_url}" \
	\
	&& echo "building binutils and gcc ......" \
	&& for target in "${targets[@]}"; do
			time_command build_and_install_binutils_gcc_for_target \
			"${target}" "${toolchain}" "${build_type}" "${host_triple}" \
			"${is_build_and_install_gmp_mpfr_mpc}" "${is_build_and_install_libgcc}" "${binutils_source_dir}" "${gcc_source_dir}" \
			"${gmp_mpfr_mpc_install_dir}" "${package}" "${gcc_version}" \
			2>&1 | tee "~${current_datetime}-${package}-${target}-output.txt" &
	done \
	&& time_command wait \
	&& echo "completed" \
	&& time_command sync
}

pre_generate_package() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = gcc ]; then
		echo_command mingw_gcc_check_or_create_directory_links \
		&& echo_command mingw_gcc_check_or_create_directory_links_2 "$(pwd)/${install_dir}/mingw" \
		&& echo_command mingw_gcc_check_or_create_directory_links_1 "$(pwd)/${install_dir}/${host_triple}"
	fi
}

post_build_package() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = gcc ]; then
		echo_command mingw_gcc_remove_directory_links_2 "$(pwd)/${install_dir}/mingw" \
		&& echo_command mingw_gcc_remove_directory_links_1 "$(pwd)/${install_dir}/${host_triple}"
	fi
}

post_install_package() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = qemu ]; then
		echo_command copy_dependent_dlls "${host_triple}" "${install_dir}" "."
	fi
}

generate_build_install_package() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local source_dir="$4"
	local install_dir="$5"
	local package="$6"
	local version="$7"
	local pushd_and_generate_command="$8"
	shift 8
	local bin_tarball="${package}-${version}.tar"
	local git_tag="$(git_tag_of_package_version "${package}" "${version}")"
	local git_repo_url="$(git_repo_url_of_package "${package}")"

	# https://stackoverflow.com/questions/11307465/destdir-and-prefix-of-make

	time_command check_dir_maybe_clone_and_checkout_tag "${source_dir}" "${git_tag}" "${git_repo_url}" \
	&& echo_command rm -rf "${install_dir}" \
	&& echo_command pre_generate_package "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
	&& { time_command "${pushd_and_generate_command}" "$@" \
		&& time_command parallel_make \
		&& echo_command pushd .. \
		&& echo_command post_build_package "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
		&& echo_command popd \
		&& time_command parallel_make install \
		&& echo_command popd;} \
	&& echo_command post_install_package "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
	&& time_command maybe_make_tarball_and_move "${toolchain}" "${build_type}" "${host_triple}" "${bin_tarball}" "${install_dir}" \
	&& time_command sync
}

cmake_build_install_package() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local package="$4"
	local version="$5"
	local cc="$6"
	local cxx="$7"
	local cflags="$8"
	local cxxflags="$9"
	local ldflags="${10}"
	shift 10

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

	time_command generate_build_install_package \
		"${toolchain}" "${build_type}" "${host_triple}" "${source_dir}" "${install_dir}" "${package}" "${version}" \
		pushd_and_cmake "${build_dir}" "${generic_cmake_options[@]}" "$@"
}

configure_build_install_package() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local package="$4"
	local version="$5"
	shift 5

	local source_dir="${package}"
	local build_dir="${source_dir}-${build_type,,}-build"
	local install_dir="${source_dir}-${build_type,,}-install"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_configure_options=(
			--prefix="${install_prefix}"
	)

	time_command generate_build_install_package \
		"${toolchain}" "${build_type}" "${host_triple}" "${source_dir}" "${install_dir}" "${package}" "${version}" \
		pushd_and_configure "${build_dir}" "${source_dir}" "${generic_configure_options[@]}" "$@"
}

gcc_configure_build_install_package() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local package="$4"
	local version="$5"
	shift 5

	local source_dir="${package}"
	local build_dir="${source_dir}-${build_type,,}-build"
	local install_dir="${source_dir}-${build_type,,}-install"

	local languages=(
		# all
		c
		c++
	)

	time_command generate_build_install_package \
		"${toolchain}" "${build_type}" "${host_triple}" "${source_dir}" "${install_dir}" "${package}" "${version}" \
		gcc_pushd_and_configure "${build_dir}" "${source_dir}" "${install_dir}" "$(array_elements_join ',' "${languages[@]}")" "${host_triple}" "$@"
}
