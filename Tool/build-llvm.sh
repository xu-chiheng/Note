#!/usr/bin/env -S bash -i

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

# https://clang.llvm.org/get_started.html
# https://llvm.org/docs/CMake.html
# https://llvm.org/docs/GettingStarted.html

# https://llvm.org/docs/CMakePrimer.html
# https://llvm.org/docs/AdvancedBuilds.html
# https://llvm.org/docs/BuildingADistribution.html

# https://fuchsia.dev/fuchsia-src/development/build/toolchain

# 2016 LLVM Developers’ Meeting: C. Bieneman "Developing and Shipping LLVM and Clang with CMake"
# https://www.youtube.com/watch?v=StF77Cx7pz8

# 2017 LLVM Developers’ Meeting: Petr Hosek "Compiling cross-toolchains with CMake and runtimes build"
# https://www.youtube.com/watch?v=OCQGpUzXDsY

# 2023 LLVM Dev Mtg - Understanding the LLVM build
# https://www.youtube.com/watch?v=Dnubzx8-E1M

build() {
	local current_datetime="$(print_current_datetime)"
	local package="llvm"
	local compiler linker build_type cc cxx cflags cxxflags ldflags
	check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
	local llvm_lib_type
	check_llvm_lib_type "$4"
	{
		dump_compiler_linker_build_type_and_compiler_flags \
			"${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}"
		dump_llvm_lib_type "${llvm_lib_type}"

		local projects=(
			clang
			clang-tools-extra
			lld
			lldb
		)

		# runtime are not needed to build Cross Clang
		local runtimes=(
			# compiler-rt
			# libcxx
			# libcxxabi
			# libunwind
		)

		local targets=(
			all
			# host
		)

		local cmake_options=(
			"../${package}/llvm"

			-DLLVM_TARGETS_TO_BUILD="$(join_array_elements ';' "${targets[@]}")"
			-DLLVM_ENABLE_PROJECTS="$(join_array_elements ';' "${projects[@]}")"
			-DLLVM_ENABLE_RUNTIMES="$(join_array_elements ';' "${runtimes[@]}")"
			-DLLVM_BUILD_RUNTIME=ON

			-DLLVM_OPTIMIZED_TABLEGEN=ON
			-DLLVM_ENABLE_WERROR=OFF
			-DLLVM_ENABLE_ASSERTIONS=OFF
			-DLLVM_ENABLE_BACKTRACES=OFF
			-DLLVM_ENABLE_LIBXML2=ON
			-DLLVM_ENABLE_PLUGINS=OFF
			-DLLVM_ENABLE_MODULES=OFF

			-DLLVM_BUILD_TESTS=ON
			-DLLVM_INCLUDE_TESTS=ON
			-DLLVM_BUILD_BENCHMARKS=OFF
			-DLLVM_INCLUDE_BENCHMARKS=OFF
			-DLLVM_BUILD_EXAMPLES=OFF
			-DLLVM_INCLUDE_EXAMPLES=OFF
			-DLLVM_INCLUDE_DOCS=OFF

			-DCLANG_BUILD_TOOLS=ON
			-DCLANG_ENABLE_STATIC_ANALYZER=ON
			-DCLANG_INCLUDE_TESTS=ON
			-DCLANG_BUILD_EXAMPLES=OFF
			-DCLANG_INCLUDE_DOCS=OFF

			-DLLVM_USE_SYMLINKS=OFF
			-DLLVM_INSTALL_UTILS=ON

			-DLLVM_BUILD_LLVM_C_DYLIB=OFF

			# LLVM_BUILD_LLVM_DYLIB
			# LLVM_LINK_LLVM_DYLIB
			# LLVM_ENABLE_PIC
		)

		case "${llvm_lib_type}" in
			static )
				cmake_options+=(
					-DBUILD_SHARED_LIBS=OFF
				)
				;;
			shared )
				cmake_options+=(
					-DBUILD_SHARED_LIBS=ON
				)
				;;
			dylib )
				cmake_options+=(
					-DLLVM_BUILD_STATIC=OFF
					-DLLVM_BUILD_LLVM_DYLIB=ON
					-DLLVM_LINK_LLVM_DYLIB=ON
				)
				case "${HOST_TRIPLE}" in
					*-cygwin | *-mingw*)
						if [ "${compiler}" = GCC ]; then
							echo "On Cygwin/MinGW, GCC can't be used to build LLVM dylib"
							return 1

							# On Cygwin/MinGW, GCC does nothing on 
							# __attribute__((visibility("hidden"))) and __attribute__((visibility("default")))
							# [[gnu::visibility("hidden")]] and [[gnu::visibility("default")]]
							# llvm/include/llvm/Support/Compiler.h

							# /cygdrive/d/_cygwin/binutils/bin/ld.bfd: error: export ordinal too large: 85198
							# collect2: error: ld returned 1 exit status
							# /cygdrive/d/_cygwin/gcc/bin/g++.exe -march=x86-64 -O3 -fvisibility-inlines-hidden -Werror=date-time -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wno-missing-field-initializers -pedantic -Wno-long-long -Wimplicit-fallthrough -Wno-maybe-uninitialized -Wno-nonnull -Wno-class-memaccess -Wno-dangling-reference -Wno-redundant-move -Wno-pessimizing-move -Wno-array-bounds -Wno-stringop-overread -Wno-noexcept-type -Wdelete-non-virtual-dtor -Wsuggest-override -Wno-comment -Wno-misleading-indentation -Wctad-maybe-unsupported -O3 -DNDEBUG  -Wl,--gc-sections -Wl,--export-all-symbols -shared -Wl,--enable-auto-import -fuse-ld=bfd -Wl,--strip-all -o ../../bin/cygLLVM-22git.dll -Wl,--out-implib,../../lib/libLLVM-22git.dll.a -Wl,--major-image-version,0,--minor-image-version,0 CMakeFiles/LLVM.dir/libllvm.cpp.o  -Wl,--whole-archive 

							# cd E:/Note/Tool/llvm-mingw_ucrt-gcc-bfd-release-build/tools/llvm-shlib && D:/_mingw_ucrt/gcc/bin/g++.exe -march=x86-64 -O3 -fvisibility-inlines-hidden -Werror=date-time -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wno-missing-field-initializers -pedantic -Wno-long-long -Wimplicit-fallthrough -Wno-maybe-uninitialized -Wno-nonnull -Wno-class-memaccess -Wno-dangling-reference -Wno-redundant-move -Wno-pessimizing-move -Wno-array-bounds -Wno-stringop-overread -Wno-noexcept-type -Wdelete-non-virtual-dtor -Wsuggest-override -Wno-comment -Wno-misleading-indentation -Wctad-maybe-unsupported -O3 -DNDEBUG  -Wl,--gc-sections -Wl,--export-all-symbols -shared -fuse-ld=bfd -Wl,--strip-all -Wl,D:/msys64/ucrt64/lib/binmode.o -o ../../bin/libLLVM-22git.dll -Wl,--out-implib,../../lib/libLLVM-22git.dll.a -Wl,--major-image-version,0,--minor-image-version,0 -Wl,--whole-archive CMakeFiles/LLVM.dir/objects.a -Wl,--no-whole-archive @CMakeFiles/LLVM.dir/linkLibs.rsp
							# D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: error: export ordinal too large: 88861

						fi
					;;
				esac
				;;
		esac

		time_command cmake_build_install_package \
			"${package}" "${compiler}" "${linker}" "${build_type}" \
			"${cc}" "${cxx}" "${cflags}" "${cxxflags}" "${ldflags}" "${cmake_options[@]}"

	} 2>&1 | tee "$(print_name_for_config "~${current_datetime}-${package}" "${compiler}" "${linker}" "${build_type}" output.txt)"

	sync .
}

build "$@"
