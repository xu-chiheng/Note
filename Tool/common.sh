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

check_compiler_linker_build_type_and_set_compiler_flags() {
	local _compiler="$1" _linker="$2" _build_type="$3"
	local _cc= _cxx= _cflags=() _cxxflags=() _ldflags=()

	if [ -z "${_compiler}" ]; then
		_compiler=Clang
	fi
	case "${_compiler}" in
		GCC | Clang )
			true
			;;
		* )
			echo "unknown compiler : ${_compiler}"
			echo "valid compiler : GCC Clang"
			exit 1
			;;
	esac

	if [ -z "${_linker}" ]; then
		_linker=BFD
	fi
	case "${_linker}" in
		BFD | LLD )
			true
			;;
		* )
			echo "unknown linker : ${_linker}"
			echo "valid linker : BFD LLD"
			exit 1
			;;
	esac

	if [ -z "${_build_type}" ]; then
		_build_type=Release
	fi
	case "${_build_type}" in
		Release | Debug )
			true
			;;
		* )
			echo "unknown build type : ${_build_type}"
			echo "valid build type : Release Debug"
			exit 1
			;;
	esac

	case "${_compiler}" in
		GCC )
			_cc=gcc
			_cxx=g++
			;;
		Clang )
			_cc=clang
			_cxx=clang++
			;;
	esac

	case "${_linker}" in
		BFD )
			_ldflags+=( -fuse-ld=bfd )
			;;
		LLD )
			# MinGW GCC/Clang can use this option
			_ldflags+=( -fuse-ld=lld )
			;;
	esac

	local _cc_dir="$(print_program_dir "${_cc}")"
	local _cxx_dir="$(print_program_dir "${_cxx}")"

	if [ "${_cc_dir}" != "${_cxx_dir}" ]; then
		echo "the dirs of C compiler ${_cc} at ${_cc_dir} and C++ compiler ${_cxx} at ${_cxx_dir} is not the same"
		exit 1
	fi
	if [ "$(basename "${_cc_dir}")" != bin ]; then
		echo "compiler is not in a bin directory"
		exit 1
	fi
	# local _compiler_install_dir="$(dirname "${_cc_dir}")"

	local _cpu_arch_flags=()
	case "${HOST_TRIPLE}" in
		x86_64-* )
			# https://www.phoronix.com/news/GCC-11-x86-64-Feature-Levels
			# x86-64: CMOV, CMPXCHG8B, FPU, FXSR, MMX, FXSR, SCE, SSE, SSE2
			# x86-64-v2: (close to Nehalem) CMPXCHG16B, LAHF-SAHF, POPCNT, SSE3, SSE4.1, SSE4.2, SSSE3
			# x86-64-v3: (close to Haswell) AVX, AVX2, BMI1, BMI2, F16C, FMA, LZCNT, MOVBE, XSAVE
			# x86-64-v4: AVX512F, AVX512BW, AVX512CD, AVX512DQ, AVX512VL

			# only GCC 11+ and Clang 12+ support this
			# local cpu_arch_flags=( -march=x86-64-v3 )
			_cpu_arch_flags+=( -march=x86-64 )
			;;
	esac
	_cflags+=(   "${_cpu_arch_flags[@]}" )
	_cxxflags+=( "${_cpu_arch_flags[@]}" )

	case "${_build_type}" in
		Release )
			local _release_c_cxx_common_flags=( -O3 )
			_cflags+=(   "${_release_c_cxx_common_flags[@]}" )
			_cxxflags+=( "${_release_c_cxx_common_flags[@]}" )
			_ldflags+=( -Wl,--strip-all )
			;;
		Debug )
			# https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
			# https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
			local _debug_c_cxx_common_flags=( -Og -g )
			_cflags+=(   "${_debug_c_cxx_common_flags[@]}" )
			_cxxflags+=( "${_debug_c_cxx_common_flags[@]}" )
			_ldflags+=()
			;;
	esac

	case "${HOST_TRIPLE}" in
		*-cygwin )
			# local _cygwin_c_cxx_common_flags=( )
			# # _cygwin_c_cxx_common_flags+=( -mcmodel=small )
			# _cflags+=(   "${_cygwin_c_cxx_common_flags[@]}" )
			# _cxxflags+=( "${_cygwin_c_cxx_common_flags[@]}" )
			if [ "${_compiler_install_dir}" = /usr ]; then
				# pre-installed GCC 11.4.0 and Clang 8.0.1 at /usr need this option
				_ldflags+=( -Wl,--dynamicbase )
			fi
			;;
		*-mingw* )
			# local _mingw_c_cxx_common_flags=( )
			# # _mingw_c_cxx_common_flags+=( -mcmodel=medium )
			# _cflags+=(   "${_mingw_c_cxx_common_flags[@]}" )
			# _cxxflags+=( "${_mingw_c_cxx_common_flags[@]}" )
			# https://learn.microsoft.com/en-us/cpp/c-runtime-library/link-options
			_ldflags+=( -Wl,"$(cygpath -m "$(gcc -print-file-name=binmode.o)")" )
			# _ldflags+=( -Wl,"$(cygpath -m "$(print_mingw_root_dir)")/lib/binmode.o" )
			;;
	esac

	# case "${compiler}" in
	# 	Clang )
	# 		local _clang_c_cxx_common_flags=( -Wno-unknown-warning-option -Wno-unknown-attributes -Qunused-arguments )
	# 		_cflags+=(   "${_clang_c_cxx_common_flags[@]}" )
	# 		_cxxflags+=( "${_clang_c_cxx_common_flags[@]}" )
	# 		;;
	# esac

	# printf -v is not affected by local; it always assigns to the variable in the current scope, and if the variable exists in the outer scope, it will directly modify the outer variable.
	printf -v compiler    '%s' "${_compiler}"
	printf -v linker      '%s' "${_linker}"
	printf -v build_type  '%s' "${_build_type}"
	printf -v cc          '%s' "${_cc}"
	printf -v cxx         '%s' "${_cxx}"
	printf -v cflags      '%s' "${_cflags[*]}"
	printf -v cxxflags    '%s' "${_cxxflags[*]}"
	printf -v ldflags     '%s' "${_ldflags[*]}"
}

dump_compiler_linker_build_type_and_compiler_flags() {
	local package="$1" compiler="$2" linker="$3" build_type="$4" cc="$5" cxx="$6" cflags="$7" cxxflags="$8" ldflags="$9"
	local host_os="$(print_host_os_of_host_triple)"
	echo "HOST_TRIPLE : ${HOST_TRIPLE}"
	echo "package     : ${package}"
	echo "host_os     : ${host_os}"
	echo "compiler    : ${compiler}"
	echo "linker      : ${linker}"
	echo "build_type  : ${build_type}"
	echo "cc          : ${cc} $(print_compiler_version "${cc}") $(print_command_path "${cc}")"
	echo "cxx         : ${cxx} $(print_compiler_version "${cxx}") $(print_command_path "${cxx}")"
	echo "cflags      : ${cflags}"
	echo "cxxflags    : ${cxxflags}"
	echo "ldflags     : ${ldflags}"
}

# control whether llvm, as library, is static or shared
check_llvm_static_or_shared() {
	local _llvm_static_or_shared="$1"

	if [ -z "${_llvm_static_or_shared}" ]; then
		_llvm_static_or_shared=shared
	fi
	case "${_llvm_static_or_shared}" in
		static | shared )
			true
			;;
		* )
			echo "unknown arg : ${_llvm_static_or_shared}"
			echo "valid arg : static shared"
			exit 1
			;;
	esac

	printf -v llvm_static_or_shared '%s' "${_llvm_static_or_shared}"
}

dump_llvm_static_or_shared() {
	echo "llvm_static_or_shared : $1"
}

visual_studio_check_tool_build_type_and_set_generator_toolset() {
	local _tool="$1" _build_type="$2"
	local _generator _toolset
	if [ -z "${_tool}" ]; then
		_tool=Clang
	fi
	case "${_tool}" in
		Clang | MSVC )
			true
			;;
		* )
			echo "unknown tool : ${_tool}"
			echo "valid tool : Clang MSVC"
			exit 1
			;;
	esac

	if [ -z "${_build_type}" ]; then
		_build_type=Release
	fi
	case "${_build_type}" in
		Release | Debug )
			true
			;;
		* )
			echo "unknown build type : ${_build_type}"
			echo "valid build type : Release Debug"
			exit 1
			;;
	esac

    local major="$(print_visual_studio_major_version)"
    local year="$(print_visual_studio_release_year)"
	_generator="Visual Studio ${major} ${year}"

	case "${_tool}" in
		Clang )
			_toolset="ClangCL"
			;;
		MSVC )
			_toolset="unknown"
			case "${year}" in
				2022) _toolset="v143" ;;
				2019) _toolset="v142" ;;
				2017) _toolset="v141" ;;
				2015) _toolset="v140" ;;
				2013) _toolset="v120" ;;
				2012) _toolset="v110" ;;
			esac
			;;
	esac

	printf -v tool       '%s' "${_tool}"
	printf -v build_type '%s' "${_build_type}"
	printf -v generator  '%s' "${_generator}"
	printf -v toolset    '%s' "${_toolset}"
}

visual_studio_dump_tool_build_type_and_generator_toolset() {
	local package="$1" tool="$2" build_type="$3" generator="$4" toolset="$5"
	local host_os="$(print_host_os_of_host_triple)"
	local compiler linker
	case "${tool}" in
		Clang ) compiler="clang-cl.exe" linker="lld-link.exe" ;;
		MSVC ) compiler="cl.exe" linker="link.exe" ;;
	esac
	local description="Unknown"
	case "${toolset}" in
		ClangCL ) description="Clang with MSVC-like command-line" ;;
		v143 ) description="Visual Studio 2022 (MSVC 14.3x)" ;;
		v142 ) description="Visual Studio 2019 (MSVC 14.2x)" ;;
		v141 ) description="Visual Studio 2017 (MSVC 14.1x)" ;;
		v140 ) description="Visual Studio 2015 (MSVC 14.0)" ;;
		v120 ) description="Visual Studio 2013 (MSVC 12.0)" ;;
		v110 ) description="Visual Studio 2012 (MSVC 11.0)" ;;
	esac
	
	echo "HOST_TRIPLE : ${HOST_TRIPLE}"
	echo "package     : ${package}"
	echo "host_os     : ${host_os}"
	echo "tool        : ${tool} (compiler : ${compiler}, linker : ${linker})"
	echo "build_type  : ${build_type}"
	echo "generator   : ${generator}"
	echo "toolset     : ${toolset} (${description})"
}

print_gcc_install_dir() {
	print_program_dir_upper_dir gcc
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
		meson )
			echo "git@github.com:mesonbuild/meson.git"
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
		mintty )
			echo "git@github.com:mintty/mintty.git"
			;;
		konsole )
			echo "git@github.com:KDE/konsole.git"
			;;
		gnome-terminal )
			echo "https://gitlab.gnome.org/GNOME/gnome-terminal"
			;;
		* )
			echo "unknown package : ${package}"
			return 1
			;;
	esac
}

check_dir_maybe_clone_from_url() {
	local package="$1"
	local git_repo_url="$(git_repo_url_of_package "${package}")"

	if [ ! -d "${package}" ]; then
		echo "the following command need to executed to download ${package} source to ${package} directory :"
		echo git clone "${git_repo_url}" "${package}"
		echo "patches in $(pwd)/_patch/${package} need to be applied manually to ${package}."
		exit
	fi
}

print_name_for_config() {
	local result=( "$1" )
	local compiler="$2" linker="$3" build_type="$4"
	shift 4

	local host_os="$(print_host_os_of_host_triple)"
	result+=( "${host_os,,}" "${compiler,,}" "${linker,,}" "${build_type,,}" "$@" )

	join_array_elements '-' "${result[@]}"
}

print_name_for_config_1() {
	local result=( "$1" )
	local tool="$2"
	shift 2

	local host_os="$(print_host_os_of_host_triple)"
	result+=( "${host_os,,}" "${tool,,}" "$@" )

	join_array_elements '-' "${result[@]}"
}

print_name_for_config_2() {
	local result=( "$1" )
	local tool="$2" build_type="$3"
	shift 3

	local host_os="$(print_host_os_of_host_triple)"
	result+=( "${host_os,,}" "${tool,,}" "${build_type,,}" "$@" )

	join_array_elements '-' "${result[@]}"
}

make_tarball_and_calculate_sha512() {
	local dest_dir="$1" tarball="$2" install_dir="$3"

	# # tar -cvf /cygdrive/e/Note/Tool/__vs2002/llvm.tar bin lib share  # at /cygdrive/e/Note/Tool/llvm-vs2022-build/Release started
	# tar.exe: Failed to open '/cygdrive/e/Note/Tool/__vs2002/llvm.tar'

	echo_command mkdir -p "${dest_dir}" \
	&& echo_command rm -rf "${dest_dir}/${tarball}"{,.sha512} \
	&& { echo_command pushd "${install_dir}" \
		&& echo_command rm -rf ../"${tarball}" \
		&& time_command tar -cvf ../"${tarball}" * \
		&& echo_command mv -f ../"${tarball}" "${dest_dir}/${tarball}" \
		&& echo_command popd;} \
	&& time_command sha512_calculate_file "${dest_dir}/${tarball}"
}

maybe_make_tarball_and_calculate_sha512() {
	local compiler="$1" linker="$2" build_type="$3" tarball="$4" install_dir="$5"

	if [ "${build_type}" != Release ]; then
		return 0
	fi

	local host_os="$(print_host_os_of_host_triple)"
	local dest_dir="$(pwd)/__${host_os,,}-${compiler,,}-${linker,,}"

	make_tarball_and_calculate_sha512 "${dest_dir}" "${tarball}" "${install_dir}"
}

maybe_make_tarball_and_calculate_sha512_1() {
	local tool="$1" build_type="$2" tarball="$3" install_dir="$4"

	if [ "${build_type}" != Release ]; then
		return 0
	fi

	local host_os="$(print_host_os_of_host_triple)"
	local dest_dir="$(pwd)/__${host_os,,}-${tool,,}"

	make_tarball_and_calculate_sha512 "${dest_dir}" "${tarball}" "${install_dir}"
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

pushd_and_cmake_1() {
	local build_dir="$1"
	shift 1

	echo "cmake options :"
	print_array_elements "$@"

	echo_command which cmake | grep -v '^$'
	echo_command cmake --version | grep -v '^$'

	echo_command rm -rf "${build_dir}" \
	&& echo_command mkdir "${build_dir}" \
	&& echo_command pushd "${build_dir}" \
	&& echo_command visual_studio_set_custom_llvm_location_and_version \
	&& time_command cmake "$@"
}

pushd_and_configure() {
	local package="$1" build_dir="$2"
	shift 2

	echo "configure options :"
	print_array_elements "$@"

	echo_command rm -rf "${build_dir}" \
	&& echo_command mkdir "${build_dir}" \
	&& echo_command pushd "${build_dir}" \
	&& time_command ../"${package}"/configure "$@"
}

extract_tarball() {
	local package="$1" tarball="$2" extracted_dir="$3"

	echo_command rm -rf "${extracted_dir}" "${package}" \
	&& time_command tar -xvf "${tarball}" \
	&& echo_command mv "${extracted_dir}" "${package}"
}

extract_configure_build_and_install_package() {
	local package="$1" tarball="$2" extracted_dir="$3" build_dir="$4" install_dir="$5"
	shift 5

	(
		# put in a subshell to prevent pollution in the global namespace
		echo_command export_environment_variables_for_build "${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}"

		time_command extract_tarball "${package}" "${tarball}" "${extracted_dir}" \
		&& { time_command pushd_and_configure "${package}" "${build_dir}" "$@" \
			&& time_command parallel_make \
			&& time_command parallel_make install \
			&& echo_command popd;}
	)
}

gcc_pushd_and_configure() {
	local package="$1" build_dir="$2" install_dir="$3" languages="$4"
	shift 4

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

	time_command pushd_and_configure "${package}" "${build_dir}" "${gcc_generic_configure_options[@]}" "$@"
}

copy_dependent_dlls_to_install_exe_dir() {
	local install_dir="$1" install_exe_dir="$2"
	local root_dirs=()
	local bin_dirs=()
	case "${HOST_TRIPLE}" in
		*-cygwin | *-mingw* | *-msys )
			case "${HOST_TRIPLE}" in
				*-mingw* )
					# msvcrt.dll or ucrtbase.dll
					root_dirs+=( "$(print_mingw_root_dir)" "$(print_gcc_install_dir)" )
					;;
				*-cygwin )
					# cygwin1.dll
					root_dirs+=( /usr "$(print_gcc_install_dir)" )
					;;
				*-msys )
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

build_and_install_gmp_mpfr_mpc() {
	local package="$1" compiler="$2" linker="$3" build_type="$4" gmp_mpfr_mpc_install_dir="$5"

	# GMP is a free library for arbitrary precision arithmetic, operating on signed integers, rational numbers, and floating-point numbers. 
	# https://gmplib.org
	local gmp_version=6.3.0
	# The MPFR library is a C library for multiple-precision floating-point computations with correct rounding. 
	# https://www.mpfr.org
	local mpfr_version=4.2.2
	# GNU MPC is a C library for the arithmetic of complex numbers with arbitrarily high precision and correct rounding of the result. 
	# https://www.multiprecision.org
	local mpc_version=1.3.1

	local gmp_tarball="gmp-${gmp_version}.tar.xz"
	local mpfr_tarball="mpfr-${mpfr_version}.tar.xz"
	local mpc_tarball="mpc-${mpc_version}.tar.gz"

	local gmp_extracted_dir="gmp-${gmp_version}"
	local mpfr_extracted_dir="mpfr-${mpfr_version}"
	local mpc_extracted_dir="mpc-${mpc_version}"

	local gmp_build_dir="$(print_name_for_config  gmp  "${compiler}" "${linker}" "${build_type}" build)"
	local mpfr_build_dir="$(print_name_for_config mpfr "${compiler}" "${linker}" "${build_type}" build)"
	local mpc_build_dir="$(print_name_for_config  mpc  "${compiler}" "${linker}" "${build_type}" build)"

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
			2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" gmp-output.txt)" \
	&& time_command extract_configure_build_and_install_package mpfr "${mpfr_tarball}" "${mpfr_extracted_dir}" "${mpfr_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared --with-gmp="${install_prefix}" \
			2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" mpfr-output.txt)" \
	&& time_command extract_configure_build_and_install_package mpc "${mpc_tarball}" "${mpc_extracted_dir}" "${mpc_build_dir}" "${gmp_mpfr_mpc_install_dir}" \
			--prefix="${install_prefix}" --disable-shared --with-gmp="${install_prefix}" \
			2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" mpc-output.txt)" \
	&& echo "completed"
}

# # Linux API Headers
# # https://www.linuxfromscratch.org/lfs/view/stable/chapter05/linux-headers.html

# # Glibc
# # https://www.linuxfromscratch.org/lfs/view/stable/chapter05/glibc.html

# # Libstdc++
# # https://www.linuxfromscratch.org/lfs/view/stable/chapter05/gcc-libstdc++.html

build_and_install_binutils_gcc_for_target() {
	local target="$1" package="$2" compiler="$3" linker="$4" build_type="$5"
	local cc="$6" cxx="$7" cflags="$8" cxxflags="$9" ldflags="${10}" extra_languages="${11}"
	local is_build_and_install_gmp_mpfr_mpc="${12}" gmp_mpfr_mpc_install_dir="${13}" current_datetime="${14}"

	local gcc_install_dir="$(print_name_for_config "gcc" "${compiler}" "${linker}" "${build_type}" "${target}-install")"
	local gcc_build_dir="$(print_name_for_config   "gcc" "${compiler}" "${linker}" "${build_type}" "${target}-build")"
	local tarball="${package}-${target}.tar"
	local binutils_build_dir="$(print_name_for_config "binutils" "${compiler}" "${linker}" "${build_type}" "${target}-build")"

	local install_prefix="$(pwd)/${gcc_install_dir}"

	local binutils_configure_options=(
			--target="${target}"
			--prefix="${install_prefix}"
			--disable-nls
			--disable-werror

			--disable-gdb
			--disable-gdbserver
			--disable-gdbsupport
			--disable-libdecnumber
			--disable-readline
			--disable-sim
	)

	# Installing GCC: Configuration
	# https://gcc.gnu.org/install/configure.html
	local gcc_configure_options=(
			# On Linux, ${HOST_TRIPLE} is not the same as the output of config.guess
			--build="${HOST_TRIPLE}"
			--host="${HOST_TRIPLE}"
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
	(
		# put in a subshell to prevent pollution in the global namespace
		echo_command export_environment_variables_for_build "${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}"

		# The $PREFIX/bin dir _must_ be in the PATH.
		local old_path="${PATH}"

		echo_command rm -rf "${gcc_install_dir}" \
		\
		&& echo_command export PATH="$(join_array_elements ':' "$(pwd)/${gcc_install_dir}/bin" "${PATH}" )" \
		\
		&& { time_command pushd_and_configure "binutils" "${binutils_build_dir}" "${binutils_configure_options[@]}" \
			&& time_command parallel_make \
			&& time_command parallel_make install \
			&& echo_command popd;} \
			2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" "${target}-binutils-output.txt")" \
		\
		&& [ "${PIPESTATUS[0]}" -eq 0 ] \
		\
		&& { time_command gcc_pushd_and_configure "gcc" "${gcc_build_dir}" "${gcc_install_dir}" \
				"$(join_array_elements ',' "${languages[@]}" "${extra_languages}")" "${gcc_configure_options[@]}" \
			&& time_command parallel_make all-gcc \
			&& time_command parallel_make all-target-libgcc \
			&& time_command parallel_make install-gcc \
			&& time_command parallel_make install-target-libgcc \
			&& echo_command popd;} \
			2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" "${target}-gcc-output.txt")" \
		\
		&& [ "${PIPESTATUS[0]}" -eq 0 ] \
		\
		&& time_command maybe_make_tarball_and_calculate_sha512 "${compiler}" "${linker}" "${build_type}" "${tarball}" "${gcc_install_dir}" \
		\
		&& echo_command export PATH="${old_path}"
	)
}

# https://wiki.osdev.org/GCC_Cross-Compiler
# https://gcc.gnu.org/install/configure.html
# https://gcc.gnu.org/install/specific.html
# https://github.com/richfelker/musl-cross-make

# https://wiki.osdev.org/Libgcc_without_red_zone

# https://wiki.gentoo.org/wiki/Crossdev
# https://wiki.gentoo.org/wiki/Cross_build_environment
# https://wiki.gentoo.org/wiki/Embedded_Handbook/General/Creating_a_cross-compiler
build_and_install_cross_gcc_for_targets() {
	local package="$1" compiler="$2" linker="$3" build_type="$4"
	local cc="$5" cxx="$6" cflags="$7" cxxflags="$8" ldflags="$9" extra_languages="${10}"
	local is_build_and_install_gmp_mpfr_mpc="${11}" current_datetime="${12}"
	shift 12

	local targets=( "$@" )
	echo "targets :"
	print_array_elements "${targets[@]}"
	local target

	local gmp_mpfr_mpc_install_dir="$(print_name_for_config gmp-mpfr-mpc "${compiler}" "${linker}" "${build_type}" install)"

	local pids=()
	local pid
	local all_success=yes

	if [ "${is_build_and_install_gmp_mpfr_mpc}" = yes ]; then
		time_command build_and_install_gmp_mpfr_mpc "${package}" "${compiler}" "${linker}" "${build_type}" "${gmp_mpfr_mpc_install_dir}" \
		2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" gmp-mpfr-mpc-output.txt)" \
		&& [ "${PIPESTATUS[0]}" -eq 0 ]
	fi \
	&& time_command check_dir_maybe_clone_from_url "binutils" \
	&& time_command check_dir_maybe_clone_from_url "gcc" \
	\
	&& echo "building binutils and gcc ......" \
	&& for target in "${targets[@]}"; do
		{
			time_command build_and_install_binutils_gcc_for_target \
			"${target}" "${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" "${extra_languages}" \
			"${is_build_and_install_gmp_mpfr_mpc}" "${gmp_mpfr_mpc_install_dir}" "${current_datetime}" \
			2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" "${target}-output.txt")" \
			&& [ "${PIPESTATUS[0]}" -eq 0 ]
		} & # run in background
		pids+=( $! )
	done \
	&& for pid in "${pids[@]}"; do
		wait "${pid}" || all_success=no
	done \
	&& [ "${all_success}" = yes ] \
	&& echo "completed" \
	&& time_command sync .
}

post_install_package_action() {
	local package="$1" install_dir="$2"

	if [ "${HOST_TRIPLE}" = x86_64-pc-mingw64 ] && [ "${package}" = qemu ]; then
		echo_command copy_dependent_dlls_to_install_exe_dir "${install_dir}" "."
	fi
}

export_environment_variables_for_build() {
	local cc="$1" cxx="$2" cflags="$3" cxxflags="$4" ldflags="$5"

	# Disable color errors globally?
	# http://clang-developers.42468.n3.nabble.com/Disable-color-errors-globally-td4065317.html
	export TERM=dumb
	# VERBOSE=1 make
	export VERBOSE=1
	CC="${cc}"
	CXX="${cxx}"
	CFLAGS="${cflags}"
	CXXFLAGS="${cxxflags}"
	LDFLAGS="${ldflags}"
	export CC CXX CFLAGS CXXFLAGS LDFLAGS

	echo "exported environment variables :"
	local temp_array=()
	for var in TERM VERBOSE CC CXX CFLAGS CXXFLAGS LDFLAGS; do
		temp_array+=( "$var='${!var}'" )
	done
	print_array_elements "${temp_array[@]}"
}

generate_build_install_package() {
	local package="$1" compiler="$2" linker="$3" build_type="$4"
	local cc="$5" cxx="$6" cflags="$7" cxxflags="$8" ldflags="$9"
	local install_dir="${10}" pushd_and_generate_command="${11}"
	shift 11
	local tarball="${package}.tar"

	# https://stackoverflow.com/questions/11307465/destdir-and-prefix-of-make

	(
		# put in a subshell to prevent pollution in the global namespace
		echo_command export_environment_variables_for_build "${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}"

		time_command check_dir_maybe_clone_from_url "${package}" \
		&& echo_command rm -rf "${install_dir}" \
		&& { time_command "${pushd_and_generate_command}" "$@" \
			&& time_command parallel_make \
			&& time_command parallel_make install \
			&& echo_command popd;} \
		&& echo_command post_install_package_action "${package}" "${install_dir}" \
		&& time_command maybe_make_tarball_and_calculate_sha512 "${compiler}" "${linker}" "${build_type}" "${tarball}" "${install_dir}" \
		&& time_command sync .
	)
}

get_build_dir_and_install_dir() {
	local package="$1" compiler="$2" linker="$3" build_type="$4"

	printf -v build_dir   '%s' "$(print_name_for_config "${package}" "${compiler}" "${linker}" "${build_type}" build)"
	printf -v install_dir '%s' "$(print_name_for_config "${package}" "${compiler}" "${linker}" "${build_type}" install)"
}

get_build_dir_and_install_dir_1() {
	local package="$1" tool="$2"

	# Note : Must keep "${build_dir}" as short as possible, to prevent the following errors when building LLVM :
    #    “E:\Note\Tool\llvm-visual_studio-clang-build\tools\lldb\source\Plugins\InstrumentationRuntime\MainThreadChecker\lldbPluginInstrumentationRuntimeMainThreadChecker.vcxproj”(默认目标) (2110) ->
    #    (InitializeBuildStatus 目标) ->
    #      C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Microsoft\VC\v170\Microsoft.CppBuild.targets(385,5): error MSB3491: 未能向文件“lldbPluginInstrumentationRuntimeMainThreadChecker.dir\Release\lldbPlug.81AF65F2.tlog\lldbPluginInstrumentationRuntimeMainThreadChecker.lastbuildstate”写入行。路径: lldbPluginInstrumentationRuntimeMainThreadChecker.dir\Release\lldbPlug.81AF65F2.tlog\lldbPluginInstrumentationRuntimeMainThreadChecker.lastbuildstate 超过 OS 最大路径限制。完全限定的文件名必须少于 260 个字符。  [E:\Note\Tool\llvm-visual_studio-clang-build\tools\lldb\source\Plugins\InstrumentationRuntime\MainThreadChecker\lldbPluginInstrumentationRuntimeMainThreadChecker.vcxproj]

    #    “E:\Note\Tool\llvm-visual_studio-clang-build\tools\lldb\source\Plugins\InstrumentationRuntime\ASanLibsanitizers\lldbPluginInstrumentationRuntimeASanLibsanitizers.vcxproj”(默认目标) (2163) ->
    #      C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Microsoft\VC\v170\Microsoft.CppBuild.targets(385,5): error MSB3491: 未能向文件“lldbPluginInstrumentationRuntimeASanLibsanitizers.dir\Release\lldbPlug.09DE11CF.tlog\lldbPluginInstrumentationRuntimeASanLibsanitizers.lastbuildstate”写入行。路径: lldbPluginInstrumentationRuntimeASanLibsanitizers.dir\Release\lldbPlug.09DE11CF.tlog\lldbPluginInstrumentationRuntimeASanLibsanitizers.lastbuildstate 超过 OS 最大路径限制。完全限定的文件名必须少于 260 个字符。  [E:\Note\Tool\llvm-visual_studio-clang-build\tools\lldb\source\Plugins\InstrumentationRuntime\ASanLibsanitizers\lldbPluginInstrumentationRuntimeASanLibsanitizers.vcxproj]

	printf -v build_dir   '%s' "$(print_name_for_config_1 "${package}" "${tool}" build)"
	printf -v install_dir '%s' "$(print_name_for_config_1 "${package}" "${tool}" install)"
}

cmake_build_install_package() {
	local package="$1" compiler="$2" linker="$3" build_type="$4"
	local cc="$5" cxx="$6" cflags="$7" cxxflags="$8" ldflags="$9"
	shift 9

	local build_dir install_dir
	get_build_dir_and_install_dir "${package}" "${compiler}" "${linker}" "${build_type}"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_cmake_options=(
			-G 'Unix Makefiles'
			-DCMAKE_BUILD_TYPE="${build_type}"
			-DCMAKE_INSTALL_PREFIX="${install_prefix}"

			-DCMAKE_C_COMPILER="${cc}"
			-DCMAKE_CXX_COMPILER="${cxx}"
			-DCMAKE_C_FLAGS="${cflags}"
			-DCMAKE_CXX_FLAGS="${cxxflags}"
			-DCMAKE_EXE_LINKER_FLAGS="${ldflags}"
			-DCMAKE_SHARED_LINKER_FLAGS="${ldflags}"
			-DCMAKE_MODULE_LINKER_FLAGS="${ldflags}"

			# CMAKE_EXE_LINKER_FLAGS: Linker flags used for all executable targets.
			# CMAKE_SHARED_LINKER_FLAGS: Linker flags used for all shared library targets (.so, .dll).
			# CMAKE_MODULE_LINKER_FLAGS: Linker flags used for all module library targets (usually dynamically loadable runtime libraries).
			# CMAKE_STATIC_LINKER_FLAGS: Flags for the static library (.a, .lib) “linker” (archiver). (Note: strictly speaking, creating a static library is archiving rather than linking, but sometimes specific flags are still applied.)
	)

	time_command generate_build_install_package \
		"${package}" "${compiler}" "${linker}" "${build_type}" \
		"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" \
		"${install_dir}" pushd_and_cmake "${build_dir}" "${generic_cmake_options[@]}" "$@"
}

cmake_build_install_package_1() {
	local package="$1" tool="$2" build_type="$3" generator="$4" toolset="$5" solution="$6"
	shift 6

	local build_dir install_dir
	get_build_dir_and_install_dir_1 "${package}" "${tool}"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_cmake_options=(
			-G "${generator}"
			-T "${toolset}"
			-DCMAKE_BUILD_TYPE="${build_type}"
			-DCMAKE_INSTALL_PREFIX="$(cygpath -m "${install_prefix}")"
	)
	local tarball="${package}.tar"

	# https://learn.microsoft.com/en-us/visualstudio/msbuild/msbuild-command-line-reference
	# https://learn.microsoft.com/en-us/visualstudio/msbuild/obtaining-build-logs-with-msbuild

	rm -rf "${install_dir}" \
	&& { time_command pushd_and_cmake_1 "${build_dir}" "${generic_cmake_options[@]}" "$@" \
	&& time_command msbuild.exe "${solution}" -maxCpuCount -interactive -property:"Configuration=${build_type}" -verbosity:normal \
	&& time_command cmake --build . --target INSTALL --config "${build_type}" \
	&& echo_command popd;} \
	&& time_command maybe_make_tarball_and_calculate_sha512_1 "${tool}" "${build_type}" "${tarball}" "${install_dir}"
}

configure_build_install_package() {
	local package="$1" compiler="$2" linker="$3" build_type="$4"
	local cc="$5" cxx="$6" cflags="$7" cxxflags="$8" ldflags="$9"
	shift 9

	local build_dir install_dir
	get_build_dir_and_install_dir "${package}" "${compiler}" "${linker}" "${build_type}"

	local install_prefix="$(pwd)/${install_dir}"

	local generic_configure_options=(
			--prefix="${install_prefix}"
	)

	time_command generate_build_install_package \
		"${package}" "${compiler}" "${linker}" "${build_type}" \
		"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" \
		"${install_dir}" pushd_and_configure "${package}" "${build_dir}" "${generic_configure_options[@]}" "$@"
}

gcc_configure_build_install_package() {
	local package="$1" compiler="$2" linker="$3" build_type="$4"
	local cc="$5" cxx="$6" cflags="$7" cxxflags="$8" ldflags="$9" extra_languages="${10}"
	shift 10

	local build_dir install_dir
	get_build_dir_and_install_dir "${package}" "${compiler}" "${linker}" "${build_type}"

	local languages=(
		# all
		c
		c++
	)

	time_command generate_build_install_package \
		"${package}" "${compiler}" "${linker}" "${build_type}" \
		"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" \
		"${install_dir}" gcc_pushd_and_configure "${package}" "${build_dir}" "${install_dir}" \
		"$(join_array_elements ',' "${languages[@]}" "${extra_languages}")" "$@"
}

# https://learn.microsoft.com/en-us/cpp/build/clang-support-msbuild?#custom_llvm_location
visual_studio_set_custom_llvm_location_and_version() {
	local llvm_install_dir="$(print_packages_dir_of_host_triple)/llvm"
	local llvm_install_dir_2="$(cygpath -w "${llvm_install_dir}")"
	local llvm_install_dir_clang_cl="${llvm_install_dir}/bin/clang-cl.exe"
	if [ ! -d "${llvm_install_dir}" ] || [ ! -f "${llvm_install_dir_clang_cl}" ]; then
		return
	fi

	local llvm_tools_version="$("${llvm_install_dir_clang_cl}" -v 2>&1 \
		| grep -oE "clang version [0-9]+\.[0-9]+\.[0-9]+" \
		| awk '{print $3}')"

	echo "LLVMInstallDir   : ${llvm_install_dir_2}"
	echo "LLVMToolsVersion : ${llvm_tools_version}"

	cat >Directory.build.props <<EOF
<Project>
  <PropertyGroup>
    <LLVMInstallDir>${llvm_install_dir_2}</LLVMInstallDir>
    <LLVMToolsVersion>${llvm_tools_version}</LLVMToolsVersion>
  </PropertyGroup>
</Project>
EOF

}

