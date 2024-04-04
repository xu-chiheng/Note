
11.4.0 029e4bda78636c2049e3298cc9c972c8328a39cb 2023-11-28

patches=(
	github-action-disable-some-checks.patch
	fix-cdt.target-IU-versions-11.4.0.patch
	rework-ProcessFactory.java.patch
	replace-toOSString-to-toString.patch
	replace-Runtime-to-ProcessFactory.patch
	replace-ProcessBuilder-to-ProcessFactory.patch
)

patches2=()

for patch in "${patches[@]}"; do
	patches2+=(  ../patch/"${patch}"  )
done

patch_apply . "${patches2[@]}"


replace-toOSString-to-toString.patch
Also pay attention to the following fields:
File.separator       java.io.File.separatorChar
IPath.SEPARATOR      org.eclipse.core.runtime.IPath.SEPARATOR
IncludeSearchPathElement.NON_SLASH_SEPARATOR
RemotePath.RUNNING_ON_WINDOWS
PATH_SEPARATOR
FILE_SEPARATOR


