#!/usr/bin/env -S bash -i

# $0 is the absolute path of the current script
cd "$(dirname "$0")"

linux_launch_program_in_background code --no-sandbox --user-data-dir=/mnt/work/Note /mnt/work/Note
