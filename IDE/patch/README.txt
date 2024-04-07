
git format-patch -o ../patch main..HEAD

git am ../patch/*.patch



11.4.0 commit 029e4bda78636c2049e3298cc9c972c8328a39cb (tag: CDT_11_4_0) 2023-11-27


replace-toOSString-to-toString.patch
Also pay attention to the following fields:
File.separator       java.io.File.separatorChar
IPath.SEPARATOR      org.eclipse.core.runtime.IPath.SEPARATOR
IncludeSearchPathElement.NON_SLASH_SEPARATOR
RemotePath.RUNNING_ON_WINDOWS
PATH_SEPARATOR
FILE_SEPARATOR
