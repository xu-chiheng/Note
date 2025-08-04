#!/usr/bin/env bash
# Simulate interactive shell by sourcing user's shell configuration.
source ~/.bashrc

# Can't use "bash -i", if you want to launch ~/editor.sh(value of environment variable EDITOR) from Makefile( "make -f Makefile" ).
# Interactive shells (bash -i) are not guaranteed to work properly from Makefile targets (non-interactive context).
#!/usr/bin/env -S bash -i

open_files_in_editor "$@"
