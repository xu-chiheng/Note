
https://cygwin.com/cgit/cygwin-packages
https://cygwin.com/cgit/cygwin-packages/clang
https://cygwin.com/cgit/cygwin-packages/llvm

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-clang
https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-clang/PKGBUILD

https://src.fedoraproject.org/rpms/llvm.git

on Cygwin, Clang 8.0.1 (pre-installed) at /usr does not work, can't be used to build LLVM.


16.0.0    b0daacf58f417634f7c7c9496589d723592a8f5a    2023-01-24    branch point
17.0.0    84de01908b58f3aa25cc3dc700a8a1b01b5263f0    2023-03-23    c4125a37806aa2f663018f4f8dc5bbd5159c51c1^
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c,e,f},\
cygming-build/cygming-build-{a,b-0,c,d,e,g,h,i,j-0,k,l,m,n,o},\
cygming-driver/cygming-driver-{a-0,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-0,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
mingw/mingw-{git-revision,emutls-0},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

17.0.0    a218c991811c2bc29539b6946920342f956fe758    2023-05-27    cbaa3597aaf6273e66b3f445ed36a6458143fe6a^
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c,e},\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o},\
cygming-driver/cygming-driver-{a-0,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-0,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

17.0.0    592e935e115ffb451eb9b782376711dab6558fe0    2023-05-28
17.0.0    d0b54bb50e5110a004b41fc06dadf3fee70834b7    2023-07-25    branch point
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o},\
cygming-driver/cygming-driver-{a-0,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-0,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    c04a05d898982614a2df80d928b97ed4f8c49b60    2023-08-14
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-0,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-a,\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    e873280e614f8457ebbe2ffdee389b4e336739a6    2023-09-14
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-0,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-a,\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    6f44f87011cd52367626cac111ddbb2d25784b90    2023-10-05
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-a,\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    49b27b150b97c190dedf8b45bf991c4b811ed953    2023-12-09
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-a,\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    ec92d74a0ef89b9dd46aee6ec8aca6bfd3c66a54    2023-12-14
18.0.0    f49e2b05bf3ececa2fe20c5d658ab92ab974dc36    2023-12-17
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    2366d53d8d8726b73408597b534d2f910c3d3e6d    2023-12-22
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    f70b229e9643ddb895d491b62a5ec0655917f6f8    2023-12-22
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b-0,c,d,e,f,g,h,i,j-0,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    a0c1b5bdda91920a66f58b0a891c551acff2d2a1    2023-12-31
18.0.0    90c397fc56b7a04dd53cdad8103de1ead9686104    2024-01-01
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    8b4bb15f6d879fd8655f9e41fee224a8a59f238c    2024-01-19
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

18.0.0    86eaf6083b2cd27b8811f4791ad2eb8dacbb0e5f    2024-01-20
18.0.0    93248729cfae82a5ca2323d4a8e15aa3b9b9c707    2024-01-24    branch point
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-a,\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k-0,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

19.0.0    c5f839bd58e7f888acc4cb39a18e9e5bbaa9fb0a    2024-03-22
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-1,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

19.0.0    281d71604f418eb952e967d9dc4b26241b7f96aa     2024-04-17
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

19.0.0    f65a52ab0ec22cf5c25ccf3c9d86b7635964b864    2024-06-29    2222fddfc0a2ff02036542511597839856289094^
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b,c},\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

19.0.0    f2ccf80136a01ca69f766becafb329db6c54c0c8    2024-07-23    branch point
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b},\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    db1d3b23a37c7a57fa8b9e5bc94e1b22e278d361    2024-08-03    7e44305041d96b064c197216b931ae3917a34ac1^
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-{a,b},\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    8bd9ade6284a793c898da133723121c3bcc49ef7    2024-08-03    8f39502b85d34998752193e85f36c408d3c99248^
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
backport/backport-a,\
regression/regression-{a,b-0},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    c2cac69d0806034879d2b958a2e52e45b6c533fb    2024-08-28
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-0,m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    a0dd90eb7dc318c9b3fccb9ba02e1e22fb073094    2024-09-06
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,c},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    59f8796aaabc1ce400a8698431d3c6bfab4ad1a4    2024-09-07
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,c,d},\
cygming-build/cygming-build-{a,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1},\
pseudo/pseudo-{gen-Main,lib-Grammar}.cpp}.patch

20.0.0    c2750807ba2a419425ee90dadda09ad5121517fe    2024-10-13
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-1,e},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    d4efc3e097f40afbe8ae275150f49bb08fc04572    2024-10-15
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-1,e,f},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    9eddc8b9bf4e4e0b01e2ecc90a71c4b3b4e9c8af    2024-10-15
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-1,e-1},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    d80b9cf713fd1698641c5b265de6b66618991476    2024-10-21
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-1,e-1,g},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-1},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    f4db221258cb44a8f9804ce852c0403328de39b2    2024-10-26
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-2,e-2,g-1},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    ba623e10b4064c410a1b79280ec7fb963463eb29    2024-11-15
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-2,g-1},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d,e,f,h,i,k,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    385b144c9477de6a4598bd08ce4f2883aeb236b9    2024-12-20
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-2,g-1},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,f,h-1,i,k-1,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

20.0.0    8c2574832ed2064996389e4259eaf0bea0fa7951    2025-01-29    branch point
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b,d-2,g-1},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,f-1,h-1,i-1,k-1,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    a12ca57c1cb070be8e0048004c6b4e820029b6ee    2025-02-25
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-2,g-1,n},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,f-1,h-1,i-1,k-1,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    c0b5451129bba52e33cd7957d58af897a58d14c6    2025-02-27
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-2,g-1,k,n},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,f-1,h-1,i-1,k-1,l-{a,b,c},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    39e7efe1e4304544289d8d1b45f4d04d11b4a791    2025-03-27
21.0.0    198c5dac37dbe9c6a5f10e2b5113afc39b6eb93d    2025-04-20
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-2,g-1,k,n},\
cygming-build/cygming-build-{a-1,b,c,d,e,f,g,h,i,j-1,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-1,l-{a,b,c,d},m,n,o,p},\
cygwin/cygwin-{support-tls,va-list-kind,cmodel-2,general-{a,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    46adbffcd581c4eb255b0c183331b0132ab12dd1    2025-06-03
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-2,g-2,k,n},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-2,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{va-list-kind,cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    eb76d8332e932dfda133fe95331e6910805a27c5    2025-06-11
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-2,g-2,h,k,n},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-2,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{va-list-kind,cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    167223f8c2c2350a3de9478355885c63b35ca6a9    2025-06-16
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-3,g-2,h,k,n},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    1a7b7e24bcc1041ae0fb90abcfb73d36d76f4a07    2025-07-01
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-4,g-2,h-1,k,l,m,n},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    2723a6d9928c7ba5d27125e03dff8eaba8661d7f    2025-07-02
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,_cygming_no_dylib,\
regression/regression-{a,b-1,d-5,g-2,h-1,i,k,l,m,n,q},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-1,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    d2ad63a193216d008c8161879a59c5f42e0125cc    2025-07-12
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-1,i,j,k,m-1,n},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-1,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

21.0.0    7615503409f19ad7e2e2f946437919d0689d4b3e    2025-07-14
21.0.0    94b15a1ece37963c9804fc7f0c498d140ea5fd9d    2025-07-15    branch point
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-1,i,j,k,m-1,n,o},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-1,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

22.0.0    0cb98c721bb540febab0fc0094388480940c49b0    2025-08-07
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-2,i,m-1,n,o},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-1,l,m,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

22.0.0    b161e8d7dff06d8fb410de897f1a3f0c561ec509    2025-08-31
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-2,i,m-1,n,o},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-2,l,m-1,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

22.0.0    93d326038959fd87fb666a8bf97d774d0abb3591    2025-10-10
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-2,i,m-1,n,o,p},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-2,l,m-1,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

22.0.0    6e25a04027ca786b7919657c7df330a33985ceea    2025-11-01
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-2,i,n,o,p},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-2,l,m-1,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

22.0.0    f42e58f61680e325555f382cab5115c54df6f6df    2025-12-01
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-2,i,n,o-1,p},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-2,l,m-1,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d,e},\
mingw/mingw-{git-revision,emutls-1}}.patch

22.0.0    44b44bc81babc38ac65868691054c25199aea420    2026-01-07
patch_apply . \
../_patch/llvm/{_prevent-versioning-{a,b},_cmake-dump,\
regression/regression-{a,b-1,d-5,g-2,h-2,i,n,o-1,p},\
cygming-build/cygming-build-{a-2,b-1,c-1,d,e,f,g,h,i,j-3,k-2,l,m-1,n,o-2},\
cygming-driver/cygming-driver-{b-1,c,d,e,f,g,h,i,j,k,l,m,n,o,p},\
cygwin-lld/cygwin-lld-{a,b-1,c},\
cygwin-lldb/cygwin-lldb-{a,b,c,d-1,e,h-1,i-1,k-2,l-{a,b,c,d},m,o,p},\
cygwin/cygwin-{cmodel-2,general-{a-1,b,c-{a,b,c-1,d}},macro-{a,b,c}},\
cygwin-regression/cygwin-regression-{a,b,c,d-1,e},\
mingw/mingw-{git-revision,emutls-1}}.patch



clang -v
git show -s




_prevent-versioning-{a,b}.patch
Prevent versioning when building LLVM

_cmake-dump.patch
Dump CMake variables




Issues:
Cygwin/MinGW GCC can't build debug mode LLVM using './build-llvm.sh GCC BFD Debug shared'

cd /cygdrive/e/Note/Tool/llvm-cygwin-gcc-bfd-debug-build/tools/clang/lib/ASTMatchers/Dynamic && /cygdrive/d/_cygwin/gcc/bin/g++.exe -DGTEST_HAS_RTTI=0 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -I/cygdrive/e/Note/Tool/llvm-cygwin-gcc-bfd-debug-build/tools/clang/lib/ASTMatchers/Dynamic -I/cygdrive/e/Note/Tool/llvm/clang/lib/ASTMatchers/Dynamic -I/cygdrive/e/Note/Tool/llvm/clang/include -I/cygdrive/e/Note/Tool/llvm-cygwin-gcc-bfd-debug-build/tools/clang/include -I/cygdrive/e/Note/Tool/llvm-cygwin-gcc-bfd-debug-build/include -I/cygdrive/e/Note/Tool/llvm/llvm/include -march=x86-64 -Og -g -Werror=date-time -fno-lifetime-dse -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wno-missing-field-initializers -pedantic -Wno-long-long -Wimplicit-fallthrough -Wno-maybe-uninitialized -Wno-nonnull -Wno-class-memaccess -Wno-redundant-move -Wno-pessimizing-move -Wno-noexcept-type -Wdelete-non-virtual-dtor -Wsuggest-override -Wno-comment -Wno-misleading-indentation -Wctad-maybe-unsupported -fno-common -Woverloaded-virtual -fno-strict-aliasing -g -std=gnu++17  -fno-exceptions -funwind-tables -fno-rtti -MD -MT tools/clang/lib/ASTMatchers/Dynamic/CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o -MF CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o.d -o CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o -c /cygdrive/e/Note/Tool/llvm/clang/lib/ASTMatchers/Dynamic/Registry.cpp
as: CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o: too many sections (59610)
/cygdrive/c/Users/ADMINI~1/AppData/Local/Temp/cc9sd7D7.s: Assembler messages:
/cygdrive/c/Users/ADMINI~1/AppData/Local/Temp/cc9sd7D7.s: Fatal error: can't write 16 bytes to section .text of CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o: 'file too big'
as: CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o: too many sections (59610)
/cygdrive/c/Users/ADMINI~1/AppData/Local/Temp/cc9sd7D7.s: Fatal error: CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.o: file too big

cd E:/Note/Tool/llvm-mingw-ucrt-gcc-bfd-debug-build/tools/clang/lib/ASTMatchers/Dynamic && D:/_mingw-ucrt/gcc/bin/g++.exe -DGTEST_HAS_RTTI=0 -D_FILE_OFFSET_BITS=64 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS @CMakeFiles/obj.clangDynamicASTMatchers.dir/includes_CXX.rsp -march=x86-64 -Og -g -Werror=date-time -fno-lifetime-dse -Wall -Wextra -Wno-unused-parameter -Wwrite-strings -Wcast-qual -Wno-missing-field-initializers -pedantic -Wno-long-long -Wimplicit-fallthrough -Wno-maybe-uninitialized -Wno-nonnull -Wno-class-memaccess -Wno-redundant-move -Wno-pessimizing-move -Wno-noexcept-type -Wdelete-non-virtual-dtor -Wsuggest-override -Wno-comment -Wno-misleading-indentation -Wctad-maybe-unsupported -fno-common -Woverloaded-virtual -fno-strict-aliasing -g -std=c++17  -fno-exceptions -funwind-tables -fno-rtti -MD -MT tools/clang/lib/ASTMatchers/Dynamic/CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj -MF CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj.d -o CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj -c E:/Note/Tool/llvm/clang/lib/ASTMatchers/Dynamic/Registry.cpp
as: CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj: too many sections (59629)
C:/Users/ADMINI~1/AppData/Local/Temp/ccCPBU8f.s: Assembler messages:
C:/Users/ADMINI~1/AppData/Local/Temp/ccCPBU8f.s: Fatal error: can't write 16 bytes to section .text of CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj: 'file too big'
as: CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj: too many sections (59629)
C:/Users/ADMINI~1/AppData/Local/Temp/ccCPBU8f.s: Fatal error: CMakeFiles/obj.clangDynamicASTMatchers.dir/Registry.cpp.obj: file too big













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

