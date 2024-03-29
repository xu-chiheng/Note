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
	local host_triple="$3"
	local package="$4"
	local cc=
	local cxx=
	local cflags=()
	local cxxflags=()
	local ldflags=()

	if [ -z "${toolchain}" ]; then
		toolchain=GCC
	fi

	if [ -z "${build_type}" ]; then
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
			exit 1
			;;
	esac

	local cc_dir="$(print_program_dir "${cc}")"
	local cxx_dir="$(print_program_dir "${cxx}")"

	if [ "${cc_dir}" != "${cxx_dir}" ]; then
		echo "the dirs of C compiler ${cc} at ${cc_dir} and C++ compiler ${cxx} at ${cxx_dir} is not the same"
		exit 1
	fi
	if [ "$(basename "${cc_dir}")" != bin ]; then
		echo "compiler is not in a bin directory"
		exit 1
	fi
	local compiler_install_dir="$(dirname "${cc_dir}")"



	# Disable color errors globally?
	# http://clang-developers.42468.n3.nabble.com/Disable-color-errors-globally-td4065317.html
	export TERM=dumb
	# VERBOSE=1 make
	export VERBOSE=1

	local cpu_arch_flags=()
	case "${host_triple}" in
		x86_64-* )
			# https://www.phoronix.com/news/GCC-11-x86-64-Feature-Levels
			# x86-64: CMOV, CMPXCHG8B, FPU, FXSR, MMX, FXSR, SCE, SSE, SSE2
			# x86-64-v2: (close to Nehalem) CMPXCHG16B, LAHF-SAHF, POPCNT, SSE3, SSE4.1, SSE4.2, SSSE3
			# x86-64-v3: (close to Haswell) AVX, AVX2, BMI1, BMI2, F16C, FMA, LZCNT, MOVBE, XSAVE
			# x86-64-v4: AVX512F, AVX512BW, AVX512CD, AVX512DQ, AVX512VL

			# only gcc 11+ and clang 12+ support this
			# local cpu_arch_flags=( -march=x86-64-v3 )
			cpu_arch_flags+=( -march=x86-64 )
			;;
	esac
	cflags+=(   "${cpu_arch_flags[@]}" )
	cxxflags+=( "${cpu_arch_flags[@]}" )

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
			exit 1
			;;
	esac

	case "${host_triple}" in
		x86_64-pc-cygwin )
			local cygwin_c_cxx_common_flags=(  )
			# cygwin_c_cxx_common_flags+=( -mcmodel=small )
			cflags+=(   "${cygwin_c_cxx_common_flags[@]}" )
			cxxflags+=( "${cygwin_c_cxx_common_flags[@]}" )
			if [ "${compiler_install_dir}" = /usr ]; then
				# pre-installed GCC 11.4.0 and Clang 8.0.1 at /usr need this option
				ldflags+=( -Wl,--dynamicbase )
			fi
			;;
		x86_64-pc-mingw64 )
			mingw_gcc_check_or_create_directory_links

			local mingw_c_cxx_common_flags=(  )
			# mingw_c_cxx_common_flags+=( -mcmodel=medium )
			cflags+=(   "${mingw_c_cxx_common_flags[@]}" )
			cxxflags+=( "${mingw_c_cxx_common_flags[@]}" )
			if [ "${compiler_install_dir}" = "$(print_mingw_root_dir)" ]; then
				# pre-installed GCC 13.2.0 and Clang 17.0.6 at /ucrt64 or /mingw64 need this option
				ldflags+=( -Wl,--allow-multiple-definition )
			fi
			# https://learn.microsoft.com/en-us/cpp/c-runtime-library/link-options
			ldflags+=( -Wl,"$(cygpath -m "$(gcc -print-file-name=binmode.o)")" )
			# ldflags+=( -Wl,"$(cygpath -m "$(print_mingw_root_dir)")/lib/binmode.o" )
			;;
	esac

	export TOOLCHAIN="${toolchain}"
	export BUILD_TYPE="${build_type}"
	export CC="${cc}"
	export CXX="${cxx}"
	export CFLAGS="${cflags[*]}"
	export CXXFLAGS="${cxxflags[*]}"
	export LDFLAGS="${ldflags[*]}"
}

dump_toolchain_build_type_and_compiler_flags() {
	echo "TOOLCHAIN  : ${TOOLCHAIN}"
	echo "BUILD_TYPE : ${BUILD_TYPE}"
	echo "CC         : ${CC} $(print_compiler_version "${CC}") $(which "${CC}")"
	echo "CXX        : ${CXX} $(print_compiler_version "${CXX}") $(which "${CXX}")"
	echo "CFLAGS     : ${CFLAGS}"
	echo "CXXFLAGS   : ${CXXFLAGS}"
	echo "LDFLAGS    : ${LDFLAGS}"
}

# control llvm as a library, whether is static or shared
check_llvm_static_or_shared() {
	local llvm_static_or_shared="$1"
	if [ -z "${llvm_static_or_shared}" ]; then
		llvm_static_or_shared=static
	fi
	case "${llvm_static_or_shared}" in
		static | shared )
			true
			;;
		* )
			echo "unknown arg : ${llvm_static_or_shared}"
			echo "valid arg : static shared"
			exit 1
			;;
	esac
	export LLVM_STATIC_OR_SHARED="${llvm_static_or_shared}"
}

dump_llvm_static_or_shared() {
	echo "LLVM_STATIC_OR_SHARED : ${LLVM_STATIC_OR_SHARED}"
}

print_gcc_install_dir() {
	print_program_dir_upper_dir gcc
}

print_mingw_root_dir() {
	case "${MSYSTEM}" in
		MINGW64 )
			# msvcrt.dll
			echo "/mingw64"
			;;
		UCRT64 )
			# ucrtbase.dll
			echo "/ucrt64"
			;;
		* )
			echo "unknown MSYSTEM : ${MSYSTEM}"
			return 1
			;;
	esac
}

mingw_gcc_check_or_create_directory_links() {
	if quiet_command which gcc; then
		local gcc_install_dir="$(print_gcc_install_dir)"
		mingw_gcc_check_or_create_directory_links_0 /mingw \
		&& mingw_gcc_check_or_create_directory_links_0 "${gcc_install_dir}/mingw" \
		&& mingw_gcc_check_or_create_directory_links_1 "${gcc_install_dir}" "${HOST_TRIPLE}"
	fi
}

mingw_gcc_check_or_create_directory_links_1() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local gcc_install_dir="$1"
	local host_triple="$2"
	local sysroot="${gcc_install_dir}/${host_triple}"
	if [ "${gcc_install_dir}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ -e "${sysroot}"/include ] && [ -e "${sysroot}"/lib ] \
		&& [ "$(readlink -f "${sysroot}"/include)" = "$(readlink -f "${mingw_root_dir}"/include)" ] \
		&& [ "$(readlink -f "${sysroot}"/lib)" = "$(readlink -f "${mingw_root_dir}"/lib)" ] ; then
		# echo OK 1 "${sysroot}"
		return 0
	fi
	rm -rf "${sysroot}"/{include,lib} \
	&& mkdir -p "${sysroot}" \
	&& ln -s "${mingw_root_dir}"/include "${sysroot}"/include \
	&& ln -s "${mingw_root_dir}"/lib "${sysroot}"/lib
}

mingw_gcc_remove_directory_links_1() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local gcc_install_dir="$1"
	local host_triple="$2"
	local sysroot="${gcc_install_dir}/${host_triple}"
	if [ "${gcc_install_dir}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	echo_command rm -rf "${sysroot}"/{include,lib}
}

mingw_gcc_check_or_create_directory_links_0() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local sysroot="$1"
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	if [ -e "${sysroot}" ] && [ "$(readlink -f "${sysroot}")" = "$(readlink -f "${mingw_root_dir}")" ] ; then
		# echo OK 0 "${sysroot}"
		return 0
	fi
	rm -rf "${sysroot}" \
	&& mkdir -p "${sysroot}" \
	&& rm -rf "${sysroot}" \
	&& ln -s "${mingw_root_dir}" "${sysroot}"
}

mingw_gcc_remove_directory_links_0() {
	local mingw_root_dir="$(print_mingw_root_dir)"
	local sysroot="$1"
	if [ "${sysroot}" = "${mingw_root_dir}" ]; then
		return 0
	fi
	echo_command rm -rf "${sysroot}"
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
			echo "git@github.com:llvm/llvm-project.git"
			;;
		qemu )
			echo "https://gitlab.com/qemu-project/qemu.git"
			;;
		cmake )
			echo "https://gitlab.kitware.com/cmake/cmake.git"
			;;
		bash )
			echo "https://git.savannah.gnu.org/git/bash.git"
			;;
		make )
			echo "https://git.savannah.gnu.org/git/make.git"
			;;
		python )
			echo "https://github.com/python/cpython"
			;;
		perl )
			echo "https://github.com/Perl/perl5"
			;;
		tcl )
			echo "https://github.com/tcltk/tcl"
			;;
		tk )
			echo "https://github.com/tcltk/tk"
			;;
		openjdk )
			echo "https://github.com/openjdk/jdk"
			;;
		runtime )
			echo "https://github.com/dotnet/runtime"
			;;
		roslyn )
			echo "https://github.com/dotnet/roslyn"
			;;
		cygwin )
			echo "https://cygwin.com/git/newlib-cygwin.git"
			;;
		mingw )
			echo "https://git.code.sf.net/p/mingw-w64/mingw-w64"
			;;
		musl )
			echo "git://git.musl-libc.org/musl"
			;;
		glibc )
			echo "git://sourceware.org/git/glibc.git"
			;;
		linux )
			echo "git@github.com:torvalds/linux.git"
			;;
		* )
			echo "unknown package : ${package}"
			return 1
			;;
	esac
}

check_dir_maybe_clone_from_url() {
	local dir="$1"
	local git_repo_url="$2"

	if [ ! -d "${dir}" ]; then
		time_command git clone --origin upstream --no-checkout "${git_repo_url}" "${dir}"
	fi
}

print_host_os_of_triple() {
	local host_triple="$1"
	case "${host_triple}" in
		x86_64-pc-mingw64 )
			case "${MSYSTEM}" in
				MINGW64 )
					# msvcrt.dll
					echo "mingw-vcrt"
					;;
				UCRT64 )
					# ucrtbase.dll
					echo "mingw-ucrt"
					;;
				* )
					echo "unknown MSYSTEM : ${MSYSTEM}"
					return 1
					;;
			esac
			;;
		x86_64-pc-cygwin )
			# cygwin1.dll
			echo "cygwin"
			;;
		*-linux-gnu )
			echo "linux"
			;;
		* )
			echo "unknown host : ${host_triple}"
			return 1
			;;
	esac
}

maybe_make_tarball_and_move() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local tarball="$4"
	local install_dir="$5"

	if [ "${build_type}" != Release ]; then
		return 0
	fi

	local host_os="$(print_host_os_of_triple "${host_triple}")"
	local dest_dir="__${host_os}/${toolchain,,}"

	echo_command rm -rf "${tarball}"{,.sha512} \
	&& { echo_command pushd "${install_dir}" \
		&& time_command tar -cvf  "../${tarball}" * \
		&& echo_command popd;} \
	&& time_command sha512_calculate_file "${tarball}" \
	\
	&& echo_command mkdir -p "${dest_dir}" \
	&& time_command mv -f "${tarball}"{,.sha512} "${dest_dir}"
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
	print_array_elements "$@"

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
	print_array_elements "$@"

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
					# msvcrt.dll or ucrtbase.dll
					root_dirs+=( "$(print_mingw_root_dir)" "$(print_gcc_install_dir)" )
					;;
				x86_64-pc-cygwin )
					# cygwin1.dll
					root_dirs+=( /usr "$(print_gcc_install_dir)" )
					;;
				x86_64-pc-msys )
					# msys-2.0.dll
					root_dirs+=( /usr )
					;;
			esac
			for root_dir in "${root_dirs[@]}"; do
				bin_dirs+=( "${root_dir}/bin" )
			done
			# echo "bin_dirs :"
			# print_array_elements "${bin_dirs[@]}"
			local dest_dir="${install_dir}/${install_exe_dir}"
			echo_command mkdir -p "${dest_dir}" \
			&& echo_command cp $(ldd $(find "${dest_dir}" -name '*.exe' -o -name '*.dll') | awk '{print $3}' | grep -E "^($(join_array_elements '|' "${bin_dirs[@]}"))/" | sort | uniq) "${dest_dir}"
			;;
	esac
}

process_install_dir_bin_symlinks () {
	local install_dir="$1"
	pushd "${install_dir}" \
	&& for path in $(find bin); do
		if [ -L "${path}" ]; then
			path2="$(readlink -f "${path}")"
			if [ -f "${path2}" ]; then
				local base="$(basename "${path}")"
				local base2="$(basename "${path2}")"
				local suffix="${base2##*.}"

				local path1="${path}"
				if [ ! -z "${suffix}" ]; then
					if [[ "${base}" == *".${suffix}" ]]; then
						# echo "The file has the specified suffix."
						true
					else
						# echo "The file does not have the specified suffix."
						path1+=".${suffix}"
					fi
				fi
				if ! { rm -rf "${path}" && cp -f "${path2}" "${path1}" ;}; then
					echo "failed to process symlink ${path} pointing to ${path2}"
					return 1
				fi
			fi
		fi
	done \
	&& popd
}

build_and_install_gmp_mpfr_mpc() {
	local package="$1"
	local host_triple="$2"
	local toolchain="$3"
	local build_type="$4"
	local gmp_mpfr_mpc_install_dir="$5"

	local host_os="$(print_host_os_of_triple "${host_triple}")"

	local gmp_version=6.2.1
	local mpfr_version=4.1.0
	local mpc_version=1.2.1

	local gmp_tarball="gmp-${gmp_version}.tar.xz"
	local mpfr_tarball="mpfr-${mpfr_version}.tar.xz"
	local mpc_tarball="mpc-${mpc_version}.tar.gz"

	local gmp_extracted_dir="gmp-${gmp_version}"
	local mpfr_extracted_dir="mpfr-${mpfr_version}"
	local mpc_extracted_dir="mpc-${mpc_version}"

	local gmp_build_dir="gmp-${host_os}-${toolchain,,}-${build_type,,}-build"
	local mpfr_build_dir="mpfr-${host_os}-${toolchain,,}-${build_type,,}-build"
	local mpc_build_dir="mpc-${host_os}-${toolchain,,}-${build_type,,}-build"

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
			2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-gmp-output.txt" \
	&& time_command extract_configure_build_and_install_package mpfr "${mpfr_tarball}" "${mpfr_extracted_dir}" "${mpfr_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared --with-gmp="${install_prefix}" \
			2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-mpfr-output.txt" \
	&& time_command extract_configure_build_and_install_package mpc "${mpc_tarball}" "${mpc_extracted_dir}" "${mpc_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared --with-gmp="${install_prefix}" \
			2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-mpc-output.txt" \
	&& echo "completed"
}

# Linux API Headers
# https://www.linuxfromscratch.org/lfs/view/stable/chapter05/linux-headers.html
build_and_install_target_linux_headers() {
	local target="$1"
	local toolchain="$2"
	local build_type="$3"
	local host_triple="$4"
	local package="$5"
	local version="$6"

	local source_dir="${package}"
	local sysroot="$(pwd)/_sysroot/${target}"

	pushd "${source_dir}" \
	&& make mrproper \
	&& make headers \
	&& find usr/include -type f ! -name '*.h' -delete \
	&& cp -rv usr/include "${sysroot}"/usr \
	&& popd
}

# Glibc
# https://www.linuxfromscratch.org/lfs/view/stable/chapter05/glibc.html
build_and_install_target_glibc() {
	local target="$1"
	local toolchain="$2"
	local build_type="$3"
	local host_triple="$4"
	local package="$5"
	local version="$6"

	local source_dir="${package}"
	local build_dir="${source_dir}"-build
	local sysroot="$(pwd)/_sysroot/${target}"

	../configure \
		--prefix=/usr \
		--host="${target}" \
		--build="${host_triple}" \
		--enable-kernel=4.19 \
		--with-headers="${sysroot}"/usr/include \
		--disable-nscd \
		libc_cv_slibdir=/usr/lib

	make

	make DESTDIR="${sysroot}" install
}

# Libstdc++
# https://www.linuxfromscratch.org/lfs/view/stable/chapter05/gcc-libstdc++.html
build_and_install_target_libstdcxx() {
	local target="$1"
	local toolchain="$2"
	local build_type="$3"
	local host_triple="$4"
	local package="$5"
	local version="$6"

	local source_dir="${package}"
	local build_dir="${source_dir}"-build
	local sysroot="$(pwd)/_sysroot/${target}"

	../libstdc++-v3/configure \
		--host="${target}" \
		--build="${host_triple}" \
		--prefix=/usr \
		--disable-multilib \
		--disable-nls \
		--disable-libstdcxx-pch \
		--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/13.2.0

	make

	make DESTDIR="${sysroot}" install

	rm -v "${sysroot}"/usr/lib/lib{stdc++{,exp,fs},supc++}.la
}

build_and_install_binutils_gcc_for_target() {
	local target="$1"
	local toolchain="$2"
	local build_type="$3"
	local host_triple="$4"
	local package="$5"
	local version="$6"
	local extra_languages="$7"
	local is_build_and_install_gmp_mpfr_mpc="$8"
	local binutils_source_dir="${9}"
	local gcc_source_dir="${10}"
	local gmp_mpfr_mpc_install_dir="${11}"
	local current_datetime="${12}"

	local host_os="$(print_host_os_of_triple "${host_triple}")"
	local gcc_install_dir="${gcc_source_dir}-${host_os}-${toolchain,,}-${build_type,,}-${target}-install"
	local gcc_build_dir="${gcc_source_dir}-${host_os}-${toolchain,,}-${build_type,,}-${target}-build"
	local bin_tarball="${package}-${target}-${version}.tar"
	local binutils_build_dir="${binutils_source_dir}-${host_os}-${toolchain,,}-${build_type,,}-${target}-build"

	local install_prefix="$(pwd)/${gcc_install_dir}"

	local binutils_configure_options=(
			--target="${target}"
			--prefix="${install_prefix}"
			--disable-nls
			--disable-werror
			# https://sourceware.org/legacy-ml/binutils/2014-01/msg00341.html
			--disable-gdb --disable-gdbserver --disable-gdbsupport --disable-libdecnumber --disable-readline --disable-sim
	)

	# Installing GCC: Configuration
	# https://gcc.gnu.org/install/configure.html
	local gcc_configure_options=(
			# On Linux, ${host_triple} is not the same as the output of config.guess
			--build="${host_triple}"
			--host="${host_triple}"
			--target="${target}"
			--without-headers
			--disable-gcov
			--disable-shared
			--disable-threads
			--enable-multilib
	)

	if [ "${is_build_and_install_gmp_mpfr_mpc}" = yes ]; then
		gcc_configure_options+=(
			--with-{gmp,mpfr,mpc}="$(pwd)/${gmp_mpfr_mpc_install_dir}"
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
	&& echo_command export PATH="$(join_array_elements ':' "$(pwd)/${gcc_install_dir}/bin" "${PATH}" )" \
	\
	&& { time_command pushd_and_configure "${binutils_build_dir}" "${binutils_source_dir}" \
			"${binutils_configure_options[@]}" \
		&& time_command parallel_make \
		&& time_command parallel_make install \
		&& echo_command popd;} \
		2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-${target}-binutils-output.txt" \
	\
	\
	&& { time_command gcc_pushd_and_configure "${gcc_build_dir}" "${gcc_source_dir}" "${gcc_install_dir}" \
			"$(join_array_elements ',' "${languages[@]}" "${extra_languages}")" "${host_triple}" \
			"${gcc_configure_options[@]}" \
		&& time_command parallel_make all-gcc \
		&& time_command parallel_make all-target-libgcc \
		&& time_command parallel_make install-gcc \
		&& time_command parallel_make install-target-libgcc \
		&& echo_command popd;} \
		2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-${target}-gcc-output.txt" \
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
	local extra_languages="$7"
	local is_build_and_install_gmp_mpfr_mpc="$8"
	local current_datetime="$9"
	shift 9

	local targets=( "$@" )
	echo "targets :"
	print_array_elements "${targets[@]}"
	local target

	local host_os="$(print_host_os_of_triple "${host_triple}")"

	# gcc 13.1.0 and binutils 2.36 combined will fail to build RISC-V libgcc, because of unrecognized new instructions.

	# Note: bintuils 2.37 2.38 2.39 2.40 2.41 can't handle the following line in kernel link script
	#   .head           : { head.o (.multiboot) head.o (.*) }
	# it can't do relocation of 32 bit code in head.o, due to commit 17c6c3b99156fe82c1e637e1a5fd9f163ac788c8

	local gcc_git_repo_url="$(git_repo_url_of_package gcc)"
	local binutils_git_repo_url="$(git_repo_url_of_package binutils)"

	local gcc_source_dir="gcc"
	local binutils_source_dir="binutils"

	local gmp_mpfr_mpc_install_dir="gmp-mpfr-mpc-${host_os}-${toolchain,,}-${build_type,,}-install"

	if [ "${is_build_and_install_gmp_mpfr_mpc}" = yes ]; then
		time_command build_and_install_gmp_mpfr_mpc "${package}" "${host_triple}" "${toolchain}" "${build_type}" "${gmp_mpfr_mpc_install_dir}" \
		2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-gmp-mpfr-mpc-output.txt"
	fi \
	&& time_command check_dir_maybe_clone_from_url "${binutils_source_dir}" "${binutils_git_repo_url}" \
	&& time_command check_dir_maybe_clone_from_url "${gcc_source_dir}" "${gcc_git_repo_url}" \
	\
	&& echo "building binutils and gcc ......" \
	&& for target in "${targets[@]}"; do
			time_command build_and_install_binutils_gcc_for_target \
			"${target}" "${toolchain}" "${build_type}" "${host_triple}" "${package}" "${gcc_version}" "${extra_languages}" \
			"${is_build_and_install_gmp_mpfr_mpc}" "${binutils_source_dir}" "${gcc_source_dir}" \
			"${gmp_mpfr_mpc_install_dir}" "${current_datetime}" \
			2>&1 | tee "~${current_datetime}-${package}-${host_os}-${toolchain,,}-${build_type,,}-${target}-output.txt" &
	done \
	&& time_command wait \
	&& echo "completed" \
	&& time_command sync .
}

pre_generate_package_action() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = gcc ]; then
		echo_command mingw_gcc_check_or_create_directory_links_0 "$(pwd)/${install_dir}/mingw" \
		&& echo_command mingw_gcc_check_or_create_directory_links_1 "$(pwd)/${install_dir}" "${host_triple}"
	fi
}

post_build_package_action() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = gcc ]; then
		echo_command mingw_gcc_remove_directory_links_0 "$(pwd)/${install_dir}/mingw" \
		&& echo_command mingw_gcc_remove_directory_links_1 "$(pwd)/${install_dir}" "${host_triple}"
	fi
}

post_install_package_action() {
	local host_triple="$1"
	local package="$2"
	local source_dir="$3"
	local install_dir="$4"

	if [ "${host_triple}" = x86_64-pc-mingw64 ] && [ "${package}" = qemu ]; then
		echo_command copy_dependent_dlls "${host_triple}" "${install_dir}" "."
	elif [ "${host_triple}" = x86_64-pc-cygwin ] && [ "${package}" = llvm ]; then
		echo_command process_install_dir_bin_symlinks "${install_dir}"
	fi
}

generate_build_install_package() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local package="$4"
	local version="$5"
	local source_dir="$6"
	local install_dir="$7"
	local pushd_and_generate_command="$8"
	shift 8
	local bin_tarball="${package}-${version}.tar"
	local git_repo_url="$(git_repo_url_of_package "${package}")"

	# https://stackoverflow.com/questions/11307465/destdir-and-prefix-of-make

	time_command check_dir_maybe_clone_from_url "${source_dir}" "${git_repo_url}" \
	&& echo_command rm -rf "${install_dir}" \
	&& echo_command pre_generate_package_action "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
	&& { time_command "${pushd_and_generate_command}" "$@" \
		&& time_command parallel_make \
		&& echo_command pushd .. \
		&& echo_command post_build_package_action "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
		&& echo_command popd \
		&& time_command parallel_make install \
		&& echo_command popd;} \
	&& echo_command post_install_package_action "${host_triple}" "${package}" "${source_dir}" "${install_dir}" \
	&& time_command maybe_make_tarball_and_move "${toolchain}" "${build_type}" "${host_triple}" "${bin_tarball}" "${install_dir}" \
	&& time_command sync .
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
	local host_os="$(print_host_os_of_triple "${host_triple}")"
	local build_dir="${source_dir}-${host_os}-${toolchain,,}-${build_type,,}-build"
	local install_dir="${source_dir}-${host_os}-${toolchain,,}-${build_type,,}-install"

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
		"${toolchain}" "${build_type}" "${host_triple}" "${package}" "${version}" "${source_dir}" "${install_dir}" \
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
	local host_os="$(print_host_os_of_triple "${host_triple}")"
	local build_dir="${source_dir}-${host_os}-${toolchain,,}-${build_type,,}-build"
	local install_dir="${source_dir}-${host_os}-${toolchain,,}-${build_type,,}-install"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_configure_options=(
			--prefix="${install_prefix}"
	)

	time_command generate_build_install_package \
		"${toolchain}" "${build_type}" "${host_triple}" "${package}" "${version}" "${source_dir}" "${install_dir}" \
		pushd_and_configure "${build_dir}" "${source_dir}" "${generic_configure_options[@]}" "$@"
}

gcc_configure_build_install_package() {
	local toolchain="$1"
	local build_type="$2"
	local host_triple="$3"
	local package="$4"
	local version="$5"
	local extra_languages="$6"
	shift 6

	local source_dir="${package}"
	local host_os="$(print_host_os_of_triple "${host_triple}")"
	local build_dir="${source_dir}-${host_os}-${toolchain,,}-${build_type,,}-build"
	local install_dir="${source_dir}-${host_os}-${toolchain,,}-${build_type,,}-install"

	local languages=(
		# all
		c
		c++
	)

	time_command generate_build_install_package \
		"${toolchain}" "${build_type}" "${host_triple}" "${package}" "${version}" "${source_dir}" "${install_dir}" \
		gcc_pushd_and_configure "${build_dir}" "${source_dir}" "${install_dir}" \
		"$(join_array_elements ',' "${languages[@]}" "${extra_languages}")" "${host_triple}" "$@"
}
