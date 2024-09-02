

mingw-include.patch
Attemp to fix MinGW GCC's include problem. But patched GCC is too slow.

# print_compiler_include_dirs g++
ignoring nonexistent directory "D:/_mingw-ucrt/gcc/x86_64-pc-mingw64/include"
ignoring duplicate directory "D:/_mingw-ucrt/gcc/include/c++/15.0.0"
ignoring duplicate directory "D:/_mingw-ucrt/gcc/include/c++/15.0.0/x86_64-pc-mingw64"
ignoring duplicate directory "D:/_mingw-ucrt/gcc/include/c++/15.0.0/backward"
ignoring duplicate directory "D:/_mingw-ucrt/gcc/lib/gcc/x86_64-pc-mingw64/15.0.0/include"
ignoring duplicate directory "D:/_mingw-ucrt/gcc/lib/gcc/x86_64-pc-mingw64/15.0.0/include-fixed"
ignoring nonexistent directory "D:/_mingw-ucrt/gcc/x86_64-pc-mingw64/include"
#include "..." search starts here:
#include <...> search starts here:
 D:/_mingw-ucrt/gcc/include/c++/15.0.0
 D:/_mingw-ucrt/gcc/include/c++/15.0.0/x86_64-pc-mingw64
 D:/_mingw-ucrt/gcc/include/c++/15.0.0/backward
 D:/_mingw-ucrt/gcc/lib/gcc/x86_64-pc-mingw64/15.0.0/include
 D:/_mingw-ucrt/gcc/include
 D:/_mingw-ucrt/gcc/lib/gcc/x86_64-pc-mingw64/15.0.0/include-fixed
 D:/msys64/ucrt64/include
End of search list.
# 0 "<stdin>"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "<stdin>"
