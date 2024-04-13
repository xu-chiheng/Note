@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --exec bash -i -c "time_command eclipse_workspace_backup_metadata_dir; read;"
