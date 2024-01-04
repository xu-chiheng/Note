
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


16.0.0    b0daacf58f417634f7c7c9496589d723592a8f5a 2023-01-24
patch_apply . ../_patch/llvm/old/{cygwin-{basic,cmodel,driver-16.0.6,general,macro},mingw-{pthread,emutls-16.0.6,findgcc},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

17.0.0    d0b54bb50e5110a004b41fc06dadf3fee70834b7 2023-07-25
patch_apply . ../_patch/llvm/old/{cygwin-{basic,cmodel,driver-16.0.6,general,macro,CGCall.h},mingw-{pthread,emutls,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    6f44f87011cd52367626cac111ddbb2d25784b90 2023-10-05
patch_apply . ../_patch/llvm/old/{cygwin-{basic,cmodel,driver,general,macro,CGCall.h,X86ISelLowering.cpp},mingw-{pthread,emutls,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch
patch_apply . ../_patch/llvm/{cygwin-{basic,cmodel,driver{,1},general{0,1,2},macro,CGCall.h,X86ISelLowering.cpp},mingw-{pthread,emutls,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09
patch_apply . ../_patch/llvm/{cygwin-{basic,cmodel,driver,general{0,1,2},macro,CGCall.h,X86ISelLowering.cpp},mingw-{pthread,emutls,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    f49e2b05bf3ececa2fe20c5d658ab92ab974dc36 2023-12-17
patch_apply . ../_patch/llvm/{cygwin-{basic,cmodel,driver,general{0,1,2},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp},mingw-{pthread,emutls,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    90c397fc56b7a04dd53cdad8103de1ead9686104 2024-01-01
patch_apply . ../_patch/llvm/{cygwin-{basic,cmodel,driver,general{0,1,2},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp{,2}},mingw-{pthread,emutls,findgcc,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

git add clang/lib/Driver/ToolChains/Cygwin.{cpp,h}

clang -v
git show -s


https://github.com/llvm/llvm-project/pulls/xu-chiheng

cygwin-general.patch
Remove some uses of macro __CYGWIN__ .
Fix build error by Clang due to the conflict of CIndexer.cpp and mm_malloc.h. In mm_malloc.h, _WIN32 and __CYGWIN__ can't both be defined, but CIndexer.cpp define both.
Override Cygwin's buggy getpagesize() to Win32 computePageSize().


cygwin-CGCall.h.patch
Reduced number of inline elements of CallArgList.
This fix bootstraping on Cygwin, using GCC 13.2.0 as stage 0 compiler.
It seems that the size of CallArgList can't exceed an unknown limit.  
As commit 49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09, this patch is not needed.


cygwin-X86ISelLowering.cpp.patch
Fix the regression caused by commit c04a05d898982614a2df80d928b97ed4f8c49b60 2023-08-14, that, in Cygwin, Clang can't bootstrap.


cygwin-X86ISelDAGToDAG.cpp.patch
Fix the regression caused by commit ec92d74a0ef89b9dd46aee6ec8aca6bfd3c66a54 2023-12-14, that, in Cygwin, Clang can't build binutils 2.42.
configure:4686: checking whether we are cross compiling
configure:4694: clang -o conftest.exe -march=x86-64 -O3  -Wl,--strip-all conftest.c  >&5
/cygdrive/c/Users/ADMINI~1/AppData/Local/Temp/conftest-385c4a.o:conftest.c:(.text+0x10): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
/cygdrive/c/Users/ADMINI~1/AppData/Local/Temp/conftest-385c4a.o:conftest.c:(.text+0x15): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
clang: error: linker command failed with exit code 1 (use -v to see invocation)
configure:4698: $? = 1
configure:4705: ./conftest.exe
../binutils/configure: line 4707: ./conftest.exe: No such file or directory
configure:4709: $? = 127
configure:4716: error: in `/cygdrive/e/Note/Tool/binutils-release-build':
configure:4718: error: cannot run C compiled programs.
If you meant to cross compile, use `--host'.
See `config.log' for more details

cygwin-X86ISelDAGToDAG.cpp2.patch
Fix the regression caused by commit 2366d53d8d8726b73408597b534d2f910c3d3e6d 2023-12-22, that, in Cygwin, Clang can't bootstrap.
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0xb9b): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0xba2): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x126c): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x1273): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x1377): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x137e): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x1f32): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x1f39): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x2b76): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x2b7d): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `.rdata'
CMakeFiles/LLVMDemangle.dir/ItaniumDemangle.cpp.o:ItaniumDemangle.cpp:(.text+0x399e): additional relocation overflows omitted from the output
clang++: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [lib/Demangle/CMakeFiles/LLVMDemangle.dir/build.make:177: bin/cygLLVMDemangle-18git.dll] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make[1]: *** [CMakeFiles/Makefile2:10800: lib/Demangle/CMakeFiles/LLVMDemangle.dir/all] Error 2
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
[  3%] Built target obj.LLVMTableGenCommon
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
[  3%] Built target obj.LLVMCFIVerify
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make: *** [Makefile:156: all] Error 2



mingw-pthread.patch
https://github.com/llvm/llvm-project/pull/74981


mingw-emutls.patch
https://github.com/llvm/llvm-project/pull/74980


mingw-Value.h.patch
Fix the regression caused by commit 592e935e115ffb451eb9b782376711dab6558fe0 2023-05-26, that, in MinGW, Clang can't be built by system Clang.



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

