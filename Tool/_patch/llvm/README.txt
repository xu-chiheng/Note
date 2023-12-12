
https://cygwin.com/git-cygwin-packages/
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/clang.git;a=summary
git://cygwin.com/git/cygwin-packages/clang.git
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/llvm.git;a=summary
git://cygwin.com/git/cygwin-packages/llvm.git

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-clang
https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-clang/PKGBUILD

https://src.fedoraproject.org/rpms/llvm.git


on Cygwin
stage 0 : GCC 13.2.0
stage 1 : Clang 16.0.6
stage 2 : Clang 16.0.6
stage 3 : Clang 16.0.6


16.0.6
patch_apply . ../_patch/llvm/old/{cygwin-{basic,cmodel,driver-16.0.6,general,macro},mingw-{pthread,emutls-16.0.6,dynamicbase,findgcc},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

17.0.0
patch_apply . ../_patch/llvm/old/{cygwin-{basic,cmodel,driver-16.0.6,general,macro,CGCall.h},mingw-{pthread,emutls,dynamicbase,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0      2023-10-05
patch_apply . ../_patch/llvm/old/{cygwin-{basic,cmodel,driver,general,macro,CGCall.h,X86ISelLowering.cpp},mingw-{pthread,emutls,dynamicbase,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0
patch_apply . ../_patch/llvm/{cygwin-{basic,cmodel,driver,general-{0,1,2},macro,CGCall.h,X86ISelLowering.cpp},mingw-{pthread,emutls,dynamicbase,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch


git add clang/lib/Driver/ToolChains/Cygwin.{cpp,h}

clang -v
git show -s



cygwin-general.patch
Remove some uses of macro __CYGWIN__ .
Fix build error by Clang due to the conflict of CIndexer.cpp and mm_malloc.h. In mm_malloc.h, _WIN32 and __CYGWIN__ can't both be defined, but CIndexer.cpp define both.
Override Cygwin's buggy getpagesize() to Win32 computePageSize().


cygwin-CGCall.h.patch
Reduced number of inline elements of CallArgList.
This fix bootstraping on Cygwin, using GCC 13.2.0 as stage 0 compiler.
It seems that the size of CallArgList can't exceed an unknown limit.  


cygwin-X86ISelLowering.cpp.patch
Fix the regression caused by commit c04a05d898982614a2df80d928b97ed4f8c49b60, that, in Cygwin, Clang can't bootstrap.


mingw-Value.h.patch
Fix the regression caused by commit 592e935e115ffb451eb9b782376711dab6558fe0, that, in MinGW, Clang can't be built by system Clang 15.0.4.





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





[  7%] Generating nonterminal symbol file for cxx grammar...
[  7%] Generating bnf string file for cxx grammar...
cd /cygdrive/e/Note/Tool/llvm-release-build/tools/clang/tools/extra/pseudo/include && ../../../../../../bin/clang-pseudo-gen.exe --grammar /cygdrive/e/Note/Tool/llvm/clang-tools-extra/pseudo/include/../lib/cxx/cxx.bnf --emit-symbol-list -o /cygdrive/e/Note/Tool/llvm-release-build/tools/clang/tools/extra/pseudo/include/CXXSymbols.inc
cd /cygdrive/e/Note/Tool/llvm-release-build/tools/clang/tools/extra/pseudo/include && ../../../../../../bin/clang-pseudo-gen.exe --grammar /cygdrive/e/Note/Tool/llvm/clang-tools-extra/pseudo/include/../lib/cxx/cxx.bnf --emit-grammar-content -o /cygdrive/e/Note/Tool/llvm-release-build/tools/clang/tools/extra/pseudo/include/CXXBNF.inc
make[2]: *** [tools/clang/tools/extra/pseudo/include/CMakeFiles/cxx_gen.dir/build.make:75: tools/clang/tools/extra/pseudo/include/CXXBNF.inc] Aborted
make[2]: *** Deleting file 'tools/clang/tools/extra/pseudo/include/CXXBNF.inc'
make[2]: *** Waiting for unfinished jobs....
make[2]: *** [tools/clang/tools/extra/pseudo/include/CMakeFiles/cxx_gen.dir/build.make:80: tools/clang/tools/extra/pseudo/include/CXXSymbols.inc] Aborted
make[2]: *** Deleting file 'tools/clang/tools/extra/pseudo/include/CXXSymbols.inc'
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make[1]: *** [CMakeFiles/Makefile2:46834: tools/clang/tools/extra/pseudo/include/CMakeFiles/cxx_gen.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
[  7%] Built target LLVMDebugInfoCodeView





commit 247fa04116a6cabf8378c6c72d90b2f705e969de, this line of change let './build-llvm.sh Clang "" shared' fail
diff --git a/clang/include/clang/Basic/TokenKinds.def b/clang/include/clang/Basic/TokenKinds.def
index f17a6028a137..ae67209d9b9e 100644
--- a/clang/include/clang/Basic/TokenKinds.def
+++ b/clang/include/clang/Basic/TokenKinds.def
@@ -942,6 +942,9 @@ ANNOTATION(module_end)
 // into the name of a header unit.
 ANNOTATION(header_unit)
 
+// Annotation for end of input in clang-repl.
+ANNOTATION(repl_input_end)
+
 #undef PRAGMA_ANNOTATION
 #undef ANNOTATION
 #undef TESTING_KEYWORD



commit b6259eca16f6c923d87a1ca1d424931e37d6871a, this line of change let './build-llvm.sh Clang "" shared' fail
diff --git a/clang/include/clang/Basic/TokenKinds.def b/clang/include/clang/Basic/TokenKinds.def
index 96feae991ccb..6d35f1bb31fc 100644
--- a/clang/include/clang/Basic/TokenKinds.def
+++ b/clang/include/clang/Basic/TokenKinds.def
@@ -523,6 +523,7 @@ TYPE_TRAIT_1(__is_unbounded_array, IsUnboundedArray, KEYCXX)
 TYPE_TRAIT_1(__is_nullptr, IsNullPointer, KEYCXX)
 TYPE_TRAIT_1(__is_scoped_enum, IsScopedEnum, KEYCXX)
 TYPE_TRAIT_1(__is_referenceable, IsReferenceable, KEYCXX)
+TYPE_TRAIT_1(__can_pass_in_regs, CanPassInRegs, KEYCXX)
 TYPE_TRAIT_2(__reference_binds_to_temporary, ReferenceBindsToTemporary, KEYCXX)
 
 // Embarcadero Expression Traits









case "${toolchain}" in
	Clang )
		local clang_c_cxx_flags=( -Wno-unknown-warning-option )
		cflags+=(   "${clang_c_cxx_flags[@]}" )
		cxxflags+=( "${clang_c_cxx_flags[@]}" )
		;;
esac


/cygdrive/e/Note/Tool/llvm/clang/lib/Basic/Attributes.cpp:57:5: warning: this style of line directive is a GNU extension [-Wgnu-line-marker]
   57 | # 1 "/cygdrive/e/Note/Tool/llvm-release-build/tools/clang/include/clang/Basic/AttrSubMatchRulesList.inc" 1
      |     ^

-mcmodel=medium
-Wno-unsafe-buffer-usage
local cygwin_clang_c_cxx_flags=( -Wno-gnu-line-marker )
cflags+=(   "${cygwin_clang_c_cxx_flags[@]}" )
cxxflags+=( "${cygwin_clang_c_cxx_flags[@]}" )

/usr/bin/ld: ../../../../lib/libLLVMSupport.a(Parallel.cpp.o):Parallel.cpp:(.text+0x130): multiple definition of `TLS wrapper function for llvm::parallel::threadIndex'; ../../../../lib/liblldELF.a(Relocations.cpp.o):Relocations.cpp:(.text+0xf3c0): first defined here
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
[100%] Built target clang-scan-deps
clang-8: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [tools/lld/tools/lld/CMakeFiles/lld.dir/build.make:273: bin/lld.exe] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make[1]: *** [CMakeFiles/Makefile2:56980: tools/lld/tools/lld/CMakeFiles/lld.dir/all] Error 2
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make: *** [Makefile:156: all] Error 2

ldflags+=(  -Wl,--allow-multiple-definition )



https://cygwin.fandom.com/wiki/Rebaseall
https://community.bmc.com/s/news/aA33n000000CiC6CAK/cygwin-rebase-utility-for-bsa
https://pipeline.lbl.gov/code/3rd_party/licenses.win/Cygwin/rebase-3.0.README
https://cygwin.com/git/gitweb.cgi?p=cygwin-apps/rebase.git;f=README;hb=HEAD

      0 [main] clang-17 1506 child_info_fork::abort: \??\D:\cygwin64-packages\clang\bin\cygclangLex-17git.dll: Loaded to different address: parent(0x16E0000) != child(0x5C12D0000)
clang++: error: unable to execute command: posix_spawn failed: Resource temporarily unavailable
      0 [main] clang-17 1507 child_info_fork::abort: \??\D:\cygwin64-packages\clang\bin\cygLLVMRISCVCodeGen-17git.dll: Loaded to different address: parent(0xE60000) != child(0xEC0000)
clang++: error: unable to execute command: posix_spawn failed: Resource temporarily unavailable

ldflags+=( -Wl,--dynamicbase )



https://learn.microsoft.com/en-us/cpp/c-runtime-library/link-options
binmode.obj	pbinmode.obj	Sets the default file-translation mode to binary. See _fmode.

MinGW-w64 runtime has regression in binmode.o, which defaulted to text mode,
will cause Cross GCC to corrupt libgcc's .o and .a files

E:\Note\Tool\gcc-x86_64-elf-release-install\x86_64-elf\bin\ar.exe: libgcov.a: error reading _gcov_merge_add.o: file truncated
make[1]: *** [Makefile:939: libgcov.a] Error 1
make[1]: *** Waiting for unfinished jobs....
make[1]: Leaving directory '/c/Users/Administrator/Tool/gcc-x86_64-elf-release-build/x86_64-elf/libgcc'
make: *** [Makefile:13696: all-target-libgcc] Error 2

ldflags+=( -Wl,"$(cygpath -m "$(gcc -print-file-name=binmode.o)")" )

