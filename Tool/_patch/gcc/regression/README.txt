

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

regression-b.patch
Fix build of GDB on MinGW, caused by commit 7ad39bc909d1b425d0fa1803dc53cd741c10150f 2025-12-18.
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: unittests/parallel-for-selftests.o:parallel-for-selftests.c:(.text+0x16b0): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: unittests/parallel-for-selftests.o:parallel-for-selftests.c:(.text+0x16c0): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: unittests/parallel-for-selftests.o:parallel-for-selftests.c:(.text+0x16e5): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: unittests/parallel-for-selftests.o:parallel-for-selftests.c:(.text+0x16f1): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: unittests/parallel-for-selftests.o:parallel-for-selftests.c:(.text.unlikely+0x1b1): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: unittests/parallel-for-selftests.o:parallel-for-selftests.c:(.text.unlikely+0x1bb): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x1ff): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x20f): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x22f): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x23b): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x7c9): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x7d9): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x800): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text+0x80c): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text.unlikely+0xc2): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text.unlikely+0xcc): undefined reference to `std::__get_once_call()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text.unlikely+0x10d): undefined reference to `std::__get_once_callable()'
D:\_mingw_ucrt\binutils\bin/ld.bfd.exe: ../gdbsupport/libgdbsupport.a(thread-pool.o):thread-pool.cc:(.text.unlikely+0x117): undefined reference to `std::__get_once_call()'
collect2.exe: error: ld returned 1 exit status
make[2]: *** [Makefile:2371: gdb.exe] Error 1
make[2]: Leaving directory '/e/Note/Tool/gdb-mingw_ucrt-gcc-bfd-release-build/gdb'
make[1]: *** [Makefile:11769: all-gdb] Error 2
make[1]: Leaving directory '/e/Note/Tool/gdb-mingw_ucrt-gcc-bfd-release-build'
make: *** [Makefile:1046: all] Error 2
