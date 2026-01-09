
https://cygwin.com/cgit/cygwin-packages/gcc

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-gcc

https://src.fedoraproject.org/rpms/gcc.git


14.0.0    b8e9fd535d6093e3a24af858364d8517a767b0d7    2024-04-24    branch point
patch_apply . ../_patch/gcc/{_convert-path,_add_env_var_paths,_copy-headers-of-gcc,_PREFIX_INCLUDE_DIR,_FIXED_INCLUDE_DIR,\
cygming/cygming-{STMP_FIXINC-0,LIMITS_H_TEST-0,PICFLAG-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v}},\
cygwin/cygwin-{ldflags-{a,b},macro-{a,b,c,d},include-w32api,no-wrap-{a,b,c,d,e,f,g},no-manifest,no-host_shared,jit-{a,b}},\
mingw/mingw-{replace-w64-{a,b,c,d,g,h,i,j},no-manifest-0,gethostname,libgcc-no-libc,include-lib-{a,b,{c,d,e}-0},path-{a,b,c,d,e},compiler-{INCLUDE,LIB},glimits.h}}.patch

15.0.0    5d05d496b2b4a3d4674b2e5a46d3a355abf4055d    2025-04-17    branch point
patch_apply . ../_patch/gcc/{_convert-path,_add_env_var_paths,_copy-headers-of-gcc,_PREFIX_INCLUDE_DIR,_FIXED_INCLUDE_DIR,\
cygming/cygming-{STMP_FIXINC-1,LIMITS_H_TEST-1,PICFLAG-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v}},\
cygwin/cygwin-{ldflags-{a,b},macro-{a,b,c,d-1},include-w32api,no-wrap-{a-1,b-1,c,d,e-1,f,g},no-manifest,no-host_shared,jit-{a,b}},\
mingw/mingw-{replace-w64-{a,b,c,d,e,f,g,h,i,j},no-manifest-1,gethostname,libgcc-no-libc,include-lib-{a,b,{c,d,e}-1},path-{a,b,c,d,e},compiler-{INCLUDE,LIB},glimits.h}}.patch

16.0.0    fc8e2846c24bd62091b31cc35c143b990e79d557    2025-08-19
patch_apply . ../_patch/gcc/{_convert-path,_add_env_var_paths,_copy-headers-of-gcc,_PREFIX_INCLUDE_DIR,_FIXED_INCLUDE_DIR,\
cygming/cygming-{STMP_FIXINC-1,LIMITS_H_TEST-1,PICFLAG-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v}},\
cygwin/cygwin-{ldflags-{a,b},macro-{a,b,c,d-1},include-w32api,no-wrap-{a-1,b-1,c,d,e-1,f,g},no-manifest,no-host_shared,jit-{a,b}},\
mingw/mingw-{replace-w64-{a,b,c-1,d,e,f,g,h,i,j},no-manifest-1,gethostname,libgcc-no-libc,include-lib-{a,b,{c,d,e}-1},path-{a,b,c,d,e},compiler-{INCLUDE,LIB},glimits.h}}.patch

16.0.0    62c126db6b6017011dcbe6945aab371ab48f8ded    2025-12-12
16.0.0    72a376da3b780ace74e6f929f53af7b05e3ba627    2026-01-07
patch_apply . ../_patch/gcc/{_convert-path,_add_env_var_paths,_copy-headers-of-gcc,_PREFIX_INCLUDE_DIR,_FIXED_INCLUDE_DIR,\
cygming/cygming-{STMP_FIXINC-1,LIMITS_H_TEST-1,PICFLAG-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v}},\
cygwin/cygwin-{ldflags-{a,b},macro-{a,b,c,d-1},include-w32api,no-wrap-{a-1,b-1,c,d,e-1,f,g},no-manifest,no-host_shared,jit-{a,b}},\
mingw/mingw-{replace-w64-{a,b,c-1,d,f,g,h,i,j},no-manifest-1,gethostname,libgcc-no-libc,include-lib-{a,b,{c,d,e}-1},path-{a,b,c,d,e},compiler-{INCLUDE,LIB},glimits.h},\
regression/regression-a}.patch



_PREFIX_INCLUDE_DIR.patch
$prefix/include, on MinGW, $prefix is not converted from unix path to windows path,
but the macro PREFIX is. All other paths in the array cpp_include_defaults[] at gcc/cppdefault.cc are based on PREFIX,
so they are all windows path on MinGW.

_FIXED_INCLUDE_DIR.patch
Undefine FIXED_INCLUDE_DIR to not add "include-fixed" to include directories

_copy-headers-of-gcc.patch
Fix the build of Cygwin to MinGW cross compiler.
In file included from ../../../../gcc/gcc/tsystem.h:44,
                 from ../../../../gcc/libgcc/libgcc2.c:27:
/cygdrive/e/Note/Tool/gcc-cygwin-clang-bfd-release-x86_64-pc-mingw64-build/gcc/include/stddef.h:1:15: fatal error: stddef.h: No such file or directory
    1 | #include_next <stddef.h>
      |               ^~~~~~~~~~
compilation terminated.

USER_H_INC_NEXT_PRE = @user_headers_inc_next_pre@
USER_H_INC_NEXT_POST = @user_headers_inc_next_post@

	case ${target} in
		*-mingw64*)
			user_headers_inc_next_post="${user_headers_inc_next_post} float.h"
			user_headers_inc_next_pre="${user_headers_inc_next_pre} stddef.h stdarg.h"






mingw-replace-w64.patch
Search and repalce all "-w64-"

mingw-libgcc-no-libc.patch
Fix build of cross gcc of target x86_64-pc-mingw64 with no libc.

cygming-STMP_FIXINC.patch
No STMP_FIXINC for Cygwin and MinGW

cygming-LIMITS_H_TEST.patch
Fix build of cross gcc of target x86_64-pc-cygwin with no libc.

cygwin-include-w32api.patch
Unconditionally add /usr/include/w32api to include directories, to keep the same with Clang.

cygwin-no-host_shared.patch
Fix build on Cygwin.
configure: error:
Enabling language "jit" requires --enable-host-shared.

cygwin-jit-{a,b}.patch
Fix build on Cygwin.

mingw-include-lib-a.patch

mingw-include-lib-b.patch

mingw-include-lib-c.patch

mingw-include-lib-d.patch
Fix the error :
The directory (BUILD_SYSTEM_HEADER_DIR) that should contain system headers does not exist:
  /mingw/include

mingw-include-lib-e.patch

mingw-glimits.h.patch
  if [ -f `echo /usr/include | sed -e :a -e 's,[^/]*/\.\.\/,,' -e ta`/limits.h ] ; then \
    cat ../../gcc/gcc/limitx.h ../../gcc/gcc/glimits.h ../../gcc/gcc/limity.h > tmp-xlimits.h; \
  else \
    cat ../../gcc/gcc/glimits.h > tmp-xlimits.h; \
  fi; \






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







https://gcc.gnu.org/onlinedocs/gcc/Environment-Variables.html
https://stackoverflow.com/questions/20483619/lib-vs-libpath-environment-variables-difference-for-ms-visual-c-c

When using Microsoft Visual C++ (MSVC), the INCLUDE and LIB environment variables are used to specify search paths for header files and libraries: 
INCLUDE
Specifies the search path for the system #include header files. The INCLUDE variable should point to the \include subdirectory of your Visual Studio installation. 
LIB
Specifies the search path for libraries. The LIB variable can contain multiple path specifications, separated by semicolons. One path should point to the \lib subdirectory of your Visual C++ installation. 
Other environment variables that can be used with MSVC include: 
CL: Prepends options and arguments to the command-line arguments. 
_CL_: Appends options and arguments to the command-line arguments. 
LIBPATH: Specifies directories to search for metadata files referenced with #using. The linker will search the path specified by the /LIBPATH option before searching the path specified in the LIB environment variable. 
PATH: Used if the tool needs to run CVTRES and can't find the file in the same directory as link.exe. The PATH variable should point to the \bin subdirectory of your Visual C++ installation. 
TMP: Specifies a directory when linking OMF or .res files. 




Does the GCC compiler use environment variables like INCLUDE and LIB in MSVC to specify include and library directories?

The GCC compiler does have a similar mechanism for specifying include and library directories, but the names of the environment variables differ from those in MSVC. For GCC:

1. Include directories (equivalent to MSVC's INCLUDE):
	- `C_INCLUDE_PATH`: for C header files
	- `CPLUS_INCLUDE_PATH`: for C++ header files

2. Library directories (equivalent to MSVC's LIB):
	- `LIBRARY_PATH`: for specifying library file search paths

By using these environment variables, you can set GCC's default search paths. For example:

```bash
export C_INCLUDE_PATH=/path/to/include
export CPLUS_INCLUDE_PATH=/path/to/cpp/include
export LIBRARY_PATH=/path/to/lib
```

In addition to environment variables, GCC also provides command-line options to specify these paths:

- `-I<dir>`: Adds an include search path
- `-L<dir>`: Adds a library search path

These command-line options usually take precedence over environment variables.

It's important to note that while these environment variables work in GCC, they are not as commonly used as the INCLUDE and LIB variables in MSVC. In the GCC environment, it's more common to specify these paths directly in the compile command or manage them using a build system like Makefile.




Does the GCC compiler use environment variables like INCLUDE and LIB in MSVC to specify include and library directories?
No, the GCC (GNU Compiler Collection) compiler does not use environment variables named `INCLUDE` and `LIB` like Microsoft Visual C++ (MSVC) to specify include and library directories. Instead, GCC utilizes a different set of environment variables and command-line options to manage these directories.

**Environment Variables Used by GCC:**

1. **`CPATH`**: Specifies a list of directories that GCC should search for header files during compilation. The directories listed in `CPATH` are searched as if specified with the `-I` option, affecting both C and C++ compilers.

2. **`LIBRARY_PATH`**: Defines a list of directories for GCC to search for library files during linking. These directories are searched as if specified with the `-L` option.

3. **`C_INCLUDE_PATH`**: Specifies directories to be searched for C header files only. These directories are searched before those in `CPATH`.

4. **`CPLUS_INCLUDE_PATH`**: Similar to `C_INCLUDE_PATH`, but for C++ header files.

5. **`OBJC_INCLUDE_PATH`**: Specifies directories for Objective-C header files.

**Usage Example:**

To set these environment variables in a Unix-like shell:

```bash
export CPATH=/path/to/includes
export LIBRARY_PATH=/path/to/libs
```

**Command-Line Options:**

Alternatively, you can specify include and library directories directly in the GCC command line:

- **`-I`**: Adds a directory to the list of directories to be searched for header files.

	```bash
	gcc -I/path/to/includes myprogram.c -o myprogram
	```

- **`-L`**: Adds a directory to the list of directories to be searched for library files during linking.

	```bash
	gcc myprogram.o -L/path/to/libs -lmylib -o myprogram
	```

**Why GCC Doesn't Use `INCLUDE` and `LIB`:**

The environment variables `INCLUDE` and `LIB` are specific to MSVC and the Windows development environment. GCC was designed to be cross-platform and adheres to Unix-like conventions, which is why it uses different environment variables.

**Summary:**

- GCC uses `CPATH`, `LIBRARY_PATH`, `C_INCLUDE_PATH`, and `CPLUS_INCLUDE_PATH` to specify additional include and library directories.
- You can also use `-I` and `-L` command-line options to specify directories directly.
- `INCLUDE` and `LIB` are not recognized by GCC.

**References:**

- [GCC Environment Variables](https://gcc.gnu.org/onlinedocs/gcc/Environment-Variables.html)
- [Specifying Target Directories in GCC](https://gcc.gnu.org/onlinedocs/gcc/Directory-Options.html)



