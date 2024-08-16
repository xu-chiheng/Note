
https://cygwin.com/cgit/cygwin-packages/gcc

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-gcc

https://src.fedoraproject.org/rpms/gcc.git


13.0.0  8e08c7886eed5824bebd0e011526ec302d622844 2023-04-17
14.0.0  b8e9fd535d6093e3a24af858364d8517a767b0d7 2024-04-24
patch_apply . ../_patch/gcc/{cygwin-{ldflags,limits.h-0},mingw-{ldflags,gethostname,libgcc-inhibit_libc}}.patch

15.0.0  1b8b53ef75c143cddc114705c97c74d9c8f7a64b 2024-08-16
patch_apply . ../_patch/gcc/{cygwin-{ldflags,limits.h-1},mingw-{ldflags,gethostname,libgcc-inhibit_libc}}.patch


mingw-libgcc-inhibit_libc.patch
Fix build of cross gcc of target x86_64-pc-mingw64 with no libc.


cygwin-limits.h.patch
Fix build of cross gcc of target x86_64-pc-cygwin with no libc.



inhibit_libc
-Dinhibit_libc

# If this is a cross-compiler that does not
# have its own set of headers then define
# inhibit_libc

# If this is using newlib, without having the headers available now,
# then define inhibit_libc in LIBGCC2_CFLAGS.
# This prevents libgcc2 from containing any code which requires libc
# support.
: ${inhibit_libc=false}
if { { test x$host != x$target && test "x$with_sysroot" = x ; } ||
       test x$with_newlib = xyes ; } &&
     { test "x$with_headers" = xno || test ! -f "$target_header_dir/stdio.h"; } ; then
       inhibit_libc=true
fi
AC_SUBST(inhibit_libc)


all: libgcc.a
ifeq ($(enable_gcov),yes)
all: libgcov.a
endif

ifneq ($(LIBUNWIND),)
all: libunwind.a
endif

ifeq ($(enable_shared),yes)
all: libgcc_eh.a libgcc_s$(SHLIB_EXT)
ifneq ($(LIBUNWIND),)
all: libunwind$(SHLIB_EXT)
libgcc_s$(SHLIB_EXT): libunwind$(SHLIB_EXT)
endif


# Test to see whether <limits.h> exists in the system header files.
LIMITS_H_TEST = [ -f $(BUILD_SYSTEM_HEADER_DIR)/limits.h ]


	set -e; for ml in `cat fixinc_list`; do \
	  sysroot_headers_suffix=`echo $${ml} | sed -e 's/;.*$$//'`; \
	  multi_dir=`echo $${ml} | sed -e 's/^[^;]*;//'`; \
	  include_dir=include$${multi_dir}; \
	  if $(LIMITS_H_TEST) ; then \
	    cat $(srcdir)/limitx.h $(T_GLIMITS_H) $(srcdir)/limity.h > tmp-xlimits.h; \
	  else \
	    cat $(T_GLIMITS_H) > tmp-xlimits.h; \
	  fi; \
	  $(mkinstalldirs) $${include_dir}; \
	  chmod a+rx $${include_dir} || true; \
	  $(SHELL) $(srcdir)/../move-if-change \
	    tmp-xlimits.h  tmp-limits.h; \
	  rm -f $${include_dir}/limits.h; \
	  cp -p tmp-limits.h $${include_dir}/limits.h; \
	  chmod a+r $${include_dir}/limits.h; \
	  cp $(srcdir)/gsyslimits.h $${include_dir}/syslimits.h; \
	done


checking how to run the C preprocessor... /lib/cpp
configure: error: in `/e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-build/x86_64-pc-cygwin/libgcc':
configure: error: C preprocessor "/lib/cpp" fails sanity check
See `config.log' for more details
make: *** [Makefile:13888: configure-target-libgcc] Error 1


configure:4058: checking how to run the C preprocessor
configure:4089:  /e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-build/./gcc/xgcc -B/e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-build/./gcc/ -B/e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-install/x86_64-pc-cygwin/bin/ -B/e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-install/x86_64-pc-cygwin/lib/ -isystem /e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-install/x86_64-pc-cygwin/include -isystem /e/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-install/x86_64-pc-cygwin/sys-include    -E  conftest.c
In file included from E:/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-build/gcc/include/syslimits.h:7,
                 from E:/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-build/gcc/include/limits.h:34,
                 from conftest.c:10:
E:/Note/Tool/gcc-x86_64-pc-cygwin-mingw-ucrt-clang-release-build/gcc/include/limits.h:210:15: fatal error: limits.h: No such file or directory
  210 | #include_next <limits.h>                /* recurse down to the real one */
      |               ^~~~~~~~~~
compilation terminated.
configure:4089: $? = 1
configure: failed program was:
| /* confdefs.h */
| #define PACKAGE_NAME "GNU C Runtime Library"
| #define PACKAGE_TARNAME "libgcc"
| #define PACKAGE_VERSION "1.0"
| #define PACKAGE_STRING "GNU C Runtime Library 1.0"
| #define PACKAGE_BUGREPORT ""
| #define PACKAGE_URL "http://www.gnu.org/software/libgcc/"
| /* end confdefs.h.  */
| #ifdef __STDC__
| # include <limits.h>
| #else
| # include <assert.h>
| #endif
| 		     Syntax error

