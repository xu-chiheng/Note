
https://cygwin.com/cgit/cygwin-packages/gdb

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-gdb

https://src.fedoraproject.org/rpms/gdb.git


14.0.0    8f12a1a841cd0c447de7a5a0f134a0efece73588    2023-09-28    branch point
patch_apply . \
../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-for-gdb-0,w64}}.patch \
../_patch/gdb/{mingw-build-{a,b,c},backport-{a,b,c}}.patch

15.0.0    a72924552626025ad0ad032edc7f02ea345fd2b5    2023-12-07    5e43a46efc48eeb4951f498b227aee5eb71c137b^
patch_apply . \
../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-for-gdb-1,w64}}.patch \
../_patch/gdb/{mingw-build-{a,b,c},backport-{a,b,c}}.patch

15.0.0    48a121f83cae0a625f63d3ad5f8a9149f7fa964a    2024-01-23    8fed036befd8e87e9a602a5fc926db30aad69af3^
patch_apply . \
../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-for-gdb-1,w64}}.patch \
../_patch/gdb/{mingw-build-{a,b,c},backport-{a,b}}.patch

15.0.0    9bec569fda7c76849cf3eb0e4a525f627d25f980    2024-03-21    acaf48b921453c37fc2df4151699c912940bcd25^
patch_apply . \
../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-for-gdb-1,w64}}.patch \
../_patch/gdb/{mingw-build-{a,b,c},backport-a}.patch

15.0.0    3a624d9f1c5ccd8cefdd5b7ef12b41513f9006cd    2024-05-26    branch point
16.0.0    6179272353d3b4384a2ac306fe11aa024f344d47    2024-08-24
16.0.0    a253bea8995323201b016fe477280c1782688ab4    2024-08-28
patch_apply . \
../_patch/binutils/{cygming-PICFLAG-2,mingw-replace-{mingw32-for-gdb-1,w64}}.patch \
../_patch/gdb/mingw-build-{a,b,c}.patch




backport-c.patch
backport commit 5e43a46efc48eeb4951f498b227aee5eb71c137b 2023-12-07 and commit 190fcd0d6ce07abc4f6ad08d43a3dedd48b27b3e 2023-12-08, fix build on Cygwin/MinGW.

backport-b.patch
backport commit 8fed036befd8e87e9a602a5fc926db30aad69af3 2024-01-23, fix build on Cygwin/MinGW.

backport-a.patch
backport commit acaf48b921453c37fc2df4151699c912940bcd25 2024-03-21, fix build on MinGW.
