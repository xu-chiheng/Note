
https://cygwin.com/cgit/cygwin-packages/gdb

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-gdb

https://src.fedoraproject.org/rpms/gdb.git


15.0.0    3a624d9f1c5ccd8cefdd5b7ef12b41513f9006cd    2024-05-26    branch point
16.0.0    ee29a3c4ac7adc928ae6ed1fed3b59c940a519a4    2024-12-29    branch point
17.0.0    7e432e93f8aaa14368476cf5eae9d55c18a266fb    2025-08-18
patch_apply . ../_patch/gdb/{\
../gcc/mingw/mingw-include-lib-b,\
../binutils/{cygming-PICFLAG-{a,b,c,d,e,f,g,h},mingw-replace-{mingw32-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q},w64-{a,b}}},\
mingw-build-{a,b,c}}.patch
