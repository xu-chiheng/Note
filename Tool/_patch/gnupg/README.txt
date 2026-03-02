
https://cygwin.com/cgit/cygwin-packages/gnupg2

gnupg-2.5.17    17b514596f6000ebbffe5ec1101b6818b9c83cfe    2026-01-27
patch_apply . ../_patch/gnupg/cygwin-runtime-rootdir-{a,b}.patch


cygwin-runtime-rootdir-{a,b}.patch
On Cygwin, modify function unix_rootdir() to use runtime rootdir instead of hardcoded build time prefix as root dir. 
This affect the function gnupg_bindir() and gnupg_libexecdir().
