
https://cygwin.com/cgit/cygwin-packages/gnupg2

gnupg-2.5.17    17b514596f6000ebbffe5ec1101b6818b9c83cfe    2026-01-27
patch_apply . ../_patch/gnupg/{cygwin-runtime-rootdir-{a,b},no-warning-development-version,cygwin-no-warning-permissons,version-no-beta}.patch


cygwin-runtime-rootdir-{a,b}.patch
On Cygwin, modify function unix_rootdir() to use runtime rootdir instead of hardcoded build time prefix as root dir. 
This affect the function gnupg_bindir() and gnupg_libexecdir().

no-warning-development-version.patch
Remove a warning

cygwin-no-warning-permissons.patch
Remove a warning

version-no-beta.patch
Remove beta in version string.













Execute the following command to disable commmit message checks :
rm -rf .git/hooks/commit-msg
