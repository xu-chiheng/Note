
regression-a.patch
Fix the regression caused by commit 592e935e115ffb451eb9b782376711dab6558fe0 2023-05-28, that, on MinGW, Clang can't be built by system Clang.

regression-b-0.patch
regression-b.patch
Fix the regression caused by commit a0c1b5bdda91920a66f58b0a891c551acff2d2a1 2023-12-31, that,  the kernel built by Clang can't run the tests successfully.
assert fail .../tree_map.cpp _tree_map_empty_addr_next_node 157
		if (n_addr == &(p->left)) {
			next = p;
		} else {
			ASSERT(n_addr == &(p->right));
			next = (tree_map_node_impl *)(p->next);
		}
	}
regression-c.patch
Fix the regression caused by commit a0dd90eb7dc318c9b3fccb9ba02e1e22fb073094 2024-09-06, that build fails on Cygwin.

regression-d.patch
Fix the regression caused by commit 59f8796aaabc1ce400a8698431d3c6bfab4ad1a4 2024-09-07, that build fails on Cygwin.

regression-e.patch
Fix the regression caused by commit c2750807ba2a419425ee90dadda09ad5121517fe 2024-10-13, that build fails on Cygwin.

regression-f.patch
Fix the regression caused by commit d4efc3e097f40afbe8ae275150f49bb08fc04572 2024-10-15, that build fails on Cygwin.

regression-g.patch
Fix the regression caused by commit d80b9cf713fd1698641c5b265de6b66618991476 2024-10-21, that build fails on Cygwin.

regression-h.patch
Fix the regression caused by commit eb76d8332e932dfda133fe95331e6910805a27c5 2025-06-11, that build fails on Cygwin.
win-clang-bfd-release-build/include/lldb/lldb-defines.h 21 0 0
Traceback (most recent call last):
  File "/cygdrive/e/Note/Tool/llvm/lldb/scripts/version-header-fix.py", line 61, in <module>
    main()
  File "/cygdrive/e/Note/Tool/llvm/lldb/scripts/version-header-fix.py", line 35, in main
    with open(output_path, "w") as output_file:
         ^^^^^^^^^^^^^^^^^^^^^^
FileNotFoundError: [Errno 2] No such file or directory: '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build/include/lldb/lldb-defines.h'
make[2]: *** [tools/lldb/source/API/CMakeFiles/liblldb.dir/build.make:1789: bin/cyglldb.dll] Error 1
make[2]: *** Deleting file 'bin/cyglldb.dll'
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build'
make[1]: *** [CMakeFiles/Makefile2:124902: tools/lldb/source/API/CMakeFiles/liblldb.dir/all] Error 2
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build'
make: *** [Makefile:156: all] Error 2

regression-i.patch
Fix the regression caused by commit 2723a6d9928c7ba5d27125e03dff8eaba8661d7f 2025-07-02, that build fails on Cygwin.
/usr/bin/ld.bfd: cannot export _ZN4lldb: symbol not defined
/usr/bin/ld.bfd: cannot export _ZNK4lldb: symbol not defined
/usr/bin/ld.bfd: cannot export init_lld: symbol not defined
clang++: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [tools/lldb/source/API/CMakeFiles/liblldb.dir/build.make:1789: bin/cyglldb.dll] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build'
make[1]: *** [CMakeFiles/Makefile2:126422: tools/lldb/source/API/CMakeFiles/liblldb.dir/all] Error 2
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build'
make: *** [Makefile:156: all] Error 2

regression-j.patch
Fix the regression caused by commit d2ad63a193216d008c8161879a59c5f42e0125cc 2025-07-12, that build fails on Cygwin.
-lm /usr/lib/libz.dll.a /usr/lib/libzstd.dll.a ../libLLVMDemangle.dll.a
/usr/bin/ld.bfd: BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_dispatch.c.o:blake3_dispatch.c:(.text+0x435): undefined reference to `llvm_blake3_xof_many_avx512'
clang++: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [lib/Support/CMakeFiles/LLVMSupport.dir/build.make:2660: bin/cygLLVMSupport.dll] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build'
make[1]: *** [CMakeFiles/Makefile2:21532: lib/Support/CMakeFiles/LLVMSupport.dir/all] Error 2
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-bfd-release-build'
make: *** [Makefile:156: all] Error 2

regression-k.patch
Fix the regression caused by commit c0b5451129bba52e33cd7957d58af897a58d14c6 2025-02-27, that build fails on MinGW.
E:/Note/Tool/llvm/lldb/source/Host/windows/PipeWindows.cpp:285:17: error: 'ceil' does not name a template but is followed by template arguments
  285 |       timeout ? ceil<std::chrono::milliseconds>(*timeout).count() : INFINITE;
      |                 ^   ~~~~~~~~~~~~~~~~~~~~~~~~~~~
D:/msys64/ucrt64/include/math.h:197:18: note: non-template declaration found by name lookup
  197 |   double __cdecl ceil(double _X);
      |                  ^

regression-l.patch
regression-m.patch
Fix the regression caused by commit 1a7b7e24bcc1041ae0fb90abcfb73d36d76f4a07 2025-07-01, that build fails on MinGW.

