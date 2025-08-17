
cygwin-macro.patch
Cygwin : Remove some macros not defined in GCC

cygwin-general-a.patch
Fix build error by Clang due to the conflict of CIndexer.cpp and mm_malloc.h. In mm_malloc.h, _WIN32 and __CYGWIN__ can't both be defined, but CIndexer.cpp define both.
In file included from /cygdrive/e/Note/Tool/llvm/clang/tools/libclang/CIndexer.cpp:35:
In file included from /usr/include/w32api/windows.h:69:
In file included from /usr/include/w32api/windef.h:9:
In file included from /usr/include/w32api/minwindef.h:163:
In file included from /usr/include/w32api/winnt.h:1658:
In file included from /cygdrive/d/cygwin64-packages/llvm/lib/clang/18/include/x86intrin.h:15:
In file included from /cygdrive/d/cygwin64-packages/llvm/lib/clang/18/include/immintrin.h:26:
In file included from /cygdrive/d/cygwin64-packages/llvm/lib/clang/18/include/xmmintrin.h:31:
/cygdrive/d/cygwin64-packages/llvm/lib/clang/18/include/mm_malloc.h:45:22: error: use of undeclared identifier '_aligned_malloc'; did you mean 'aligned_alloc'?
   45 |   __mallocedMemory = _aligned_malloc(__size, __align);
      |                      ^
/usr/include/stdlib.h:332:8: note: 'aligned_alloc' declared here
  332 | void *  aligned_alloc(size_t, size_t) __malloc_like __alloc_align(1)
      |         ^
[ 97%] Built target clangTidyModernizeModule


cygwin-general-b.patch
Remove some uses of macro __CYGWIN__ .


cygwin-general-c.patch
Override Cygwin's buggy getpagesize() to Win32 computePageSize().

