
https://cygwin.com/cgit/cygwin-packages/binutils

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-binutils

https://src.fedoraproject.org/rpms/binutils.git


2.42    299b91cd85540b4bfa94124364572f6a51b816fe    2024-01-15    branch point
2.43    b33c4f8f828e168d96b60d4ac828fdc19c8cdcb4    2024-07-20    branch point
2.44    81e9e54636835c1fc286d87d33d51a8b3da7b35a    2024-08-16
patch_apply . ../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-6,w64-0}}.patch

2.44    a253bea8995323201b016fe477280c1782688ab4    2024-08-28
patch_apply . ../_patch/binutils/{cygming-PICFLAG-2,mingw-{replace-{mingw32-6,w64-0},dlltool.c}}.patch


mingw-dlltool.c.patch
MinGW : Fix build due to undefined NAME_MAX, caused by commit a253bea8995323201b016fe477280c1782688ab4 2024-08-28.
