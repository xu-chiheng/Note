#!/usr/bin/env -S bash -i

# $0 is the absolute path of the current script
cd "$(dirname "$0")"

linux_launch_program_in_background "${FILE_EXPLORER}" "$(cd .. && pwd)/~git-tools~/linux"
