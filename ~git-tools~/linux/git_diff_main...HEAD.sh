#!/usr/bin/env -S bash -i

cd "$(dirname "$0")"

cd ../..

linux_terminal_execute_bash_-i -c "do_git_diff git_diff_branch...HEAD main;"
