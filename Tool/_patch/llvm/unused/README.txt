

cygwin-CGCall.h.patch
Reduced number of inline elements of CallArgList.
This fix bootstraping on Cygwin, using GCC 13.2.0 as stage 0 compiler.
It seems that the size of CallArgList can't exceed an unknown limit.  
As commit 49b27b150b97c190dedf8b45bf991c4b811ed953 2023-12-09, this patch is not needed.


cygwin-disable-debug-ata.patch
Fix the regression caused by commit 7c71a09d5e712bedbed867226b3fa0bbfe789384 2024-01-10, that, in Cygwin, Clang can't bootstrap.
Stuck at cmake configure :
-- Looking for pfm_initialize in pfm
-- Looking for pfm_initialize in pfm - not found
-- Performing Test CMAKE_HAVE_LIBC_PTHREAD
