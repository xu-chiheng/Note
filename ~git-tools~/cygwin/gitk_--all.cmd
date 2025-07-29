@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@cd ../..

@start mintty.exe --exec bash -i -c 'startxwin "$(print_command_path gitk)" --all'
