#!/usr/bin/env -S bash -i

cd "$(dirname "$0")"

cd ../..

linux_terminal_execute_bash_-i -c "time_command do_git_backup do_gc backup_to_all_drives; read;"
