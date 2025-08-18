
cygwin-lldb-o.patch
lldb/include/lldb/lldb-types.h defined type addr_t
/usr/include/machine/types.h also defined type addr_t if macro __addr_t_defined is not defined 
cd /cygdrive/e/Note/Tool/llvm-release-build/tools/clang/lib/Sema && /cygdrive/d/cygwin-packages/llvm/bin/clang++.exe -DGTEST_HAS_RTTI=0 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -I/cygdrive/e/Note/Tool/llvm-release-build/tools/clang/lib/Sema -I/cygdrive/e/Note/Tool/llvm/clang/lib/Sema -I/cygdrive/e/Note/Tool/llvm/clang/include -I/cygdrive/e/Note/Tool/llvm-release-build/tools/clang/include -I/cygdrive/e/Note/Tool/llvm-release-build/include -I/cygdrive/e/Note/Tool/llvm/llvm/include -march=x86-64 -O3 -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wc++98-compat-extra-semi -Wimplicit-fallthrough -Wcovered-switch-default -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wsuggest-override -Wstring-conversion -Wmisleading-indentation -Wctad-maybe-unsupported -fno-common -Woverloaded-virtual -Wno-nested-anon-types -O3 -DNDEBUG -std=gnu++17  -fno-exceptions -funwind-tables -fno-rtti -MD -MT tools/clang/lib/Sema/CMakeFiles/obj.clangSema.dir/SemaCUDA.cpp.o -MF CMakeFiles/obj.clangSema.dir/SemaCUDA.cpp.o.d -o CMakeFiles/obj.clangSema.dir/SemaCUDA.cpp.o -c /cygdrive/e/Note/Tool/llvm/clang/lib/Sema/SemaCUDA.cpp
/cygdrive/e/Note/Tool/llvm/lldb/source/Utility/AddressableBits.cpp:41:5: error: reference to 'addr_t' is ambiguous
   41 |     addr_t low_addr_mask = ~((1ULL << m_low_memory_addr_bits) - 1);
      |     ^
/usr/include/machine/types.h:63:15: note: candidate found by name lookup is 'addr_t'
   63 | typedef char *addr_t;
      |               ^
/cygdrive/e/Note/Tool/llvm/lldb/include/lldb/lldb-types.h:79:18: note: candidate found by name lookup is 'lldb::addr_t'
   79 | typedef uint64_t addr_t;
      |                  ^
/cygdrive/e/Note/Tool/llvm/lldb/source/Utility/AddressableBits.cpp:42:32: error: use of undeclared identifier 'low_addr_mask'
   42 |     process.SetCodeAddressMask(low_addr_mask);
      |                                ^
/cygdrive/e/Note/Tool/llvm/lldb/source/Utility/AddressableBits.cpp:43:32: error: use of undeclared identifier 'low_addr_mask'
   43 |     process.SetDataAddressMask(low_addr_mask);
      |                                ^
/cygdrive/e/Note/Tool/llvm/lldb/source/Utility/AddressableBits.cpp:47:5: error: reference to 'addr_t' is ambiguous
   47 |     addr_t hi_addr_mask = ~((1ULL << m_high_memory_addr_bits) - 1);
      |     ^
/usr/include/machine/types.h:63:15: note: candidate found by name lookup is 'addr_t'
   63 | typedef char *addr_t;
      |               ^
/cygdrive/e/Note/Tool/llvm/lldb/include/lldb/lldb-types.h:79:18: note: candidate found by name lookup is 'lldb::addr_t'
   79 | typedef uint64_t addr_t;
      |                  ^
/cygdrive/e/Note/Tool/llvm/lldb/source/Utility/AddressableBits.cpp:48:39: error: use of undeclared identifier 'hi_addr_mask'
   48 |     process.SetHighmemCodeAddressMask(hi_addr_mask);
