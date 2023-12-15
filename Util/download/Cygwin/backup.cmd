@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@REM can provide a directory as argument, like C:, D:, E:, to change the destination, which default to upper directory
@start mintty.exe --exec bash -i -c "time_command backup_current_directory_to_iso_file \"$@\"; read;" - ""
