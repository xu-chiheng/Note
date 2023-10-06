
https://cygwin.com/git-cygwin-packages/
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/gcc.git;a=summary
git://cygwin.com/git/cygwin-packages/gcc.git

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-gcc




12.0.0
patch_apply . ../patch/gcc/{cygwin-dynamicbase,mingw-{gethostname,dynamicbase}}.patch

13.0.0
patch_apply . ../patch/gcc/{cygwin-dynamicbase,mingw-{gethostname,dynamicbase}}.patch

14.0.0
patch_apply . ../patch/gcc/{cygwin-dynamicbase,mingw-{gethostname,dynamicbase}}.patch


mingw-x-mingw32-utf8.patch
commit 3beeebd6934654f3453209730b98c7a1fd0305b6, fix build by Clang
