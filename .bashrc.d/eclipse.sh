# MIT License

# Copyright (c) 2024 徐持恒 Xu Chiheng

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

eclipse_workspace_git_add_-f_prefs_files() {
	local prefs_files=(
		.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.{editors,workbench}.prefs
	)
	print_array_elements "${prefs_files[@]}"
	time_command git add -f "${prefs_files[@]}"
}

eclipse_workspace_backup_metadata_dir() {
	local current_datetime="$(print_current_datetime)"
	local base=".metadata"
	local file="${base}-${current_datetime}.tar"

	time_command tar -cf "${file}" "${base}" \
	&& time_command sha512_calculate_file "${file}"
}

# How to download Eclipse's Source code?
# https://stackoverflow.com/questions/15654475/how-to-download-eclipses-source-code
# Platform-releng/Platform Build
# https://wiki.eclipse.org/Platform-releng/Platform_Build

# Running this command in Linux VPS is fast 
# On Windows, using v2rayN Tun mode(sing-box Virtual NIC), Cygwin git is slow, and has bug to finish the cloning.
download_and_backup_eclipse_platform_source() {
	local current_datetime="$(print_current_datetime)"
	local eclipse_platform_source_dir=eclipse-platform
	local eclipse_platform_source_tarball="${eclipse_platform_source_dir}-${current_datetime}".tar
	rm -rf "${eclipse_platform_source_dir}" \
	&& time_command git clone -b master --recursive https://github.com/eclipse-platform/eclipse.platform.releng.aggregator.git "${eclipse_platform_source_dir}" \
	&& time_command tar -cvf "${eclipse_platform_source_tarball}" "${eclipse_platform_source_dir}" \
	&& time_command xz_compress -vv "${eclipse_platform_source_tarball}" \
	&& time_command sha512_calculate_file "${eclipse_platform_source_tarball}".xz
}
