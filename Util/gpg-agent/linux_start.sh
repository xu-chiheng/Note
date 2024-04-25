#!/usr/bin/env -S bash -i

cd "$(dirname "$0")"

linux_terminal_execute_bash_-i -c "gpg_agent_start_in_background"
