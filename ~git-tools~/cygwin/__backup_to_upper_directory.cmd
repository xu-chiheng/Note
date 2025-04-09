@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@cd ../..

@start mintty.exe --exec bash -i -c "time_command do_git_backup no_gc backup_to_upper_directory; read;"
