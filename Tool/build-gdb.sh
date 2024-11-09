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


# Clang/LLVM 20 commit 2dec83cc8e21a72e8718b5b3f009a19d6634fad3 2024-08-15
# [clang] Turn -Wenum-constexpr-conversion into a hard error (#102364)
# this break build of GDB 14 15 16

# ../../gdb/gdb/../gdbsupport/enum-flags.h:96:5: error: non-type template argument is not a constant expression
#    96 |                                 static_cast<bool>(T (-1) < T (0))>::type;
#       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ../../gdb/gdb/../gdbsupport/enum-flags.h:132:36: note: in instantiation of template class 'enum_underlying_type<btrace_insn_flag>' requested here
#   132 |   using underlying_type = typename enum_underlying_type<enum_type>::type;
#       |                                    ^
# ../../gdb/gdb/btrace.h:96:21: note: in instantiation of template class 'enum_flags<btrace_insn_flag>' requested here
#    96 |   btrace_insn_flags flags;
#       |                     ^
# ../../gdb/gdb/../gdbsupport/enum-flags.h:96:23: note: integer value -1 is outside the valid range of values [0, 1] for the enumeration type 'btrace_insn_flag'
#    96 |                                 static_cast<bool>(T (-1) < T (0))>::type;
#       |                                                   ^
# ../../gdb/gdb/../gdbsupport/enum-flags.h:96:5: error: non-type template argument is not a constant expression
#    96 |                                 static_cast<bool>(T (-1) < T (0))>::type;
#       |                                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ../../gdb/gdb/../gdbsupport/enum-flags.h:132:36: note: in instantiation of template class 'enum_underlying_type<btrace_function_flag>' requested here
#   132 |   using underlying_type = typename enum_underlying_type<enum_type>::type;
#       |                                    ^
# ../../gdb/gdb/btrace.h:205:25: note: in instantiation of template class 'enum_flags<btrace_function_flag>' requested here
#   205 |   btrace_function_flags flags = 0;
#       |                         ^
# ../../gdb/gdb/../gdbsupport/enum-flags.h:96:23: note: integer value -1 is outside the valid range of values [0, 7] for the enumeration type 'btrace_function_flag'
#    96 |                                 static_cast<bool>(T (-1) < T (0))>::type;
#       |                                                   ^


cd "$(dirname "$0")"
. "./common.sh"

CURRENT_DATETIME="$(print_current_datetime)"
PACKAGE="gdb"
check_compiler_linker_build_type_and_set_compiler_flags "$1" "$2" "$3"
{
	dump_compiler_linker_build_type_and_compiler_flags

	CONFIGURE_OPTIONS=(
		--enable-targets=all
		--disable-nls
		--disable-werror

		--disable-binutils
		--disable-ld
		--disable-gold
		--disable-gas
		--disable-gprof
	)

	time_command configure_build_install_package \
		"${COMPILER}" "${LINKER}" "${BUILD_TYPE}" "${HOST_TRIPLE}" "${PACKAGE}" "${CONFIGURE_OPTIONS[@]}"

} 2>&1 | tee "$(print_name_for_config "~${CURRENT_DATETIME}-${PACKAGE}" "${HOST_TRIPLE}" "${COMPILER}" "${LINKER}" "${BUILD_TYPE}" output.txt)"

sync .
