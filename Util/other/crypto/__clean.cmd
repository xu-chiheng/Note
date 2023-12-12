@echo off

@set PATH="%CYGWIN_DIR%\bin";%PATH%

@start mintty.exe --exec bash -i -c "remove_temp_files;"
