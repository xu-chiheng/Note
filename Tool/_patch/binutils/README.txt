
https://cygwin.com/cgit/cygwin-packages/binutils

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-binutils

https://src.fedoraproject.org/rpms/binutils.git


2.36    055bc77a80b333ec68c373719b54aee6c232995b    2021-01-09    branch point
patch_apply . ../_patch/binutils/{cygming-PICFLAG-36,mingw-replace-{mingw32,w64}}.patch

2.37    514192487e2e12a4c147a761d59912f06cafb3cf    2021-07-03    branch point
2.38    a74e1cb34453a5111104302315e407c01b9c2fb0    2022-01-22    branch point
2.39    0bd093231433c6a85853330369247b17f4859bee    2022-07-08    branch point
2.40    a72b07181dcd18b54f193322043d51058c1ef632    2022-12-31    branch point
2.41    d501d384886673b7c3981fe225b2d7719440abda    2023-07-03    branch point
patch_apply . ../_patch/binutils/{cygming-PICFLAG-41,mingw-replace-{mingw32,w64}}.patch

2.42    299b91cd85540b4bfa94124364572f6a51b816fe    2024-01-15    branch point
2.43    b33c4f8f828e168d96b60d4ac828fdc19c8cdcb4    2024-07-20    branch point
2.44    81e9e54636835c1fc286d87d33d51a8b3da7b35a    2024-08-16
patch_apply . ../_patch/binutils/{cygming-PICFLAG-44,mingw-replace-{mingw32,w64}}.patch

2.44    a253bea8995323201b016fe477280c1782688ab4    2024-08-28
patch_apply . ../_patch/binutils/{cygming-PICFLAG-44,mingw-{replace-{mingw32,w64},dlltool.c}}.patch


mingw-dlltool.c.patch
MinGW : Fix build due to undefined NAME_MAX, caused by commit a253bea8995323201b016fe477280c1782688ab4 2024-08-28.
