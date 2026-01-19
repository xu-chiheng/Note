
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

regression-n.patch
Fix the regression caused by commit a12ca57c1cb070be8e0048004c6b4e820029b6ee 2025-02-25, that build fails on Cygwin using GCC 16.0.0 20250819.
/cygdrive/e/Note/Tool/llvm/llvm/lib/Transforms/Vectorize/SLPVectorizer.cpp: In lambda function:
/cygdrive/e/Note/Tool/llvm/llvm/lib/Transforms/Vectorize/SLPVectorizer.cpp:5295:14: error: declaration of 'unsigned int Sz' shadows a parameter
 5295 |     unsigned Sz = DL->getTypeSizeInBits(ScalarTy);
      |              ^~
/cygdrive/e/Note/Tool/llvm/llvm/lib/Transforms/Vectorize/SLPVectorizer.cpp:5246:44: note: 'const unsigned int& Sz' previously declared here
 5246 |     APInt DemandedElts = APInt::getAllOnes(Sz);
      |                                            ^~

regression-o.patch
Fix the regression caused by commit 7615503409f19ad7e2e2f946437919d0689d4b3e 2025-07-14, that build fails on Visual Studio.
This patch is backported from commmit 1409db663139a644871362ffb23d725078bc84cf 2025-11-04.
       “E:\Note\Tool\llvm-visual_studio-build\LLVM.sln”(默认目标) (1) ->
       “E:\Note\Tool\llvm-visual_studio-build\tools\clang\test\Analysis\LifetimeSafety\benchmark_venv_setup.vcxproj.metaproj”(默认目标) (1501) ->
       “E:\Note\Tool\llvm-visual_studio-build\tools\clang\test\Analysis\LifetimeSafety\benchmark_venv_setup.vcxproj”(默认目标) (1504) ->
       (CustomBuild 目标) ->
         C:\Program Files\Microsoft Visual Studio\2022\Enterprise\MSBuild\Microsoft\VC\v170\Microsoft.CppCommon.targets(237,5): error MSB8066: Custom build for 'E:\Note\Tool\llvm-visual_studio-build\CMakeFiles\d147c9e9362f1dc0f4e6b3a8a8ad82b9\pyvenv.cfg.rule' exited with code 1. [E:\Note\Tool\llvm-visual_studio-build\tools\clang\test\Analysis\LifetimeSafety\benchmark_venv_setup.vcxproj]

regression-p.patch
Fix build on MinGW, using Clang and BFD, caused by commit 93d326038959fd87fb666a8bf97d774d0abb3591 2025-10-10.
[ 87%] Linking CXX executable ../../../../bin/lldb.exe
D:/_mingw_ucrt/binutils/bin/ld.bfd.exe: unrecognized option '--delayload=liblldb.dll'
D:/_mingw_ucrt/binutils/bin/ld.bfd.exe: use the --help option for usage information
clang++: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [tools/lldb/tools/driver/CMakeFiles/lldb.dir/build.make:131: bin/lldb.exe] Error 1
make[1]: *** [CMakeFiles/Makefile2:195047: tools/lldb/tools/driver/CMakeFiles/lldb.dir/all] Error 2
make: *** [Makefile:156: all] Error 2

regression-q.patch
Fix the regression caused by commit 98e6d5cd47d4db020a1406032f96fd5cdfc56563 2025-07-01, that build fails on MinGW using Clang.
This patch is backported from commmit d457621872528d27c8081cf147d41a6f46276d1d 2025-07-03.
E:/Note/Tool/llvm/lldb/source/Host/posix/ConnectionFileDescriptorPosix.cpp:279:15: error: static_cast from 'WaitableHandle' (aka 'void *') to 'uint64_t' (aka 'unsigned long long') is not allowed
  279 |               static_cast<uint64_t>(m_io_sp->GetWaitableHandle()),
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
E:/Note/Tool/llvm/lldb/include/lldb/Utility/Log.h:380:48: note: expanded from macro 'LLDB_LOGF'
  380 |       log_private->Formatf(__FILE__, __func__, __VA_ARGS__);                   \
      |                                                ^~~~~~~~~~~
make  -f lib/DWP/CMakeFiles/LLVMDWP.dir/build.make lib/DWP/CMakeFiles/LLVMDWP.dir/depend
E:/Note/Tool/llvm/lldb/source/Host/posix/ConnectionFileDescriptorPosix.cpp:383:15: error: static_cast from 'WaitableHandle' (aka 'void *') to 'uint64_t' (aka 'unsigned long long') is not allowed
  383 |               static_cast<uint64_t>(m_io_sp->GetWaitableHandle()),
      |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
E:/Note/Tool/llvm/lldb/include/lldb/Utility/Log.h:380:48: note: expanded from macro 'LLDB_LOGF'
  380 |       log_private->Formatf(__FILE__, __func__, __VA_ARGS__);                   \


