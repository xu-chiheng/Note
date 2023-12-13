
cygwin-CGExprCXX.cpp.patch
Fix the regression caused by commit 67409911353323ca5edf2049ef0df54132fa1ca7, that, in Cygwin, Clang can't bootstrap.

cygwin-Attributes.cpp.patch
Fix the regression caused by commit 8629343a8b6c26f15f02de2fdd8db440eba71937, that, in Cygwin, Clang can't bootstrap.

cygwin-Address.h.patch
Fix the regression caused by commit e419e22ff6fdff97191d132555ded7811c3f5b05, that, in Cygwin, Clang can't bootstrap, using GCC 13.2.0 as stage 0 compiler.

cygwin-CGCall.h.patch
Reduced number of inline elements of CallArgList.
This fix bootstraping on Cygwin, using GCC 13.2.0 as stage 0 compiler.
It seems that the size of CallArgList can't exceed an unknown limit.  
As commit 49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09, this patch is not needed.

mingw-Value.h.patch
Fix the regression caused by commit 592e935e115ffb451eb9b782376711dab6558fe0, that, in MinGW, Clang can't be built by system Clang 15.0.4.
As commit 49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09, this patch is not needed.

mingw-dynamicbase.patch
Not needed for MinGW.
https://github.com/llvm/llvm-project/pull/74979
