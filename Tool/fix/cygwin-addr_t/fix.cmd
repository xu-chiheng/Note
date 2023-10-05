@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --exec bash -i -c "echo_command sed -i -e 's/typedef char \*addr_t;/typedef char \*addr_t1;/' /usr/include/machine/types.h; echo completed; read;"
