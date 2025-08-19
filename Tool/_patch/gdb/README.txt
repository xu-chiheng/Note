
https://cygwin.com/cgit/cygwin-packages/gdb

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-gdb

https://src.fedoraproject.org/rpms/gdb.git


15.0.0    3a624d9f1c5ccd8cefdd5b7ef12b41513f9006cd    2024-05-26    branch point
16.0.0    6179272353d3b4384a2ac306fe11aa024f344d47    2024-08-24
16.0.0    a253bea8995323201b016fe477280c1782688ab4    2024-08-28
patch_apply . \
../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-for-gdb-1,w64-0}}.patch \
../_patch/gdb/mingw-build-{a,b,c}.patch
