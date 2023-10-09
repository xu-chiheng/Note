
https://cygwin.com/git-cygwin-packages/
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/cmake.git;a=summary
git://cygwin.com/git/cygwin-packages/cmake.git

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-cmake






patch_apply . ../_patch/gcc/{cygwin-tty.c,mingw-include}.patch














https://www.google.com/search?q=%23include_next+stdlib.h
https://www.google.com/search?q=includes_CXX.rsp
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=70129
https://gitlab.kitware.com/cmake/cmake/-/issues/16291
https://bugs.webkit.org/show_bug.cgi?id=161697
https://trac.webkit.org/changeset/205672/webkit/trunk/Source/cmake/OptionsCommon.cmake





cygpath -m /mingw64/include



The list of directories to remove is defined on the CMakes variables CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES and CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES.



# cat llvm-release-build/lib/Support/CMakeFiles/LLVMSupport.dir/includes_CXX.rsp
-I"C:/Users/Administrator/Tool/llvm-release-build/lib/Support" -IC:/Users/Administrator/Tool/llvm/llvm/lib/Support -I"C:/Users/Administrator/Tool/llvm-release-build/include" -IC:/Users/Administrator/Tool/llvm/llvm/include -isystem D:/msys64/mingw64/include



# (cd C:/Users/Administrator/Tool/llvm-release-build/lib/Support && print_compiler_include_dirs clang++ -DGTEST_HAS_RTTI=0 -D_FILE_OFFSET_BITS=64 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS @CMakeFiles/LLVMSupport.dir/includes_CXX.rsp -march=x86-64 -O3 -fvisibility-inlines-hidden -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wc++98-compat-extra-semi -Wimplicit-fallthrough -Wcovered-switch-default -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wsuggest-override -Wstring-conversion -Wmisleading-indentation -Wctad-maybe-unsupported -ffunction-sections -fdata-sections  -O3 -DNDEBUG -std=c++17  -fno-exceptions -funwind-tables -fno-rtti)
clang -cc1 version 18.0.0 based upon LLVM 18.0.0git default target x86_64-w64-windows-gnu
ignoring nonexistent directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/include/c++/x86_64-pc-mingw64"
ignoring nonexistent directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/include/c++/backward"
ignoring nonexistent directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/include/c++/14.0.0"
ignoring nonexistent directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/include/c++/14.0.0/x86_64-pc-mingw64"
ignoring nonexistent directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/include/c++/14.0.0/backward"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/c++"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/c++/x86_64-pc-mingw64"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/c++/backward"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14.0.0"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14.0.0/x86_64-pc-mingw64"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14.0.0/backward"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14.0"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14.0/x86_64-pc-mingw64"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14.0/backward"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14/x86_64-pc-mingw64"
ignoring nonexistent directory "D:/mingw64-packages/gcc/lib/gcc/x86_64-pc-mingw64/14.0.0/include/g++-v14/backward"
ignoring nonexistent directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/usr/include"
ignoring duplicate directory "D:/mingw64-packages/gcc/x86_64-pc-mingw64/include"
#include "..." search starts here:
#include <...> search starts here:
 C:/Users/Administrator/Tool/llvm-release-build/lib/Support
 C:/Users/Administrator/Tool/llvm/llvm/lib/Support
 C:/Users/Administrator/Tool/llvm-release-build/include
 C:/Users/Administrator/Tool/llvm/llvm/include
 D:/msys64/mingw64/include
 D:/mingw64-packages/gcc/x86_64-pc-mingw64/include/c++
 D:/mingw64-packages/gcc/include/c++/14.0.0
 D:/mingw64-packages/gcc/include/c++/14.0.0/x86_64-pc-mingw64
 D:/mingw64-packages/gcc/include/c++/14.0.0/backward
 D:/mingw64-packages/llvm/lib/clang/18/include
 D:/mingw64-packages/gcc/include
End of search list.
# 1 "<stdin>"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 453 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "<stdin>" 2





# (cd C:/Users/Administrator/Tool/llvm-release-build/lib/Support && D:/mingw64-packages/llvm/bin/clang++.exe -DGTEST_HAS_RTTI=0 -D_FILE_OFFSET_BITS=64 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS @CMakeFiles/LLVMSupport.dir/includes_CXX.rsp -march=x86-64 -O3 -fvisibility-inlines-hidden -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wc++98-compat-extra-semi -Wimplicit-fallthrough -Wcovered-switch-default -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wsuggest-override -Wstring-conversion -Wmisleading-indentation -Wctad-maybe-unsupported -ffunction-sections -fdata-sections  -O3 -DNDEBUG -std=c++17  -fno-exceptions -funwind-tables -fno-rtti -MD -MT lib/Support/CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.obj -MF CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.obj.d -o CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.obj -c C:/Users/Administrator/Tool/llvm/llvm/lib/Support/BinaryStreamReader.cpp)
In file included from C:/Users/Administrator/Tool/llvm/llvm/lib/Support/BinaryStreamReader.cpp:9:
In file included from C:/Users/Administrator/Tool/llvm/llvm/include/llvm/Support/BinaryStreamReader.h:12:
In file included from C:/Users/Administrator/Tool/llvm/llvm/include/llvm/ADT/ArrayRef.h:12:
In file included from C:/Users/Administrator/Tool/llvm/llvm/include/llvm/ADT/Hashing.h:51:
In file included from D:/mingw64-packages/gcc/include/c++/14.0.0/algorithm:61:
In file included from D:/mingw64-packages/gcc/include/c++/14.0.0/bits/stl_algo.h:71:
D:/mingw64-packages/gcc/include/c++/14.0.0/cstdlib:79:15: fatal error: 'stdlib.h' file not found
   79 | #include_next <stdlib.h>
      |               ^~~~~~~~~~
1 error generated.


cd C:/Users/Administrator/Tool/llvm-release-build/lib/Support && D:/mingw64-packages/llvm/bin/clang++.exe -DGTEST_HAS_RTTI=0 -D_FILE_OFFSET_BITS=64 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS @CMakeFiles/LLVMSupport.dir/includes_CXX.rsp -march=x86-64 -O3 -fvisibility-inlines-hidden -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wc++98-compat-extra-semi -Wimplicit-fallthrough -Wcovered-switch-default -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wsuggest-override -Wstring-conversion -Wmisleading-indentation -Wctad-maybe-unsupported -ffunction-sections -fdata-sections  -O3 -DNDEBUG -std=c++17  -fno-exceptions -funwind-tables -fno-rtti -MD -MT lib/Support/CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.obj -MF CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.obj.d -o CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.obj -c C:/Users/Administrator/Tool/llvm/llvm/lib/Support/BinaryStreamReader.cpp



