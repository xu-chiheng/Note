
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

