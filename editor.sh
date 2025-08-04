#!/usr/bin/env bash
# simulate bash -i
source ~/.bashrc

# Can't use bash -i, if you want to launch editor.sh( "${EDITOR}" ) from Makefile( "make -f Makefile" ).
#!/usr/bin/env -S bash -i

open_files_in_editor "$@"
