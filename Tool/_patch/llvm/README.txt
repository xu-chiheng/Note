

https://cygwin.com/cgit/cygwin-packages
https://cygwin.com/cgit/cygwin-packages/clang
https://cygwin.com/cgit/cygwin-packages/llvm


https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-clang
https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-clang/PKGBUILD

https://src.fedoraproject.org/rpms/llvm.git



on Cygwin
stage 0 : GCC 13.2.0 or GCC 11.4.0 (pre-installed) at /usr, Clang 8.0.1 (pre-installed) at /usr does not work
stage 1 : Clang 16.0.6
stage 2 : Clang 16.0.6
stage 3 : Clang 16.0.6


16.0.0    b0daacf58f417634f7c7c9496589d723592a8f5a 2023-01-24
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-0,driver-0,general-{a,b,c},macro},mingw-{ldflags,pthread,emutls-0,findgcc-0},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

17.0.0    d0b54bb50e5110a004b41fc06dadf3fee70834b7 2023-07-25
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-0,driver-0,general-{a,b,c},macro,CGCall.h},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    6f44f87011cd52367626cac111ddbb2d25784b90 2023-10-05
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-1,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-2,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    f49e2b05bf3ececa2fe20c5d658ab92ab974dc36 2023-12-17
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-2,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-a},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    90c397fc56b7a04dd53cdad8103de1ead9686104 2024-01-01
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-2,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-{a,b}},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    8b4bb15f6d879fd8655f9e41fee224a8a59f238c 2024-01-19
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-2,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-{a,b}},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch \
              ../_patch/llvm/cygwin-disable-debug-ata.patch

18.0.0    93248729cfae82a5ca2323d4a8e15aa3b9b9c707 2024-01-24
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-3,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-{a,b,c}},mingw-{ldflags,pthread,emutls-1,findgcc-0,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch \
              ../_patch/llvm/cygwin-disable-debug-ata.patch

19.0.0    c5f839bd58e7f888acc4cb39a18e9e5bbaa9fb0a 2024-03-22
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-1,driver-3,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-{a,b,c}},mingw-{ldflags,pthread,emutls-1,findgcc-1,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch \
              ../_patch/llvm/cygwin-disable-debug-ata.patch

19.0.0    f2ccf80136a01ca69f766becafb329db6c54c0c8 2024-07-23
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-2,driver-4,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-{a,b,c}},mingw-{ldflags,pthread,emutls-1,findgcc-1,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    f999b321d7317fa9e59ce597bd3d63b7035fe774 2024-08-16
patch_apply . ../_patch/llvm/{cygwin-{prevent-versioning,not-use-symlink,cmake-option,support-tls,va-list-kind,cmodel-2,driver-4,general-{a,b,c},macro,CGCall.h,X86ISelLowering.cpp,X86ISelDAGToDAG.cpp-{a,b,c}},mingw-{ldflags,pthread,emutls-1,findgcc-1,Value.h},pseudo-{gen-Main,lib-Grammar}.cpp}.patch

git add clang/lib/Driver/ToolChains/Cygwin.{cpp,h}

clang -v
git show -s



cygwin-general-a.patch
Fix build error by Clang due to the conflict of CIndexer.cpp and mm_malloc.h. In mm_malloc.h, _WIN32 and __CYGWIN__ can't both be defined, but CIndexer.cpp define both.
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


cygwin-general-b.patch
Remove some uses of macro __CYGWIN__ .


cygwin-general-c.patch
Override Cygwin's buggy getpagesize() to Win32 computePageSize().


cygwin-CGCall.h.patch
Reduced number of inline elements of CallArgList.
This fix bootstraping on Cygwin, using GCC 13.2.0 as stage 0 compiler.
It seems that the size of CallArgList can't exceed an unknown limit.  
As commit 49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09, this patch is not needed.


cygwin-X86ISelLowering.cpp.patch
Fix the regression caused by commit c04a05d898982614a2df80d928b97ed4f8c49b60 2023-08-14, that, in Cygwin, Clang can't bootstrap.
Cygwin runtime failure: /cygdrive/e/Note/Tool/llvm-release-build/bin/llvm-min-tblgen.exe: Invalid relocation.  Offset 0x7837bccad at address 0x7ff7902c1077 doesn't fit into 32 bits
make[1]: *** [CMakeFiles/Makefile2:11572: include/llvm/TargetParser/CMakeFiles/RISCVTargetParserTableGen.dir/all] Error 2
Cygwin runtime failure: /cygdrive/e/Note/Tool/llvm-release-build/bin/llvm-min-tblgen.exe: Invalid relocation.  Offset 0x7837bccad at address 0x7ff7902c1077 doesn't fit into 32 bits
Cygwin runtime failure: /cygdrive/e/Note/Tool/llvm-release-build/bin/llvm-min-tblgen.exe: Invalid relocation.  Offset 0x7837bccad at address 0x7ff7902c1077 doesn't fit into 32 bits
make[2]: *** [include/llvm/IR/CMakeFiles/intrinsics_gen.dir/build.make:311: include/llvm/IR/IntrinsicImpl.inc] Error 127
Cygwin runtime failure: /cygdrive/e/Note/Tool/llvm-release-build/bin/llvm-min-tblgen.exe: Invalid relocation.  Offset 0x7837bccad at address 0x7ff7902c1077 doesn't fit into 32 bits
Cygwin runtime failure: /cygdrive/e/Note/Tool/llvm-release-build/bin/llvm-min-tblgen.exe: Invalid relocation.  Offset 0x7837bccad at address 0x7ff7902c1077 doesn't fit into 32 bits
make[2]: *** [include/llvm/IR/CMakeFiles/intrinsics_gen.dir/build.make:237: include/llvm/IR/IntrinsicEnums.inc] Error 127
make[2]: *** [include/llvm/Frontend/OpenACC/CMakeFiles/acc_gen.dir/build.make:172: include/llvm/Frontend/OpenACC/ACC.inc] Error 127
make[2]: *** [include/llvm/Frontend/OpenMP/CMakeFiles/omp_gen.dir/build.make:121: include/llvm/Frontend/OpenMP/OMP.h.inc] Error 127
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [CMakeFiles/Makefile2:11520: include/llvm/Frontend/OpenACC/CMakeFiles/acc_gen.dir/all] Error 2
make[2]: *** [include/llvm/IR/CMakeFiles/intrinsics_gen.dir/build.make:459: include/llvm/IR/IntrinsicsAMDGPU.h] Error 127
Cygwin runtime failure: /cygdrive/e/Note/Tool/llvm-release-build/bin/llvm-min-tblgen.exe: Invalid relocation.  Offset 0x7837bccad at address 0x7ff7902c1077 doesn't fit into 32 bits
make[2]: *** [include/llvm/Frontend/OpenMP/CMakeFiles/omp_gen.dir/build.make:172: include/llvm/Frontend/OpenMP/OMP.inc] Error 127
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make[2]: *** [include/llvm/IR/CMakeFiles/intrinsics_gen.dir/build.make:385: include/llvm/IR/IntrinsicsAArch64.h] Error 127
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-release-build'
make[1]: *** [CMakeFiles/Makefile2:11546: include/llvm/Frontend/OpenMP/CMakeFiles/omp_gen.dir/all] Error 2
make[1]: *** [CMakeFiles/Makefile2:11468: include/llvm/IR/CMakeFiles/intrinsics_gen.dir/all] Error 2
[  9%] Linking CXX executable ../../bin/FileCheck.exe


cygwin-X86ISelDAGToDAG.cpp-a.patch
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


cygwin-X86ISelDAGToDAG.cpp-b.patch
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


cygwin-X86ISelDAGToDAG.cpp-c.patch
Fix the regression caused by commit 86eaf6083b2cd27b8811f4791ad2eb8dacbb0e5f 2024-01-20, that, in Cygwin, Clang can't bootstrap.
/cygdrive/d/cygwin-packages/llvm/bin/clang++.exe -march=x86-64 -O3 -Werror=date-time -Werror=unguarded-availability-new -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wmissing-field-initializers -pedantic -Wno-long-long -Wc++98-compat-extra-semi -Wimplicit-fallthrough -Wcovered-switch-default -Wno-noexcept-type -Wnon-virtual-dtor -Wdelete-non-virtual-dtor -Wsuggest-override -Wstring-conversion -Wmisleading-indentation -Wctad-maybe-unsupported -Werror=global-constructors -O3 -DNDEBUG  -Wl,-rpath-link,/cygdrive/e/Note/Tool/llvm-cygwin-clang-release-build/./lib  -Wl,--gc-sections -Wl,--strip-all -shared -Wl,--enable-auto-import -o ../../bin/cygLLVMSupport-18git.dll -Wl,--out-implib,../libLLVMSupport.dll.a -Wl,--major-image-version,18,--minor-image-version,0 CMakeFiles/LLVMSupport.dir/ABIBreak.cpp.o CMakeFiles/LLVMSupport.dir/AMDGPUMetadata.cpp.o CMakeFiles/LLVMSupport.dir/APFixedPoint.cpp.o CMakeFiles/LLVMSupport.dir/APFloat.cpp.o CMakeFiles/LLVMSupport.dir/APInt.cpp.o CMakeFiles/LLVMSupport.dir/APSInt.cpp.o CMakeFiles/LLVMSupport.dir/ARMBuildAttrs.cpp.o CMakeFiles/LLVMSupport.dir/ARMAttributeParser.cpp.o CMakeFiles/LLVMSupport.dir/ARMWinEH.cpp.o CMakeFiles/LLVMSupport.dir/Allocator.cpp.o CMakeFiles/LLVMSupport.dir/AutoConvert.cpp.o CMakeFiles/LLVMSupport.dir/Base64.cpp.o CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o CMakeFiles/LLVMSupport.dir/BinaryStreamError.cpp.o CMakeFiles/LLVMSupport.dir/BinaryStreamReader.cpp.o CMakeFiles/LLVMSupport.dir/BinaryStreamRef.cpp.o CMakeFiles/LLVMSupport.dir/BinaryStreamWriter.cpp.o CMakeFiles/LLVMSupport.dir/BlockFrequency.cpp.o CMakeFiles/LLVMSupport.dir/BranchProbability.cpp.o CMakeFiles/LLVMSupport.dir/BuryPointer.cpp.o CMakeFiles/LLVMSupport.dir/CachePruning.cpp.o CMakeFiles/LLVMSupport.dir/Caching.cpp.o CMakeFiles/LLVMSupport.dir/circular_raw_ostream.cpp.o CMakeFiles/LLVMSupport.dir/Chrono.cpp.o CMakeFiles/LLVMSupport.dir/COM.cpp.o CMakeFiles/LLVMSupport.dir/CodeGenCoverage.cpp.o CMakeFiles/LLVMSupport.dir/CommandLine.cpp.o CMakeFiles/LLVMSupport.dir/Compression.cpp.o CMakeFiles/LLVMSupport.dir/CRC.cpp.o CMakeFiles/LLVMSupport.dir/ConvertUTF.cpp.o CMakeFiles/LLVMSupport.dir/ConvertEBCDIC.cpp.o CMakeFiles/LLVMSupport.dir/ConvertUTFWrapper.cpp.o CMakeFiles/LLVMSupport.dir/CrashRecoveryContext.cpp.o CMakeFiles/LLVMSupport.dir/CSKYAttributes.cpp.o CMakeFiles/LLVMSupport.dir/CSKYAttributeParser.cpp.o CMakeFiles/LLVMSupport.dir/DataExtractor.cpp.o CMakeFiles/LLVMSupport.dir/Debug.cpp.o CMakeFiles/LLVMSupport.dir/DebugCounter.cpp.o CMakeFiles/LLVMSupport.dir/DeltaAlgorithm.cpp.o CMakeFiles/LLVMSupport.dir/DivisionByConstantInfo.cpp.o CMakeFiles/LLVMSupport.dir/DAGDeltaAlgorithm.cpp.o CMakeFiles/LLVMSupport.dir/DJB.cpp.o CMakeFiles/LLVMSupport.dir/ELFAttributeParser.cpp.o CMakeFiles/LLVMSupport.dir/ELFAttributes.cpp.o CMakeFiles/LLVMSupport.dir/Error.cpp.o CMakeFiles/LLVMSupport.dir/ErrorHandling.cpp.o CMakeFiles/LLVMSupport.dir/ExtensibleRTTI.cpp.o CMakeFiles/LLVMSupport.dir/FileCollector.cpp.o CMakeFiles/LLVMSupport.dir/FileUtilities.cpp.o CMakeFiles/LLVMSupport.dir/FileOutputBuffer.cpp.o CMakeFiles/LLVMSupport.dir/FloatingPointMode.cpp.o CMakeFiles/LLVMSupport.dir/FoldingSet.cpp.o CMakeFiles/LLVMSupport.dir/FormattedStream.cpp.o CMakeFiles/LLVMSupport.dir/FormatVariadic.cpp.o CMakeFiles/LLVMSupport.dir/GlobPattern.cpp.o CMakeFiles/LLVMSupport.dir/GraphWriter.cpp.o CMakeFiles/LLVMSupport.dir/Hashing.cpp.o CMakeFiles/LLVMSupport.dir/InitLLVM.cpp.o CMakeFiles/LLVMSupport.dir/InstructionCost.cpp.o CMakeFiles/LLVMSupport.dir/IntEqClasses.cpp.o CMakeFiles/LLVMSupport.dir/IntervalMap.cpp.o CMakeFiles/LLVMSupport.dir/JSON.cpp.o CMakeFiles/LLVMSupport.dir/KnownBits.cpp.o CMakeFiles/LLVMSupport.dir/LEB128.cpp.o CMakeFiles/LLVMSupport.dir/LineIterator.cpp.o CMakeFiles/LLVMSupport.dir/Locale.cpp.o CMakeFiles/LLVMSupport.dir/LockFileManager.cpp.o CMakeFiles/LLVMSupport.dir/ManagedStatic.cpp.o CMakeFiles/LLVMSupport.dir/MathExtras.cpp.o CMakeFiles/LLVMSupport.dir/MemAlloc.cpp.o CMakeFiles/LLVMSupport.dir/MemoryBuffer.cpp.o CMakeFiles/LLVMSupport.dir/MemoryBufferRef.cpp.o CMakeFiles/LLVMSupport.dir/MD5.cpp.o CMakeFiles/LLVMSupport.dir/MSP430Attributes.cpp.o CMakeFiles/LLVMSupport.dir/MSP430AttributeParser.cpp.o CMakeFiles/LLVMSupport.dir/NativeFormatting.cpp.o CMakeFiles/LLVMSupport.dir/OptimizedStructLayout.cpp.o CMakeFiles/LLVMSupport.dir/Optional.cpp.o CMakeFiles/LLVMSupport.dir/PGOOptions.cpp.o CMakeFiles/LLVMSupport.dir/Parallel.cpp.o CMakeFiles/LLVMSupport.dir/PluginLoader.cpp.o CMakeFiles/LLVMSupport.dir/PrettyStackTrace.cpp.o CMakeFiles/LLVMSupport.dir/RandomNumberGenerator.cpp.o CMakeFiles/LLVMSupport.dir/Regex.cpp.o CMakeFiles/LLVMSupport.dir/RISCVAttributes.cpp.o CMakeFiles/LLVMSupport.dir/RISCVAttributeParser.cpp.o CMakeFiles/LLVMSupport.dir/RISCVISAInfo.cpp.o CMakeFiles/LLVMSupport.dir/ScaledNumber.cpp.o CMakeFiles/LLVMSupport.dir/ScopedPrinter.cpp.o CMakeFiles/LLVMSupport.dir/SHA1.cpp.o CMakeFiles/LLVMSupport.dir/SHA256.cpp.o CMakeFiles/LLVMSupport.dir/Signposts.cpp.o CMakeFiles/LLVMSupport.dir/SmallPtrSet.cpp.o CMakeFiles/LLVMSupport.dir/SmallVector.cpp.o CMakeFiles/LLVMSupport.dir/SourceMgr.cpp.o CMakeFiles/LLVMSupport.dir/SpecialCaseList.cpp.o CMakeFiles/LLVMSupport.dir/Statistic.cpp.o CMakeFiles/LLVMSupport.dir/StringExtras.cpp.o CMakeFiles/LLVMSupport.dir/StringMap.cpp.o CMakeFiles/LLVMSupport.dir/StringSaver.cpp.o CMakeFiles/LLVMSupport.dir/StringRef.cpp.o CMakeFiles/LLVMSupport.dir/SuffixTreeNode.cpp.o CMakeFiles/LLVMSupport.dir/SuffixTree.cpp.o CMakeFiles/LLVMSupport.dir/SystemUtils.cpp.o CMakeFiles/LLVMSupport.dir/TarWriter.cpp.o CMakeFiles/LLVMSupport.dir/ThreadPool.cpp.o CMakeFiles/LLVMSupport.dir/TimeProfiler.cpp.o CMakeFiles/LLVMSupport.dir/Timer.cpp.o CMakeFiles/LLVMSupport.dir/ToolOutputFile.cpp.o CMakeFiles/LLVMSupport.dir/Twine.cpp.o CMakeFiles/LLVMSupport.dir/TypeSize.cpp.o CMakeFiles/LLVMSupport.dir/Unicode.cpp.o CMakeFiles/LLVMSupport.dir/UnicodeCaseFold.cpp.o CMakeFiles/LLVMSupport.dir/UnicodeNameToCodepoint.cpp.o CMakeFiles/LLVMSupport.dir/UnicodeNameToCodepointGenerated.cpp.o CMakeFiles/LLVMSupport.dir/VersionTuple.cpp.o CMakeFiles/LLVMSupport.dir/VirtualFileSystem.cpp.o CMakeFiles/LLVMSupport.dir/WithColor.cpp.o CMakeFiles/LLVMSupport.dir/YAMLParser.cpp.o CMakeFiles/LLVMSupport.dir/YAMLTraits.cpp.o CMakeFiles/LLVMSupport.dir/raw_os_ostream.cpp.o CMakeFiles/LLVMSupport.dir/raw_ostream.cpp.o CMakeFiles/LLVMSupport.dir/raw_socket_stream.cpp.o CMakeFiles/LLVMSupport.dir/regcomp.c.o CMakeFiles/LLVMSupport.dir/regerror.c.o CMakeFiles/LLVMSupport.dir/regexec.c.o CMakeFiles/LLVMSupport.dir/regfree.c.o CMakeFiles/LLVMSupport.dir/regstrlcpy.c.o CMakeFiles/LLVMSupport.dir/xxhash.cpp.o CMakeFiles/LLVMSupport.dir/Z3Solver.cpp.o CMakeFiles/LLVMSupport.dir/Atomic.cpp.o CMakeFiles/LLVMSupport.dir/DynamicLibrary.cpp.o CMakeFiles/LLVMSupport.dir/Errno.cpp.o CMakeFiles/LLVMSupport.dir/Memory.cpp.o CMakeFiles/LLVMSupport.dir/Path.cpp.o CMakeFiles/LLVMSupport.dir/Process.cpp.o CMakeFiles/LLVMSupport.dir/Program.cpp.o CMakeFiles/LLVMSupport.dir/RWMutex.cpp.o CMakeFiles/LLVMSupport.dir/Signals.cpp.o CMakeFiles/LLVMSupport.dir/Threading.cpp.o CMakeFiles/LLVMSupport.dir/Valgrind.cpp.o CMakeFiles/LLVMSupport.dir/Watchdog.cpp.o BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3.c.o BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_dispatch.c.o BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_portable.c.o BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_neon.c.o "BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_sse2_x86-64_windows_gnu.S.o" "BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_sse41_x86-64_windows_gnu.S.o" "BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_avx2_x86-64_windows_gnu.S.o" "BLAKE3/CMakeFiles/LLVMSupportBlake3.dir/blake3_avx512_x86-64_windows_gnu.S.o"  -lrt -ldl -lm /usr/lib/libz.dll.a /usr/lib/libzstd.dll.a /usr/lib/libcurses.dll.a ../libLLVMDemangle.dll.a 
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text+0x305): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `std::_Function_handler<void (), llvm::BalancedPartitioning::BPThreadPool::async<llvm::BalancedPartitioning::run(std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> >&) const::$_0>(llvm::BalancedPartitioning::run(std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> >&) const::$_0&&)::{lambda()#1}>::_M_invoke(std::_Any_data const&)'
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text+0x30e): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `std::_Function_handler<void (), llvm::BalancedPartitioning::BPThreadPool::async<llvm::BalancedPartitioning::run(std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> >&) const::$_0>(llvm::BalancedPartitioning::run(std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> >&) const::$_0&&)::{lambda()#1}>::_M_manager(std::_Any_data&, std::_Any_data const&, std::_Manager_operation)'
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text+0x8fd): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `std::_Function_handler<void (), llvm::BalancedPartitioning::BPThreadPool::async<llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_2>(llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_2&&)::{lambda()#1}>::_M_invoke(std::_Any_data const&)'
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text+0x906): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `std::_Function_handler<void (), llvm::BalancedPartitioning::BPThreadPool::async<llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_2>(llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_2&&)::{lambda()#1}>::_M_manager(std::_Any_data&, std::_Any_data const&, std::_Manager_operation)'
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text+0xa5e): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `std::_Function_handler<void (), llvm::BalancedPartitioning::BPThreadPool::async<llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_3>(llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_3&&)::{lambda()#1}>::_M_invoke(std::_Any_data const&)'
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text+0xa67): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against `std::_Function_handler<void (), llvm::BalancedPartitioning::BPThreadPool::async<llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_3>(llvm::BalancedPartitioning::bisect(llvm::iterator_range<__gnu_cxx::__normal_iterator<llvm::BPFunctionNode*, std::vector<llvm::BPFunctionNode, std::allocator<llvm::BPFunctionNode> > > >, unsigned int, unsigned int, unsigned int, std::optional<llvm::BalancedPartitioning::BPThreadPool>&) const::$_3&&)::{lambda()#1}>::_M_manager(std::_Any_data&, std::_Any_data const&, std::_Manager_operation)'
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text[_ZN4llvm10ThreadPool19createTaskAndFutureESt8functionIFvvEE]+0x19d): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against symbol `std::_Function_handler<void (), llvm::ThreadPool::createTaskAndFuture(std::function<void ()>)::{lambda()#1}>::_M_invoke(std::_Any_data const&)' defined in .text[_ZNSt17_Function_handlerIFvvEZN4llvm10ThreadPool19createTaskAndFutureESt8functionIS0_EEUlvE_E9_M_invokeERKSt9_Any_data] section in CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text[_ZN4llvm10ThreadPool19createTaskAndFutureESt8functionIFvvEE]+0x1a5): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against symbol `std::_Function_handler<void (), llvm::ThreadPool::createTaskAndFuture(std::function<void ()>)::{lambda()#1}>::_M_manager(std::_Any_data&, std::_Any_data const&, std::_Manager_operation)' defined in .text[_ZNSt17_Function_handlerIFvvEZN4llvm10ThreadPool19createTaskAndFutureESt8functionIS0_EEUlvE_E10_M_managerERSt9_Any_dataRKS7_St18_Manager_operation] section in CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text[_ZNSt17_Function_handlerIFvvEZN4llvm10ThreadPool19createTaskAndFutureESt8functionIS0_EEUlvE_E9_M_invokeERKSt9_Any_data]+0x34): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against symbol `std::_Function_handler<std::unique_ptr<std::__future_base::_Result_base, std::__future_base::_Result_base::_Deleter> (), std::__future_base::_State_baseV2::_Setter<void, void> >::_M_invoke(std::_Any_data const&)' defined in .text[_ZNSt17_Function_handlerIFSt10unique_ptrINSt13__future_base12_Result_baseENS2_8_DeleterEEvENS1_13_State_baseV27_SetterIvvEEE9_M_invokeERKSt9_Any_data] section in CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text[_ZNSt17_Function_handlerIFvvEZN4llvm10ThreadPool19createTaskAndFutureESt8functionIS0_EEUlvE_E9_M_invokeERKSt9_Any_data]+0x3d): relocation truncated to fit: IMAGE_REL_AMD64_ADDR32 against symbol `std::_Function_handler<std::unique_ptr<std::__future_base::_Result_base, std::__future_base::_Result_base::_Deleter> (), std::__future_base::_State_baseV2::_Setter<void, void> >::_M_manager(std::_Any_data&, std::_Any_data const&, std::_Manager_operation)' defined in .text[_ZNSt17_Function_handlerIFSt10unique_ptrINSt13__future_base12_Result_baseENS2_8_DeleterEEvENS1_13_State_baseV27_SetterIvvEEE10_M_managerERSt9_Any_dataRKSA_St18_Manager_operation] section in CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o
CMakeFiles/LLVMSupport.dir/BalancedPartitioning.cpp.o:BalancedPartitioning.cpp:(.text[_ZNSt13__future_base13_State_baseV213_M_set_resultESt8functionIFSt10unique_ptrINS_12_Result_baseENS3_8_DeleterEEvEEb]+0x1f): additional relocation overflows omitted from the output
clang++: error: linker command failed with exit code 1 (use -v to see invocation)
make[2]: *** [lib/Support/CMakeFiles/LLVMSupport.dir/build.make:2373: bin/cygLLVMSupport-18git.dll] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-release-build'
make[1]: *** [CMakeFiles/Makefile2:15466: lib/Support/CMakeFiles/LLVMSupport.dir/all] Error 2
make[1]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-clang-release-build'
make: *** [Makefile:156: all] Error 2


cygwin-disable-debug-ata.patch
Fix the regression caused by commit 7c71a09d5e712bedbed867226b3fa0bbfe789384 2024-01-10, that, in Cygwin, Clang can't bootstrap.
Stuck at cmake configure :
-- Looking for pfm_initialize in pfm
-- Looking for pfm_initialize in pfm - not found
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD




mingw-pthread.patch
https://github.com/llvm/llvm-project/pull/74981


mingw-emutls.patch
https://github.com/llvm/llvm-project/pull/74980


mingw-Value.h.patch
Fix the regression caused by commit 592e935e115ffb451eb9b782376711dab6558fe0 2023-05-26, that, in MinGW, Clang can't be built by system Clang.








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

