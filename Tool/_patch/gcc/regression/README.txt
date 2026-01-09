

regression-a.patch
Fix build on Cygwin, caused by commit 62c126db6b6017011dcbe6945aab371ab48f8ded 2025-12-12.
/cygdrive/d/_cygwin/binutils/bin/ld: ../src/c++20/.libs/libc++20convenience.a(format.o): in function `std::bad_alloc::~bad_alloc()':
/cygdrive/e/Note/Tool/gcc-cygwin-gcc-bfd-release-build/x86_64-pc-cygwin/libstdc++-v3/include/bits/new_except.h:65: multiple definition of `std::bad_alloc::~bad_alloc()'; ../libsupc++/.libs/libsupc++convenience.a(bad_alloc.o):/cygdrive/e/Note/Tool/gcc-cygwin-gcc-bfd-release-build/x86_64-pc-cygwin/libstdc++-v3/libsupc++/../../../../gcc/libstdc++-v3/libsupc++/bad_alloc.cc:28: first defined here
/cygdrive/d/_cygwin/binutils/bin/ld: ../src/c++20/.libs/libc++20convenience.a(format.o): in function `std::bad_alloc::what() const':
/cygdrive/e/Note/Tool/gcc-cygwin-gcc-bfd-release-build/x86_64-pc-cygwin/libstdc++-v3/include/bits/new_except.h:70: multiple definition of `std::bad_alloc::what() const'; ../libsupc++/.libs/libsupc++convenience.a(bad_alloc.o):/cygdrive/e/Note/Tool/gcc-cygwin-gcc-bfd-release-build/x86_64-pc-cygwin/libstdc++-v3/libsupc++/../../../../gcc/libstdc++-v3/libsupc++/bad_alloc.cc:34: first defined here
/cygdrive/d/_cygwin/binutils/bin/ld: ../src/c++20/.libs/libc++20convenience.a(format.o): in function `std::bad_alloc::~bad_alloc()':
/cygdrive/e/Note/Tool/gcc-cygwin-gcc-bfd-release-build/x86_64-pc-cygwin/libstdc++-v3/include/bits/new_except.h:65: multiple definition of `std::bad_alloc::~bad_alloc()'; ../libsupc++/.libs/libsupc++convenience.a(bad_alloc.o):/cygdrive/e/Note/Tool/gcc-cygwin-gcc-bfd-release-build/x86_64-pc-cygwin/libstdc++-v3/libsupc++/../../../../gcc/libstdc++-v3/libsupc++/bad_alloc.cc:28: first defined here
collect2: error: ld returned 1 exit status
make[5]: *** [Makefile:767: libstdc++.la] Error 1
