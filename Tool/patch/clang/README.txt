



cygwin-CGExprCXX.cpp.patch
fix the regression caused by commit 67409911353323ca5edf2049ef0df54132fa1ca7, that, in Cygwin, Clang can't bootstrap.



commit b6259eca16f6c923d87a1ca1d424931e37d6871a
Author: Roy Jacobson <roi.jacobson1@gmail.com>
Date:   Mon Feb 13 19:14:22 2023 +0200

    [Clang] Export CanPassInRegisters as a type trait

    While working on D140664, I thought it would be nice to be able to write tests
    for parameter passing ABI. Currently we test this by dumping the AST and
    matching the results which makes it hard to write new tests.
    Adding this builtin will allow writing better ABI tests which
    can help improve our coverage in this area.

    While less useful, maybe some users would also find it useful for asserting
    against pessimisations for their classes.

    Reviewed By: erichkeane

    Differential Revision: https://reviews.llvm.org/D141775


commit 67409911353323ca5edf2049ef0df54132fa1ca7
Author: Jacob Young <jacobly0@users.noreply.github.com>
Date:   Tue Feb 28 16:42:32 2023 -0800

    [Clang][CodeGen] Fix this argument type for certain destructors

    With the Microsoft ABI, some destructors need to offset a parameter to
    get the derived this pointer, in which case the type of that parameter
    should not be a pointer to the derived type.

    Fixes #60465
https://github.com/llvm/llvm-project/issues/60465


commit acc3cc69e4d1c8e199fde51798a5a2a6edb35796
Author: Rashmi Mudduluru <r_mudduluru@apple.com>
Date:   Tue Jan 31 11:43:34 2023 -0800

    [-Wunsafe-buffer-usage] Introduce the unsafe_buffer_usage attribute

    Differential Revision: https://reviews.llvm.org/D138940






https://cygwin.com/git-cygwin-packages/
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/clang.git;a=summary
git://cygwin.com/git/cygwin-packages/clang.git
https://cygwin.com/git-cygwin-packages/?p=git/cygwin-packages/llvm.git;a=summary
git://cygwin.com/git/cygwin-packages/llvm.git

https://github.com/msys2/MINGW-packages/tree/master/mingw-w64-clang
https://github.com/msys2/MINGW-packages/blob/master/mingw-w64-clang/PKGBUILD

https://src.fedoraproject.org/rpms/llvm.git
