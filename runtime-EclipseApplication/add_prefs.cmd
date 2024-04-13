@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --exec bash -i -c "add_eclipse_workspace_prefs_files_force; read;"
