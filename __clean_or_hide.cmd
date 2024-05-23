@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --exec bash -i -c "windows_clean_or_hide_home_dir_entries; read;"
