
https://cygwin.com/cgit/cygwin-packages/binutils

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-binutils

https://src.fedoraproject.org/rpms/binutils.git


2.42    299b91cd85540b4bfa94124364572f6a51b816fe    2024-01-15    branch point
2.43    b33c4f8f828e168d96b60d4ac828fdc19c8cdcb4    2024-07-20    branch point
patch_apply . ../_patch/binutils/{\
../gcc/mingw/mingw-include-lib-b,\
cygming-PICFLAG-{a,b,c,d,e,f,g,h},\
mingw-replace-{mingw32-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q},w64-{a,b}}}.patch

2.44    572920f968385ece96e6df2e49cb9776f64f71cf    2025-01-19    branch point
2.45    5c778308bdb8c85585eb703ca8b3fda4a967aa08    2025-08-13    branch point
2.46    7e432e93f8aaa14368476cf5eae9d55c18a266fb    2025-08-18
patch_apply . ../_patch/binutils/{\
../gcc/mingw/mingw-include-lib-b,\
cygming-PICFLAG-{a,b,c,d,e,f,g,h},\
mingw-replace-{mingw32-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q},w64-{a,b}},\
regression-a}.patch




regression-a.patch
Fix build on MinGW due to undefined NAME_MAX, caused by commit a253bea8995323201b016fe477280c1782688ab4 2024-08-28.
