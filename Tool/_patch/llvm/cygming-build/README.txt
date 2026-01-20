

cygming-build-p-{a,b}.patch
Fix build of LLVM 22 using GCC with llvm_lib_type as static. Backported to LLVM 16. Do not build cygLTO.dll.
./build-llvm.sh GCC '' '' static
collect2: error: ld returned 1 exit status
/cygdrive/d/_cygwin/binutils/bin/ld.bfd: error: export ordinal too large: 71238
make[2]: *** [tools/lto/CMakeFiles/LTO.dir/build.make:304: bin/cygLTO.dll] Error 1
make[2]: Leaving directory '/cygdrive/e/Note/Tool/llvm-cygwin-gcc-bfd-release-build'
make[1]: *** [CMakeFiles/Makefile2:44764: tools/lto/CMakeFiles/LTO.dir/all] Error 2
make[1]: *** Waiting for unfinished jobs....
