

on Cygwin
stage 0 : GCC 13.2.0
stage 1 : Clang 16.0.6
stage 2 : Clang 16.0.6
stage 3 : Clang 16.0.6


16.0.6
patch_apply . ../patch/llvm/{cygwin-{basic,cmodel,driver-16.0.6,general},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

17.0.0
patch_apply . ../patch/llvm/{cygwin-{basic,cmodel,driver-16.0.6,general,CGCall.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0
patch_apply . ../patch/llvm/{cygwin-{basic,cmodel,driver,general,CGCall.h,X86ISelLowering.cpp},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

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
It seems that the size of CallArgList can't be larger than an unknown limit.  


cygwin-X86ISelLowering.cpp.patch
Fix the regression caused by commit c04a05d898982614a2df80d928b97ed4f8c49b60, that, in Cygwin, Clang can't bootstrap.




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




commit 28b5f3087a3fcd39c80e2b1470a950da17e4cd08
Author: Sander de Smalen <sander.desmalen@arm.com>
Date:   Tue May 23 16:42:56 2023 +0100

    [Clang][AArch64] Add/implement ACLE keywords for SME.

    This patch adds all the language-level function keywords defined in:

      https://github.com/ARM-software/acle/pull/188 (merged)
      https://github.com/ARM-software/acle/pull/261 (update after D148700 landed)

    The keywords are used to control PSTATE.ZA and PSTATE.SM, which are
    respectively used for enabling the use of the ZA matrix array and Streaming
    mode. This information needs to be available on call sites, since the use
    of ZA or streaming mode may have to be enabled or disabled around the
    call-site (depending on the IR attributes set on the caller and the
    callee). For calls to functions from a function pointer, there is no IR
    declaration available, so the IR attributes must be added explicitly to the
    call-site.

    With the exception of '__arm_locally_streaming' and '__arm_new_za' the
    information is part of the function's interface, not just the function
    definition, and thus needs to be propagated through the
    FunctionProtoType::ExtProtoInfo.

    This patch adds the defintions of these keywords, as well as codegen and
    semantic analysis to ensure conversions between function pointers are valid
    and that no conflicting keywords are set. For example, '__arm_streaming'
    and '__arm_streaming_compatible' are mutually exclusive.

    Differential Revision: https://reviews.llvm.org/D127762


commit 247fa04116a6cabf8378c6c72d90b2f705e969de
Author: Jun Zhang <jun@junz.org>
Date:   Tue May 16 20:10:43 2023 +0800

    [clang] Add a new annotation token: annot_repl_input_end

    This patch is the first part of the below RFC:
    https://discourse.llvm.org/t/rfc-handle-execution-results-in-clang-repl/68493

    It adds an annotation token which will replace the original EOF token
    when we are in the incremental C++ mode. In addition, when we're
    parsing an ExprStmt and there's a missing semicolon after the
    expression, we set a marker in the annotation token and continue
    parsing.

    Eventually, we propogate this info in ParseTopLevelStmtDecl and are able
    to mark this Decl as something we want to do value printing. Below is a
    example:

    clang-repl> int x = 42;
    clang-repl> x
    // `x` is a TopLevelStmtDecl and without a semicolon, we should set
    // it's IsSemiMissing bit so we can do something interesting in
    // ASTConsumer::HandleTopLevelDecl.

    The idea about annotation toke is proposed by Richard Smith, thanks!

    Signed-off-by: Jun Zhang <jun@junz.org>

    Differential Revision: https://reviews.llvm.org/D148997




commit b6259eca16f6c923d87a1ca1d424931e37d6871a
Author: Roy Jacobson <roi.jacobson1@gmail.com>
Date:   Mon Feb 13 19:14:22 2023 +0200

    [Clang] Export CanPassInRegisters as a type trait

    While working on D140664, I thought it would be nice to be able to write tests
    for parameter passing ABI. Currently we test this by dumping the AST and
    matching the results which makes it hard to write new tests.
    Adding this builtin will allow writing better ABI tests which
    can help improve our coverage in this area.

    While less useful, maybe some users would also find it useful for asserting
    against pessimisations for their classes.

    Reviewed By: erichkeane

    Differential Revision: https://reviews.llvm.org/D141775


commit 67409911353323ca5edf2049ef0df54132fa1ca7
Author: Jacob Young <jacobly0@users.noreply.github.com>
Date:   Tue Feb 28 16:42:32 2023 -0800

    [Clang][CodeGen] Fix this argument type for certain destructors

    With the Microsoft ABI, some destructors need to offset a parameter to
    get the derived this pointer, in which case the type of that parameter
    should not be a pointer to the derived type.

    Fixes #60465
https://github.com/llvm/llvm-project/issues/60465


commit acc3cc69e4d1c8e199fde51798a5a2a6edb35796
Author: Rashmi Mudduluru <r_mudduluru@apple.com>
Date:   Tue Jan 31 11:43:34 2023 -0800

    [-Wunsafe-buffer-usage] Introduce the unsafe_buffer_usage attribute

    Differential Revision: https://reviews.llvm.org/D138940

commit 7e04c0ad632527df0a4c4d34a6ac6ec6a3888dfe (HEAD -> test1557663)
Author: Xiang Li <python3kgae@outlook.com>
Date:   Wed Oct 19 12:40:39 2022 -0700

    [HLSL] Add groupshare address space.

    Added keyword, LangAS and TypeAttrbute for groupshared.

    Tanslate it to LangAS with asHLSLLangAS.

    Make sure it translated into address space 3 for DirectX target.

    Reviewed By: aaron.ballman

    Differential Revision: https://reviews.llvm.org/D135060





https://cygwin.com/git-cygwin-packages/
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/clang.git;a=summary
git://cygwin.com/git/cygwin-packages/clang.git
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/llvm.git;a=summary
git://cygwin.com/git/cygwin-packages/llvm.git

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-clang
https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-clang/PKGBUILD

https://src.fedoraproject.org/rpms/llvm.git









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

