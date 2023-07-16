@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --exec bash -i -c "clean_or_hide_windows_home_dir_entries; read;"
