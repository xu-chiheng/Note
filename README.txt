
These are the scripts I used to build GCC/Cross-GCC, Clang/LLVM, and QEMU on Cygwin and MSYS2/MinGW.

The scripts are started by bash -i, they will source the ~/.bashrc file at startup, so they can use the convenient bash functions defined there.

QEMU can only be built on MSYS2/MinGW.

Set the following Windows environment variables :
CYGWIN_DIR=D:\cygwin64
MSYS2_DIR=D:\msys64
VS2022_DIR=C:\Program Files\Microsoft Visual Studio\2022\Enterprise
VCPKG_DIR=D:\vcpkg          # optional
HOME=%USERPROFILE%          # can be any directory, like 'E:\Note'
DATA_DIR=D:\Data            # optional, only for my personal data backup

I also use one of the following commands to make a link :
ln -s ~ "$(cygpath -u 'E:\Note')"     # using Cygwin or MSYS2/MinGW bash in mintty terminal
mklink /D E:\Note %HOME%              # using Windows cmd.exe command prompt
ln -s ~ /mnt/work/Note                # using Linux bash in terminal
